$testEnvironmentURL = 'http://localhost:2990/jira'
$testEnvironmentUser = "Admin"
$testEnvironmentPassword = "admin"
$testEnvironmentCredential = [System.Management.Automation.PSCredential]::New($testEnvironmentUser, (ConvertTo-SecureString $testEnvironmentPassword -AsPlainText -Force))

try{
	$debug = "$PSScriptRoot\..\AtlassianCLI"
	Import-Module $PSScriptRoot\..\AtlassianCLI -Force
} catch {
	Write-Warning 'something went wrong loading AtlassianCLI module'
	throw $_
}

# Check if environment is online

$maxAttempts = 1

# First we create the request.
$HTTP_Request = [System.Net.WebRequest]::Create($testEnvironmentURL)
$siteOnline = $false
$connectionAttempts = 0
while((-not $siteOnline) -and ($connectionAttempts -lt $maxAttempts)){
	try{
		# We then get a response from the site.
		$HTTP_Response = $HTTP_Request.GetResponse()
		$siteOnline = $true
	} catch {
		$connectionAttempts++
		Write-Information -MessageData "Site is not online.`nIf you are using Atlassian SDK start a clean environment by running `'atlas-run-standalone --product jira`'"
		Start-Sleep -Seconds 60
	}
}
# Finally, we clean up the http request by closing it.
$HTTP_Response.Close()


$session =  New-AtlassianSession -Server $testEnvironmentURL -Credential $testEnvironmentCredential
$project = Get-JIRAProject -All | Select-Object -First 1
if($project){
	$issues = Get-JIRAIssue -Jql ('project={0}' -f $project.Key)
}