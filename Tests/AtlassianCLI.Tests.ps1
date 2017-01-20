Import-Module .\AtlassianCLI -Force
$Session = Get-AtlassianSession -Path '.\Tests\JiraSession.enc.xml'
$issue = Get-JIRAIssue -Jql 'issuekey = BCT-8513'
$issue