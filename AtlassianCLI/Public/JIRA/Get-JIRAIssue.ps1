function Get-JIRAIssue {
	<#
	.SYNOPSIS
		Get a Jira Issue using the Invoke-JIRAExpression

	.DESCRIPTION
		#ToDo
	
	.PARAMETER Jql
		#ToDo
	
	.PARAMETER Session
		#ToDo
	
	.EXAMPLE
		#ToDo

	.OUTPUTS
		System.Management.Automation.PSObject
	#>
	[CmdletBinding(
		#SupportsShouldProcess=$true
	)]
	Param(
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
		if($JQL){
			$method = 'GET'
			$uriTemplate = '/rest/api/latest/search?jql={0}&startAt=0&maxResults={1}'
			$totalIssues = (Invoke-APIRequest -Method $method -Uri ($uriTemplate -f (Format-Jql $Jql),1) -Session $Session).total
			if($totalIssues -gt 0){
				$uri = ('/rest/api/latest/search?jql={0}&startAt=0&maxResults={1}' -f (Format-Jql $Jql),$totalIssues)
				$requestResult = Invoke-APIRequest -Method $method -Uri $uri -Session $Session
			}		
		}
		if($requestResult -ne $null){
			$output = @()
			foreach($obj in $requestResult.issues) {
				$output += New-JIRAIssue -Uri $obj.self
			}
			$output
		} else {
			throw 'No result for request'
		}
	}
	End{}
}