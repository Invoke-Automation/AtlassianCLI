$testEnvironmentURL = 'http://localhost:2990/jira'
$testEnvironmentUser = "Admin"
$testEnvironmentPassword = "admin"
$testEnvironmentCredential = [System.Management.Automation.PSCredential]::New($testEnvironmentUser, (ConvertTo-SecureString $testEnvironmentPassword -AsPlainText -Force))
$testEnvironmentAtlassianSession = '.\Tests\AtlassianSession.enc.xml'

# Import AtlassianCLI module
try{
	if($PSScriptRoot){
		Import-Module "$PSScriptRoot\..\AtlassianCLI" -Force
	} elseif(Test-Path '.\AtlassianCLI\AtlassianCLI.psm1') {
		Import-Module '.\AtlassianCLI' -Force
	} else {
		throw 'No Module Found!'
	}
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

# Get or Setup session
if(Test-Path $testEnvironmentAtlassianSession){
	$session = Get-AtlassianSession -Path $testEnvironmentAtlassianSession
} else {
	$session =  New-AtlassianSession -Server $testEnvironmentURL -Credential $testEnvironmentCredential
	$session.save($testEnvironmentAtlassianSession)
}

# PROJECTS
# Test Get functionality
$project = Get-JIRAProject -All | Select-Object -First 1
if($project){
	# ISSUES
	# Test Get functionality
	$issues = Get-JIRAIssue -Jql ('project={0}' -f $project.Key)

	# Test Add functionality
	$createdTask = Add-JIRAIssue -Project $project -IssueType 'Task' -Summary 'Big Test' -Description 'Big Issue' -Assignee 'Test' -Priority 'Highest' -FixVersions 'Test Version' -Components 'Test Component' -TimeEstimate (New-TimeSpan -Hours 1) -Properties @{labels=@('test','demo')} -Debug	
	$createdSubTask = Add-JIRAIssue -Project $project -IssueType 'Sub-task' -Summary 'Sub-Task Test' -Description 'Smaller issue' -Reporter 'Test' -Assignee 'Test' -Priority 'Low' -Versions 'Test Version' -ParentTaskKey $createdTask.key -Properties @{labels=@('uber')} -Debug
}






# LEGACY TESTS

# $session =  New-AtlassianSession -Server $testEnvironmentURL -Credential $testEnvironmentCredential
# $base64AuthInfo = [Convert]::ToBase64String(
# 	[Text.Encoding]::ASCII.GetBytes(
# 		("{0}:{1}" -f $session.Credential.UserName,([Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($session.Credential.Password))))
# 		)
# 	)

# [String] $target = "http://localhost:2990"
# [String] $projectKey = "TEST"
# [String] $issueType = "Task"
# [String] $summary = "summary"
# [String] $description = "description"
# [String] $priority = "2"
  
# [String] $body = '{"fields":{"project":{"key":"'+$projectKey+'"},"issuetype":{"name": "'+$issueType+'"},"summary":"'+$summary+'","description":"'+$description+'", "priority":{"id":"'+$priority+'"}}}'
  
# function ConvertTo-Base64($string) {
# 	$bytes = [System.Text.Encoding]::UTF8.GetBytes($string)
# 	$encoded = [System.Convert]::ToBase64String($bytes)
# 	return $encoded
# }

# try {
# 	$auth = "Basic " + $base64AuthInfo
	
# 	$webRequest = [System.Net.WebRequest]::Create($session.Server+"/rest/api/2/issue/")
# 	$webRequest.ContentType = "application/json"
# 	$BodyStr = [System.Text.Encoding]::UTF8.GetBytes($request)
# 	$webrequest.ContentLength = $BodyStr.Length
# 	$webRequest.ServicePoint.Expect100Continue = $false
# 	$webRequest.Headers.Add("Authorization", $auth)
# 	$webRequest.PreAuthenticate = $true
# 	$webRequest.Method = "POST"
# 	$requestStream = $webRequest.GetRequestStream()
# 	$requestStream.Write($BodyStr, 0, $BodyStr.length)
# 	$requestStream.Close()
# 	[System.Net.WebResponse] $resp = $webRequest.GetResponse()
	
# 	$rs = $resp.GetResponseStream()
# 	[System.IO.StreamReader] $sr = New-Object System.IO.StreamReader -argumentList $rs
# 	[string] $results = $sr.ReadToEnd()
# 	Write-Output $results
# } catch [System.Net.WebException] {
# 	if ($_.Exception -ne $null -and $_.Exception.Response -ne $null) {
# 		$errorResult = $_.Exception.Response.GetResponseStream()
# 		$errorText = (New-Object System.IO.StreamReader($errorResult)).ReadToEnd()
# 		Write-Warning "The remote server response: $errorText"
# 		Write-Output $_.Exception.Response.StatusCode
# 	} else {
# 		throw $_
# 	}
# }