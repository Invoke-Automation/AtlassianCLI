function Invoke-APIRequest {
	<#
		.SYNOPSIS
			Invokes an API request
		.DESCRIPTION
			The Invoke-APIRequest cmdlet creates the authentication headers and passes through all other info to the Invoke-RestMethod.
			The output of this Invoke-RestMethod is directly passed through.
		.PARAMETER Method
			Specifies the method to be used to run the Invoke-RestMethod cmdlet.
		.PARAMETER Uri
			Specifies the uri to be used to run the Invoke-RestMethod cmdlet.
			If the uri does not start with http or https it will be appended to the server url from the provided AtlassianSession.
		.PARAMETER Body
			Specifies the body to be used to run the Invoke-RestMethod cmdlet.
		.PARAMETER Session
			Specifies the AtlassianSession to use to create the authentication header.
			If none is specified Get-AtlassianSession is called.
		.EXAMPLE
			C:\PS> Invoke-APIRequest -Method 'POST' -Uri 'rest/api/2/issue/' -Body $requestBody -Session $Session
			Uses the info in the provided $Session to creates a new issue with the info in the $requestBody
		.INPUTS
			None
			You cannot pipe input to this cmdlet.
		.OUTPUTS
			System.Xml.XmlDocument, Microsoft.PowerShell.Commands.HtmlWebResponseObject, System.String
			The output of the cmdlet depends upon the format of the content that is retrieved.

			PSObject
			If the request returns JSON strings, Invoke-RestMethod returns a PSObject that represents the strings.
		.NOTES
		.LINK
			http://docs.invoke-automation.com
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
	Begin {}
	Process {
		if (-not $Uri.StartsWith('http')) {
			if (-not $Uri.StartsWith('/')) {
				$Uri = '/' + $Uri
			}
			$Uri = ('{0}{1}' -f $Session.Server, $Uri)
		}
		Write-Debug -Message ('Method:{0} Uri:{1}' -f $method, $uri)
		$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Session.Credential.UserName, ([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Session.Credential.Password))))))
		$headers = @{Authorization = ("Basic {0}" -f $base64AuthInfo)}
		if ($Body) {
			Invoke-RestMethod -Headers $headers -Method $Method -Uri $Uri -Body $Body -ContentType 'application/json'
		} else {
			Invoke-RestMethod -Headers $headers -Method $Method -Uri $Uri
		}
	}
	End {}
}