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
		It 'Can Add new JIRAIssue with properties using Project' {
			$project = Get-JIRAProject -All | Select-Object -First 1
			{$issue = Add-JIRAIssue -Project $project -IssueType 'Task' -Summary 'Test'} | Should Not Throw
		}

		It 'Can Add new JIRAIssue with properties using ProjectKey' {
			$project = Get-JIRAProject -All | Select-Object -First 1
			{$issue = Add-JIRAIssue -ProjectKey $project.Key -IssueType 'Task' -Summary 'Test'} | Should Not Throw
		}

		It 'Throws error when Add new JIRAIssue without required properties' {
			$project = Get-JIRAProject -All | Select-Object -First 1
			{$issue = Add-JIRAIssue -Project $project -IssueType 'Task'} | Should Throw 'required field'
		}

		It 'Returns JIRAIssue Object' {
			$project = Get-JIRAProject -All | Select-Object -First 1
			$issue = Add-JIRAIssue -Project $project -IssueType 'Task' -Summary 'Test'
			$issue | ForEach-Object{
				$_.GetType() | Should Be 'JIRAIssue'
			}
		}
	} else {
		throw 'No Test Enviroment'
	}
}