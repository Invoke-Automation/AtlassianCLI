---
external help file: AtlassianCLI-help.xml
online version: "https://invoke-automation.github.io/AtlassianCLI/Add-JIRAIssue"
schema: 2.0.0
---

# Add-JIRAIssue

## SYNOPSIS
Creates a new JIRA issue

## SYNTAX

### ProjectName (Default)
```
Add-JIRAIssue -IssueType <String> [-Summary <String>] [-Description <String>] [-Reporter <String>]
 [-Assignee <String>] [-Versions <String[]>] [-FixVersions <String[]>] [-Components <String[]>]
 [-TimeEstimate <TimeSpan>] [-Priority <String>] [-ParentTaskKey <String>] [-Properties <Hashtable>]
 [-Session <AtlassianSession>] [<CommonParameters>]
```

### Project
```
Add-JIRAIssue -Project <JIRAProject> -IssueType <String> [-Summary <String>] [-Description <String>]
 [-Reporter <String>] [-Assignee <String>] [-Versions <String[]>] [-FixVersions <String[]>]
 [-Components <String[]>] [-TimeEstimate <TimeSpan>] [-Priority <String>] [-ParentTaskKey <String>]
 [-Properties <Hashtable>] [-Session <AtlassianSession>] [<CommonParameters>]
```

### ProjectKey
```
Add-JIRAIssue -ProjectKey <String> -IssueType <String> [-Summary <String>] [-Description <String>]
 [-Reporter <String>] [-Assignee <String>] [-Versions <String[]>] [-FixVersions <String[]>]
 [-Components <String[]>] [-TimeEstimate <TimeSpan>] [-Priority <String>] [-ParentTaskKey <String>]
 [-Properties <Hashtable>] [-Session <AtlassianSession>] [<CommonParameters>]
```

## DESCRIPTION
The Add-JIRAIssue cmdlet  gets a specified JIRAIssue object or performs a search to get multiple JIRAIssue objects.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Add-JIRAIssue -ProjectKey 'TEST' -IssueType 'Task' -Summary 'Task Test' -Description 'My first task'
```

Gets all issues returned by the JQL filter 'project=TEST' for the currently loaded session.

### -------------------------- EXAMPLE 2 --------------------------
```
Add-JIRAIssue -Project $project -IssueType 'Task' -Summary 'Big Test' -Description 'Big Issue' -Assignee 'Test' -Priority 'Highest' -FixVersions 'Test Version' -Components 'Test Component' -TimeEstimate (New-TimeSpan -Hours 1) -Properties @{labels=@('test','demo')}
```

Gets all issues returned by the JQL filter 'project=TEST' for the currently loaded session.

### -------------------------- EXAMPLE 3 --------------------------
```
Add-JIRAIssue -ProjectKey 'TEST' -IssueType 'Sub-task' -Summary 'Sub-Task Test' -Description 'Smaller issue' -Reporter 'Test' -Assignee 'Test' -Priority 'Low' -Versions 'Test Version' -ParentTaskKey $createdTask.key -Properties @{labels=@('uber')}
```

Gets all issues returned by the JQL filter 'project=TEST' for the currently loaded session.

## PARAMETERS

### -Project
Specifies the JIRAProject in which the issue should be created.

```yaml
Type: JIRAProject
Parameter Sets: Project
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProjectKey
Specifies the key of the JIRA project in which the issue should be created.

```yaml
Type: String
Parameter Sets: ProjectKey
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IssueType
Specifies the name of the issue type for the new JIRA issue

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Summary
Specifies the summary for for the new JIRA issue

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Specifies the description for for the new JIRA issue

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Reporter
Specifies the account name of the reporter for for the new JIRA issue

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Assignee
Specifies the account name of the assignee for for the new JIRA issue

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Versions
Specifies the (list of) affected version(s) for for the new JIRA issue

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FixVersions
Specifies the (list of) fix version(s) for for the new JIRA issue

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Components
Specifies the (list of) component(s) for for the new JIRA issue

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeEstimate
Specifies the estimated time for for the new JIRA issue

```yaml
Type: TimeSpan
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Priority
Specifies the name of the priority for for the new JIRA issue

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentTaskKey
Specifies the key of the parent task for for the new JIRA issue
This should only be specified for issuetypes that are sub-tasks

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Properties
Specifies the (list of) extra propertie(s) for for the new JIRA issue

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Session
Specifies the AtlassianSession to use to perform this task.
If none is specified Get-AtlassianSession is called.

```yaml
Type: AtlassianSession
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: (Get-AtlassianSession)
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
You cannot pipe input to this cmdlet.

## OUTPUTS

### JIRAIssue
Returns one or more JIRAIssue objects.

## NOTES

## RELATED LINKS

