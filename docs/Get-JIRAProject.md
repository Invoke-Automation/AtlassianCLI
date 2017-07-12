---
external help file: AtlassianCLI-help.xml
online version: 
schema: 2.0.0
---

# Get-JIRAProject

## SYNOPSIS
Get one or more JIRAProject objects.

## SYNTAX

### Key
```
Get-JIRAProject -Key <String> [-Session <AtlassianSession>]
```

### Name
```
Get-JIRAProject -Name <String> [-Session <AtlassianSession>]
```

### All
```
Get-JIRAProject [-All] [-Session <AtlassianSession>]
```

## DESCRIPTION
The Get-JIRAProject cmdlet gets a specified JIRAProject object or performs a search to get multiple JIRAProject objects.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-JIRAProject -Name 'Test'
```

Get all projects that have 'Test' in their name using the already imported AtlassianSession

## PARAMETERS

### -Key
Specifies the key to be used to retrieve the JIRAProject object(s).

```yaml
Type: String
Parameter Sets: Key
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the full name or a part of the name used to retrieve the JIRAProject object(s).

```yaml
Type: String
Parameter Sets: Name
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -All
Specifies if you want to retrieve all JIRAProjects available to the specified AtlassianSession.

```yaml
Type: SwitchParameter
Parameter Sets: All
Aliases: 

Required: True
Position: Named
Default value: False
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

## INPUTS

### None
You cannot pipe input to this cmdlet.

## OUTPUTS

### JIRAProject
Returns one or more JIRAProject objects.

## NOTES

## RELATED LINKS

