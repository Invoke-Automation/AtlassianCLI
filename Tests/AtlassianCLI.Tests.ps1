Describe -Name "AtlassianSession" -Fixture {
	. "$PSScriptRoot\TestHelpers.ps1"
	Import-Module "$PSScriptRoot\..\AtlassianCLI" -Force
	If(Test-TestEnvironmentConnection -URL $testEnvironmentURL){
		It 'Can create a New AtlassianSession' {
			{ $session =  New-AtlassianSession -Server $testEnvironmentURL -Credential $testEnvironmentCredential } | Should Not Throw
		}
		
		It 'Returns an AtlassianSession Object' {
			$session =  New-AtlassianSession -Server $testEnvironmentURL -Credential $testEnvironmentCredential
			$session.GetType() | Should Be 'AtlassianSession'
		}

		It 'Saves an AtlassianSession File' {
			if(Test-Path $testEnvironmentAtlassianSession){
				Remove-Item $testEnvironmentAtlassianSession
			}
			$session =  New-AtlassianSession -Server $testEnvironmentURL -Credential $testEnvironmentCredential
			$session.Save($testEnvironmentAtlassianSession)
			$testEnvironmentAtlassianSession | Should Exist
		}

		It 'Can Import a saved AtlassianSession File' {
			{ $newSession = Get-AtlassianSession -Path $testEnvironmentAtlassianSession } | Should Not Throw
		}

		It 'Imports the AtlassianSession File correctly' {
			$session =  New-AtlassianSession -Server $testEnvironmentURL -Credential $testEnvironmentCredential
			$newSession = Get-AtlassianSession -Path $testEnvironmentAtlassianSession
			$newSession.GetType() | Should Be 'AtlassianSession'
			$newSession.Server | Should BeLike $session.Server
			$newSession.Credential.UserName | Should BeLike $session.Credential.UserName
			# ($newSession.Credential.Password | ConvertFrom-SecureString) | Should BeLike ($session.Credential.Password | ConvertFrom-SecureString)
		}
	} else {
		throw 'No Test Enviroment'
	}
}

Describe -Name "Get-JIRAProject" -Fixture {
	. "$PSScriptRoot\TestHelpers.ps1"
	Import-Module "$PSScriptRoot\..\AtlassianCLI" -Force
	If(Test-TestEnvironmentConnection -URL $testEnvironmentURL){
		It 'Can Get All JIRAProject' {
			{ $projects = Get-JIRAProject -All } | Should Not Throw
		}

		It 'Can Get JIRAProject with Key' {
			$projectKey = (Get-JIRAProject -All | Select-Object -First 1).Key
			{ $project = Get-JIRAProject -Key $projectKey } | Should Not Throw
		}

		It 'Can Get JIRAProject with Name' {
			$projectName = (Get-JIRAProject -All | Select-Object -First 1).Name
			{ $project = Get-JIRAProject -Name $projectName } | Should Not Throw
		}

		It 'Returns JIRAProject Objects' {
			$projects = Get-JIRAProject -All
			$projects | ForEach-Object{
				$_.GetType() | Should Be 'JIRAProject'
			}
		}
	} else {
		throw 'No Test Enviroment'
	}
}

Describe -Name "Get-JIRAIssue" -Fixture {
	. "$PSScriptRoot\TestHelpers.ps1"
	Import-Module "$PSScriptRoot\..\AtlassianCLI" -Force
	If(Test-TestEnvironmentConnection -URL $testEnvironmentURL){
		It 'Can Get JIRAIssue with JQL' {
			$project = Get-JIRAProject -All | Select-Object -First 1
			{ $issues = Get-JIRAIssue -Jql ('project={0}' -f $project.Key) } | Should Not Throw
		}

		It 'Can Get JIRAIssue with Key' {
			$project = Get-JIRAProject -All | Select-Object -First 1
			$issueKey = (Get-JIRAIssue -Jql ('project={0}' -f $project.Key) | Select-Object -First 1).Key
			{ $issue = Get-JIRAIssue -Key $issueKey } | Should Not Throw
		}

		It 'Returns JIRAProject Objects' {
			$project = Get-JIRAProject -All | Select-Object -First 1
			$issues = Get-JIRAIssue -Jql ('project={0}' -f $project.Key)
			$issues | ForEach-Object{
				$_.GetType() | Should Be 'JIRAIssue'
			}
		}
	} else {
		throw 'No Test Enviroment'
	}
}

Describe -Name 'Add-JIRAIssue' -Fixture {
	. "$PSScriptRoot\TestHelpers.ps1"
	Import-Module "$PSScriptRoot\..\AtlassianCLI" -Force
	If(Test-TestEnvironmentConnection -URL $testEnvironmentURL){
		It 'Can Add new JIRAIssue with properties' {
			$project = Get-JIRAProject -All | Select-Object -First 1
			{$issue = Add-JIRAIssue -Project $project.Key -IssueType 'Task' -Summary 'Test'} | Should Not Throw
		}

		It 'Throws error when Add new JIRAIssue without required properties' {
			$project = Get-JIRAProject -All | Select-Object -First 1
			{$issue = Add-JIRAIssue -Project $project.Key -IssueType 'Task'} | Should Not Throw
		}

		It 'Returns JIRAIssue Object' {
			$project = Get-JIRAProject -All | Select-Object -First 1
			$issue = Add-JIRAIssue -Project $project.Key -IssueType 'Task' -Summary 'Test'
			$issue | ForEach-Object{
				$_.GetType() | Should Be 'JIRAIssue'
			}
		}
	} else {
		throw 'No Test Enviroment'
	}
}

# LEGACY TESTS

# PROJECTS
# Test Get functionality
# $project = Get-JIRAProject -All | Select-Object -First 1
# if($project){
# 	# ISSUES
# 	# Test Get functionality
# 	$issues = Get-JIRAIssue -Jql ('project={0}' -f $project.Key)

# 	# Test Add functionality
# 	$createdTask = Add-JIRAIssue -Project $project -IssueType 'Task' -Summary 'Big Test' -Description 'Big Issue' -Assignee 'Test' -Priority 'Highest' -FixVersions 'Test Version' -Components 'Test Component' -TimeEstimate (New-TimeSpan -Hours 1) -Properties @{labels=@('test','demo')} -Debug	
# 	$createdSubTask = Add-JIRAIssue -Project $project -IssueType 'Sub-task' -Summary 'Sub-Task Test' -Description 'Smaller issue' -Reporter 'Test' -Assignee 'Test' -Priority 'Low' -Versions 'Test Version' -ParentTaskKey $createdTask.key -Properties @{labels=@('uber')} -Debug
# }

# try{
# 	if($PSScriptRoot){
# 		Import-Module "$PSScriptRoot\..\AtlassianCLI" -Force
# 	} elseif(Test-Path '.\AtlassianCLI\AtlassianCLI.psm1') {
# 		Import-Module '.\AtlassianCLI' -Force
# 	} else {
# 		throw 'No Module Found!'
# 	}
# } catch {
# 	Write-Warning 'something went wrong loading AtlassianCLI module'
# 	throw $_
# }

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