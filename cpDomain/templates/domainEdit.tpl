{include file="documentHeader"}
<head>
	<title>{lang}cp.domain.list{/lang} - {PAGE_TITLE}</title>

	{include file='headInclude' sandbox=false}

	<script type="text/javascript" src="{@RELATIVE_WCF_DIR}js/Suggestion.class.js"></script>
	<script type="text/javascript" src="{@RELATIVE_WCF_DIR}js/TabMenu.class.js"></script>
	<script src="{@RELATIVE_WCF_DIR}js/Calendar.class.js" type="text/javascript"></script>
	<script type="text/javascript">
		//<![CDATA[
		var tabMenu = new TabMenu();
		{if $options|count}onloadEvents.push(function() { tabMenu.showSubTabMenu('{@$options.0.categoryName}') });{/if}
		//]]>
	</script>
</head>
<body>
{include file='header' sandbox=false}

<div id="main">

	<div class="mainHeadline">
		<img src="{@RELATIVE_WCF_DIR}icon/domain{@$action|ucfirst}L.png" alt="" />
		<div class="headlineContainer">
			<h2>{lang}cp.acp.domain.{@$action}{/lang}</h2>
		</div>
	</div>
	
	{if $errorField}
		<p class="error">{lang}wcf.global.form.error{/lang}</p>
	{/if}
	
	{if $success|isset}
		<p class="success">{lang}cp.acp.domain.{@$action}.success{/lang}</p>	
	{/if}
	
	<div class="contentHeader">
		<div class="largeButtons">
			<ul>
				<li><a href="index.php?page=DomainList&amp;packageID={@PACKAGE_ID}{@SID_ARG_2ND}" title="{lang}cp.acp.menu.link.domains.list{/lang}"><img src="{@RELATIVE_WCF_DIR}icon/groupM.png" alt="" /> <span>{lang}cp.acp.menu.link.domains.list{/lang}</span></a></li>
				{if $additionalLargeButtons|isset}{@$additionalLargeButtons}{/if}
			</ul>
		</div>
	</div>
	<form method="post" action="index.php?form=Domain{@$action|ucfirst}">
		<div class="border content">
			<div class="container-1">
				<fieldset>
					<legend>{lang}cp.acp.domain.data{/lang}</legend>
					
					<div class="formElement{if $errorType.domainname|isset} formError{/if}" id="domainnameDiv">
						<div class="formFieldLabel">
							<label for="domainname">{lang}cp.acp.domain.domainname{/lang}</label>
						</div>
						<div class="formField">
							{$domainname}
						</div>
					</div>
					
					{if $additionalFields|isset}{@$additionalFields}{/if}
				</fieldset>
			
				{if $additionalFieldSets|isset}{@$additionalFieldSets}{/if}
			
				{if $options|count || $additionalTabs|isset}
				<div class="tabMenu">
					<ul>
						{foreach from=$options item=categoryLevel1}
							<li id="{@$categoryLevel1.categoryName}"><a onclick="tabMenu.showSubTabMenu('{@$categoryLevel1.categoryName}');"><span>{lang}cp.domain.option.category.{@$categoryLevel1.categoryName}{/lang}</span></a></li>
						{/foreach}
						
						{if $additionalTabs|isset}{@$additionalTabs}{/if}
					</ul>
				</div>
				<div class="subTabMenu">
					<div class="containerHead"><div> </div></div>
				</div>
				
				{foreach from=$options item=categoryLevel1}
					<div class="border tabMenuContent hidden" id="{@$categoryLevel1.categoryName}-content">
						<div class="container-1">
							<h3 class="subHeadline">{lang}cp.domain.option.category.{@$categoryLevel1.categoryName}{/lang}</h3>
							
							{foreach from=$categoryLevel1.categories item=categoryLevel2}
								<fieldset>
									<legend>{lang}cp.domain.option.category.{@$categoryLevel2.categoryName}{/lang}</legend>
									
									{include file='domainOptionFieldList' options=$categoryLevel2.options}
								</fieldset>
							{/foreach}
						</div>
					</div>
				{/foreach}
			{/if}
			</div>
		</div>
		
		<div class="formSubmit">
			{@SID_INPUT_TAG}
			{@SECURITY_TOKEN_INPUT_TAG}
	 		<input type="hidden" name="action" value="{@$action}" />
	 		{if $domainID|isset}<input type="hidden" name="domainID" value="{@$domainID}" />{/if}
	 		<input type="submit" accesskey="s" value="{lang}wcf.global.button.submit{/lang}" />
			<input type="reset" accesskey="r" value="{lang}wcf.global.button.reset{/lang}" />
	 	</div>
	</form>
	
</div>

{include file='footer'}