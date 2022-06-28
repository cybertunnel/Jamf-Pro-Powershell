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

### Authentication
```powershell
Get-Module 'JamfPro'

$Server = "https://acme.com"
$Creds = Get-Credentials "apiuser"

$Token = New-Token -Server $Server -Credentials $Creds
```
### Getting Object
```powershell
# This is assuming the $token variable is set with a valid token.
$Server = "https://achmo.com"

# All devices
$Computers = Get-Computer -Server $Server -Token $token.token -All

# Specific device
$Computer = Get-Computer -Server $Server -Token $token.token -id 1
```

### Updating Object

### Removing Object

### Managing Scope

### Managing Criteria

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- ROADMAP -->
## Roadmap
### Resources / Utility
- [x] Authentication
  - [x] Get Token
  - [x] Refresh Token
  - [x] Invalidate Token
- [x] Convert JSON to Jamf's XML
- [x] Add Criteria (Smart Group/Search)

### Jamf Pro Settings / Configuration
- [x] Categories
    - [x] Get Categories
    - [x] Get single Category
    - [x] Update Category
    - [x] Delete Category
    - [x] Create Category
- [x] Sites
    - [x] Get Sites
    - [x] Get single Site
    - [x] Update Site
    - [x] Delete Site
    - [x] Create Site
- [x] Buildings
    - [x] Get Buildings
    - [x] Get single Building
    - [x] Update Building
    - [x] Delete Building
    - [x] Create Building
- [x] Departments
    - [x] Get Departments
    - [x] Get single Department
    - [x] Update Department
    - [x] Delete Department
    - [x] Create Department
- [ ] Groups
    - [ ] Computer
        - [x] Get Groups
        - [x] Get single Group
        - [ ] Update Group
        - [x] Delete Group
        - [ ] Create Group
    - [ ] User
        - [x] Get Groups
        - [x] Get single Group
        - [ ] Update Group
        - [x] Delete Group
        - [ ] Create Group
    - [ ] Mobile
        - [x] Get Groups
        - [x] Get single Group
        - [ ] Update Group
        - [x] Delete Group
        - [ ] Create Group
- [ ] Searches
  - [ ] Computer
    - [ ] Get Searches
    - [ ] Get single Search
    - [ ] Update Search
    - [ ] Delete Search
    - [ ] Create Search
  - [ ] Mobile
    - [ ] Get Searches
    - [ ] Get single Search
    - [ ] Update Search
    - [ ] Delete Search
    - [ ] Create Search

### Device Settings / Configuration
- [ ] Devices
  - [ ] Computers
    - [ ] Get Computers
    - [ ] Get single computer
    - [ ] Update computer
    - [ ] Delete computer
    - [ ] Create computer
  - [ ] Mobile Devices
    - [ ] Get mobile devices
    - [ ] Get single mobile device
    - [ ] Update mobile device
    - [ ] Delete mobile device
    - [ ] Create mobile device
- [ ] Configuration Profiles
    - [ ] Get configuration profiles
    - [ ] Get single configuration profile
    - [ ] Update configuration profile
    - [ ] Delete configuration profile
    - [ ] Create configuration profile
- [ ] Policies
    - [ ] Get Policies
    - [ ] Get single Policy
    - [ ] Update Policy
    - [ ] Delete Policy
    - [ ] Create Policy
- [ ] Scripts
    - [ ] Get scripts
    - [ ] Get single script
    - [ ] Update script
    - [ ] Delete script
    - [ ] Create script
- [ ] Extension Attributes
    - [ ] Get Extenstion Attributes
    - [ ] Get single Extenstion Attribute
    - [ ] Update Extenstion Attribute
    - [ ] Delete Extenstion Attribute
    - [ ] Create Extenstion Attribute
- [ ] Prestages
- [ ] Inventory Preload
- [ ] Packages
    - [ ] Get Packages
    - [ ] Get single Package
    - [ ] Update Package
    - [ ] Delete Package
    - [ ] Create Package



<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTRIBUTING -->
## CONTRIBUTING

This project is a product of love for the Jamf Pro's APIs and the desire to make interactions simple. This project attempts to follow Microsoft's [documentation](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands?view=powershell-7.2) for naming conventions.

Additionally, please review Jamf's [Jamf Pro API Documentation](https://developer.jamf.com/jamf-pro/reference/)

If you want to add to this project, please fork this repo and submit a pull request with the appropriate tagging.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Added some AmazingFeature`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>