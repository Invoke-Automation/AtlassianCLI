---
hide: true
---
Description of how this module is structured.

Basic structure
===============
	AtlassianCLI
	+---.vscode
	|      Visual Studio Code configuration
	+---AtlassianCLI
	|   |      Actual PowerShell Module
	|   +---en-US
	|   |      English help files
	|   +---Private
	|   |      Private PowerShell cmdlets
	|   \---Public
	|          Private PowerShell cmdlets
	+---docs
	|      Documentation
	\---Tests
	       Pester Test files_

Documentation
=============
Every cmdlet is documented using [comment based help](https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.core/about/about_comment_based_help).

The help files in the _docs_ folder are generated using [PlatyPS](https://github.com/PowerShell/platyPS)



