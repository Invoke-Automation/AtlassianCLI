function New-AtlassianSession {
	<#
	.SYNOPSIS
		Creates a new AtlassianSession object and saves it in a session variable

	.DESCRIPTION
		#ToDo
	
	.PARAMETER Server
		The Server to be used for the session
	
	.PARAMETER Credential
		The Credential to be used for the session
	
	.EXAMPLE
		#ToDo

	.OUTPUTS
		AtlassianSession
	#>
	[CmdletBinding(
		SupportsShouldProcess = $true
	)]
	Param(
		[Parameter(
			Mandatory = $true
		)]
		[System.String] $Server,
		[Parameter(
			Mandatory = $true
		)]
		[System.Management.Automation.PSCredential] $Credential = (Get-Credential -Message "Enter Atlassian user credentials")
	)
	Begin{
		$SESSIONVARIABLENAME = $SETTINGS.Session.VariableName
	}
	Process{
		$sessionObject = New-Object AtlassianSession -Property @{
				Credential = $Credential
				Server = $Server
			}
		if(Test-Path variable:global:$SESSIONVARIABLENAME){
			if($PSCmdlet.ShouldProcess(
				"If you confirm the current session variable will be replaced by the new one.",
				"Are you sure you want to replace the current session?",
				"Replace current session")){
				Set-Variable -Name $SESSIONVARIABLENAME -Value $sessionObject -Visibility 'Public' -Scope 'Global'
			}
		} else {
			Set-Variable -Name $SESSIONVARIABLENAME -Value $sessionObject -Visibility 'Public' -Scope 'Global'
		}
		return $sessionObject
	}
	End{}
}