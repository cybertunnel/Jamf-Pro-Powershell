# Jamf-Pro-Powershell
A powershell module that provides an easy method for interacting with Jamf Pro's APIs inside scripts or the Powershell command line.

<!-- TABLE OF CONTENTS -->
<details>
    <summary>Table of Contents</summary>
    <ol>
        <li><a href="#">About The Project</a></li>
    </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

Jamf Pro's APIs have tools built around them, and there are a lot of other API frameworks and tools available for different languages. However, my initial search turned out very little around PowerShell and Jamf Pro's APIs.
Out of those, none were as useful as the `ruby-jss` Ruby Gem. From that, this project was born.

The main purpose of this project is provide an abstract layer to the Jamf Pro's APIs to easily offer function based commands for Windows and PowerShell Core users.

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

This is a powershell module, which requires Powershell Core to be installed at the minimum.

### Getting Powershell

Links to other repos coming soon...

### Installing the module

1. Copy the `JamfPro` folder into your `~/.local/share/powershell/Modules/` folder
    - Windows users may have a different folder.
2. Open Powershell
3. Run the command `Get-Module 'JamfPro'`
4. All functions are loaded, you can verify this by running `Get-Command -Module 'JamfPro'`

Make sure you review the [Usage](#usage) section of this README for example uses of this module.

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- USAGE -->
## Usage

### Authentication Lifecycle

```Powershell
# Gets Token
$token = New-Token -Server "https://acme.jamfcloud.com"

# Renew Token
$token = Update-Token -Server "https://acme.jamfcloud.com" -Token $token.token

# Invalidate Token
Delete-Token -Server "https://acme.jamfcloud.com" -Token $token.token
```

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- ROADMAP -->
## Roadmap

- [x] Token Authentication
    - [x] New Token
    - [x] Refresh Token
    - [x] Delete Token
- [ ] Computer Groups
    - [x] Get Computer Groups
    - [x] Delete Computer Groups
    - [x] Create Computer Groups
    - [x] Update Computer Groups
- [ ] Policies
    - [ ] Get Policies
    - [ ] Update Policy Scoping
    - [ ] Delete Policies

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTRIBUTING -->
## CONTRIBUTING

This project is a product of love for the Jamf Pro's APIs and the desire to make interactions simple. This project attempts to follow Microsoft's [documentation](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands?view=powershell-7.2) for naming conventions.

If you want to add to this project, please fork this repo and submit a pull request with the appropriate tagging.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Added some AmazingFeature`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>