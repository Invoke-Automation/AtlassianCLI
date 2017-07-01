# TestEnvironment variables
$testEnvironmentURL = 'http://localhost:2990/jira'
$testEnvironmentUser = "Admin"
$testEnvironmentPassword = "admin"
$testEnvironmentCredential = [System.Management.Automation.PSCredential]::New($testEnvironmentUser, (ConvertTo-SecureString $testEnvironmentPassword -AsPlainText -Force))
$testEnvironmentAtlassianSession = 'AtlassianSession.enc.xml'

function Test-TestEnvironmentConnection {
	Param(
		[Parameter(Mandatory=$true,Position=1)]
		[String] $URL,
		[Parameter(Mandatory=$false)]
		[int] $MaxAttempts = 1

	)
	# Check if environment is online
	# First we create the request.
	$HTTP_Request = [System.Net.WebRequest]::Create($URL)
	$siteOnline = $false
	$connectionAttempts = 0
	while((-not $siteOnline) -and ($connectionAttempts -lt $MaxAttempts)){
		try{
			# We then get a response from the site.
			$HTTP_Response = $HTTP_Request.GetResponse()
			$siteOnline = $true
		} catch {
			$connectionAttempts++
			Write-Host "Site is not online.`nIf you are using Atlassian SDK start a clean environment by running `'atlas-run-standalone --product jira`'"
			Start-Sleep -Seconds 60
		}
	}
	# Finally, we clean up the http request by closing it.
	$HTTP_Response.Close()
	$siteOnline
}