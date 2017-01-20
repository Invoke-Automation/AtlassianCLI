AtlassianCLI
=============
AtlassianCLI provides a PowerShell interface to several Atlassian web applications using their respective REST API's

Getting started
===============
## Requirements
Windows PowerShell 5.0 or greater

## Usage
Import the module
```PowerShell
Import-Module .\AtlassianCLI
```
Configure a session for your Atlassian environment
```PowerShell
New-AtlassianSession [-Server] <String> [-Credential] <PSCredential> [-WhatIf] [-Confirm] [<CommonParameters>]
```
Save the session file
```PowerShell
(Get-AtlassianSession).Save()
```
Use the session file to execute commands
```PowerShell
Get-JIRAIssue -Jql <String> [-Session <AtlassianSession>] [<CommonParameters>]
```

Contributing to AtlassianCLI
============================
## Found a bug?
Submit a bug report via [Issues](https://github.com/Invoke-Automation/AtlassianCLI/issues)
## You want to contribute?
Awesome! Take a look at [CONTRIBUTING.md](CONTRIBUTING.md)

Legal and Licensing
===================
AtlassianCLI is licensed under the [MIT license](LICENSE.txt).

Code of Conduct
===============
This code of conduct outlines our expectations for participants within the Invoke-Automation community, as well as steps to reporting unacceptable behavior. We are committed to providing a welcoming and inspiring community for all and expect our code of conduct to be honored. Anyone who violates this code of conduct may be banned from the community.

Our open source community strives to:

* **Be friendly and patient**: Remember you might not be communicating in someone else's primary spoken or programming language, and others may not have your level of understanding.
* **Be welcoming**: We strive to be a community that welcomes and supports people of all backgrounds and identities. This includes, but is not limited to members of any race, ethnicity, culture, national origin, colour, immigration status, social and economic class, educational level, sex, sexual orientation, gender identity and expression, age, size, family status, political belief, religion, and mental and physical ability.
* **Be considerate**: Your work will be used by other people, and you in turn will depend on the work of others. Any decision you take will affect users and colleagues, and you should take those consequences into account when making decisions. Remember that we’re a world-wide community, so you might not be communicating in someone else’s primary language.
* **Be respectful**: Not all of us will agree all the time, but disagreement is no excuse for poor behavior and poor manners. We might all experience some frustration now and then, but we cannot allow that frustration to turn into a personal attack. It’s important to remember that a community where people feel uncomfortable or threatened is not a productive one.
* **Be careful in the words that we choose**: we are a community of professionals, and we conduct ourselves professionally. Be kind to others. Do not insult or put down other participants. Harassment and other exclusionary behavior aren’t acceptable.
* **Try to understand why we disagree**: Disagreements, both social and technical, happen all the time. It is important that we resolve disagreements and differing views constructively. Remember that we’re different. The strength of our community comes from its diversity, people from a wide range of backgrounds. Different people have different perspectives on issues. Being unable to understand why someone holds a viewpoint doesn’t mean that they’re wrong. Don’t forget that it is human to err and blaming each other doesn’t get us anywhere. Instead, focus on helping to resolve issues and learning from mistakes.
* This code is not exhaustive or complete. It serves to capture our common understanding of a productive, collaborative environment. We expect the code to be followed in spirit as much as in the letter.

_This code of conduct is based on the [template](http://todogroup.org/opencodeofconduct/) established by the [TODO Group](http://todogroup.org/) and used by numerous other large communities (e.g.,[Microsoft](https://opensource.microsoft.com/codeofconduct/), [Facebook](https://code.facebook.com/pages/876921332402685/open-source-code-of-conduct), [Twitter](https://engineering.twitter.com/opensource/code-of-conduct), [GitHub](http://todogroup.org/opencodeofconduct/#opensource@github.com))._