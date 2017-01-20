function Get-AtlassianSession {
	<#
	.SYNOPSIS
		Get the current AtlassianSession or creates a new one if none exists

	.DESCRIPTION
		#ToDo
	
	.EXAMPLE
		#ToDo

	.OUTPUTS
		AtlassianSession
	#>
	[CmdletBinding()]
	Param(
		[Parameter(
			Mandatory = $false,
			Position = 1
		)]
	    [System.String] $Path,
		[Parameter(
			Mandatory = $false
		)]
		[Alias('NoNew')]
		[Switch] $NoNewSession
	)
	Begin{
		$SESSIONVARIABLENAME = $SETTINGS.Session.VariableName

		function Import-AtlassianSession {
			<#
			.SYNOPSIS
				Load an AtlassianSession object from a given XML-document

			.DESCRIPTION
				The Import-AtlassianSession allow you to easily load an AtlassianSession object from disk in a relativelysecure manner.
				The source on-disk session file can only be decrypted by the same user account which performed the encryption.
				For more details, see the help files for ConvertFrom-SecureString and ConvertTo-SecureString as well as	MSDN pages about Windows Data Protection API.

			.OUTPUTS
				AtlassianSession
			#>
			[CmdletBinding()]
			Param (
				[Parameter(
					Mandatory = $true
				)]
				[String] $Path
			)

			# Check Path
			if(-not (Test-Path $Path -PathType Leaf)){
				Throw "Invalid Path."
			}

			# Import credential file
			$import = Import-Clixml $Path 

			# Test for valid import
			if ($import.PSObject.TypeNames -notcontains 'Deserialized.ExportedAtlassianSession') {
				Throw "Input is not a valid ExportedAtlassianSession object."
			}
			$server = $import.Server
			$username = $import.Username
			# Decrypt the password and store as a SecureString object for safekeeping
			$securePass = $import.EncryptedPassword | ConvertTo-SecureString

			# Create new AtlassianSession
			New-AtlassianSession -Server $server -Credential (New-Object System.Management.Automation.PSCredential $username, $securePass)
		}
	}
	Process{
		if($Path){
			if(Test-Path variable:global:$SESSIONVARIABLENAME){
				if($NoNewSession){
					Get-Variable -Name $SESSIONVARIABLENAME -ValueOnly
				} else {
					Import-AtlassianSession -Path $Path
				}
			} else {
				Import-AtlassianSession -Path $Path
			}
		} elseif(Test-Path variable:global:$SESSIONVARIABLENAME){
			Get-Variable -Name $SESSIONVARIABLENAME -ValueOnly
		} else {
			if(-not $NoNewSession){
				New-AtlassianSession
			}
		}
	}
	End{}
}