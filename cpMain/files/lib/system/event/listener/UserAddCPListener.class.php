<?php
/*
 * Copyright (c) 2009 Tobias Friebel
 * Authors: Tobias Friebel <TobyF@Web.de>
 *
 * Lizenz: GPL
 *
 * $Id$
 */

require_once(WCF_DIR.'lib/system/event/EventListener.class.php');

class UserAddCPListener implements EventListener
{
	private static $cpUser;
	
	/**
	 * @see EventListener::execute()
	 */
	public function execute($eventObj, $className, $eventName)
	{
		if ($eventName == 'readParameters' && $className == 'UserAddForm')
		{
			$sql = "SELECT 	username AS name
					FROM 	wcf" . WCF_N . "_user
					ORDER BY SUBSTRING_INDEX(username, '" . USER_PREFIX . "', -1) + 0 DESC
					LIMIT 1";
			$postFix = WCF :: getDB()->getFirstRow($sql);

			if (empty($postFix))
			{
				$eventObj->username = USER_PREFIX . '1';
			}
			else
			{
				$postFix = intval(str_replace(USER_PREFIX, '', $postFix['name']));
				$eventObj->username = USER_PREFIX . ++$postFix;
			}

			$eventObj->adminname = WCF :: getUser()->username;
			$eventObj->adminID = WCF :: getUser()->userID;
			$eventObj->user->isCustomer = 0;
		}
		elseif ($eventName == 'readData' && $className == 'UserEditForm')
		{
			self :: $cpUser = new CPUser($eventObj->userID);
			$eventObj->user->isCustomer = self :: $cpUser->isCustomer;

			$u = new User(self :: $cpUser->adminID);
			$eventObj->adminname = $u->username;
			$eventObj->adminID = $u->userID;
		}
		elseif ($eventName == 'readFormParameters')
		{
			if (isset($_POST['adminname'])) $eventObj->adminname = StringUtil::trim($_POST['adminname']);
			if (isset($_POST['isCustomer'])) $eventObj->user->isCustomer = intval($_POST['isCustomer']);
			else $eventObj->user->isCustomer = 0;
		}
		elseif ($eventName == 'validate')
		{
			if (!preg_match('/^[a-z0-9\-_]+$/i', $eventObj->username))
			{
				$eventObj->errorType['username'] = 'notValid';
			}
			
			if (!WCF :: getUser()->getPermission('admin.general.isSuperAdmin'))
			{
				try 
				{
					// get admin
					$user = new UserSession(null, null, $eventObj->adminname);
					if (!$user->userID) 
					{
						throw new UserInputException('adminname', 'notFound');
					}
					
					if (!$user->getPermission('admin.general.canUseAcp'))
					{
						throw new UserInputException('adminname', 'notValid');
					}
						
					$eventObj->adminID = $user->userID;
				}
				catch (UserInputException $e) 
				{
					$this->errorType[$e->getType()] = $e->getType();
				}
			}
		}
		elseif ($eventName == 'saved')
		{
			if (!$eventObj->user->homedir)
			{
				// create cp user record
				$sql = "INSERT IGNORE INTO	cp" . CP_N . "_user
								(userID,
								 adminID,
								 isCustomer,
								 cpLastActivityTime
								)
						VALUES	(" . $eventObj->user->userID . ",
								 " . $eventObj->adminID . ",
								 " . $eventObj->user->isCustomer . ",
								 " . TIME_NOW . " 
								)";
				WCF :: getDB()->sendQuery($sql);
			}
		}
		elseif ($eventName == 'assignVariables')
		{
			WCF :: getTPL()->assign('adminname', $eventObj->adminname);
			WCF :: getTPL()->assign('isCustomer', $eventObj->user->isCustomer);
			WCF :: getTPL()->append('additionalFields', WCF :: getTPL()->fetch('userAddAdmin'));
		}
	}
}
?>
