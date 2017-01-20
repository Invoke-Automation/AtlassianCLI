function Invoke-APIRequest {
	<#
	.SYNOPSIS
		Short description
	.DESCRIPTION
		Long description
	.EXAMPLE
		C:\PS> <example usage>
		Explanation of what the example does
	.INPUTS
		Inputs (if any)
	.OUTPUTS
		Output (if any)
	.NOTES
		General notes
	#>
	[CmdletBinding()]
	Param(
		[Parameter(
			Mandatory = $true
		)]
		[String] $Method,
		[Parameter(
			Mandatory = $true
		)]
		[String] $Uri,
		[Parameter(
			Mandatory = $false
		)]
		[String] $Body,
		[Parameter(
			Mandatory = $true
		)]
		[AtlassianSession] $Session
	)
	Begin{}
	Process{
		if(-not $Uri.StartsWith('http')){
			if(-not $Uri.StartsWith('/')){
				$Uri = '/' + $Uri
			}
			$Uri = ('{0}{1}' -f $Session.Server,$Uri)
		}
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Session.Credential.UserName,([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Session.Credential.Password))))))
		if($Body){
			Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -Method $Method -Uri $Uri -Body $Body
		} else {
			Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)} -Method $Method -Uri $Uri
		}
	}
	End{}
}