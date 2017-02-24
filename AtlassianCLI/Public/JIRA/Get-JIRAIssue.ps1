function Get-JIRAIssue {
	<#
		.SYNOPSIS
			Get one or more JIRAIssue objects.
		.DESCRIPTION
			The Get-JIRAIssue cmdlet gets a specified JIRAIssue object or performs a search to get multiple JIRAIssue objects.
		.PARAMETER Key
			Specifies the key to be used to retrieve the JIRAIssue object(s).
		.PARAMETER Jql
			Specifies the JQL filter to be used to retrieve the JIRAIssue object(s).
		.PARAMETER Session
			Specifies the AtlassianSession to use to perform this task.
			If none is specified Get-AtlassianSession is called.
		.EXAMPLE
			PS C:\> Get-JIRAIssue -Jql 'project=TEST'
			Gets all issues returned by the JQL filter 'project=TEST' for the currently loaded session.
		.INPUTS
			None
			You cannot pipe input to this cmdlet.
		.OUTPUTS
			JIRAIssue
			Returns one or more JIRAIssue objects.
		.NOTES
	#>
	[CmdletBinding(
		#SupportsShouldProcess=$true,
		HelpURI="https://github.com/Invoke-Automation/AtlassianCLI/Get-JIRAIssue.md"
	)]
	Param(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = 'Key'
		)]
		[String] $Key,
		[Parameter(
			Mandatory = $true,
			ParameterSetName = 'JQL'
		)]
		[String] $Jql,
		[Parameter(
			Mandatory = $false
		)]
		[AtlassianSession] $Session = (Get-AtlassianSession)
	)
	Begin{
		function Format-Jql {
			Param(
				[Parameter(
					Mandatory = $true
				)]
				[String] $Jql
			)
			$Jql -replace ' ','+'
		}
	}
	Process{
		if($Key){
			$method = 'GET'
			$uri = ('{0}/issue/{1}' -f $SETTINGS.API.Uri,$Key)
			$requestResult = Invoke-APIRequest -Method $method -Uri $uri -Session $Session
			if($requestResult -ne $null){
				New-JIRAIssue -Uri $requestResult.self
			} else {
				$null
			}
		} elseif($JQL){
			$method = 'GET'
			$uriTemplate = ('{0}/search?jql={0}&startAt=0&maxResults={1}' -f $SETTINGS.API.Uri)
			$totalIssues = (Invoke-APIRequest -Method $method -Uri ($uriTemplate -f (Format-Jql $Jql),1) -Session $Session).total
			if($totalIssues -gt 0){
				$uri = ('{0}/search?jql={1}&startAt=0&maxResults={2}' -f $SETTINGS.API.Uri,(Format-Jql $Jql),$totalIssues)
				$requestResult = Invoke-APIRequest -Method $method -Uri $uri -Session $Session
			}
			if($requestResult -ne $null){
				$output = @()
				foreach($obj in $requestResult.issues) {
					$output += New-JIRAIssue -Uri $obj.self
				}
				$output
			} else {
				$null
			}
		}
	}
	End{}
}