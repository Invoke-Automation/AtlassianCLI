function New-AtlassianSession {
	<#
		.SYNOPSIS
			Initialises a new AtlassianSession
		.DESCRIPTION
			The New-AtlassianSession cmdlet creates a new AtlassianSession object.
			If no current AtlassianSession is saved in the custom session variable (name specified in settings.xml) the newly created AtlassianSession will be saved in this variable.
			If the custom session variable already has a value you will be prompted whether or not you want to replace it.
		.PARAMETER Server
			Specifies the Server URL to be used for the session.
		.PARAMETER Credential
			Specifies the Credentials to be used for the session.
		.EXAMPLE
			PS C:\> New-AtlassianSession -Server 'http://localhost:2990/jira'
			Creates a new AtlassianSession that connects to the jira test environment running on your localhost.
			Credentials will be prompted.
		.INPUTS
			None
			You cannot pipe input to this cmdlet.
		.OUTPUTS
			AtlassianSession
			Returns the newly created AtlassianSession object. (even if it is not saved)
		.NOTES
			The AtlassianSession object has a Save(<Path>) method that can be called to save an encrypted session file to disk.
			Encrypted session files can only be used by the same user account.
	#>
	[CmdletBinding(
		SupportsShouldProcess = $true,
		HelpURI="https://invoke-automation.github.io/AtlassianCLI/New-AtlassianSession"
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