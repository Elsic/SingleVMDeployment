<# This Script does the following:
- By default files are written to c:\windows\temp
- Disables IE ESC for Administrators.
- Sets WinRM Unencrypted Traffic to enabled and Authentication to Basic.
- Enables .NET Framework 3.5 for SQL Install.
- Downloads and Installs Notepad++.
#>

#Declare the logpath and filepaths
$logpath = "C:\Windows\Temp\"
$_IE_ESC_For_Admins_Disabled_Sucessfully = $logpath + "_IE_ESC_For_Admins_Disabled_Sucessfully.txt"
$_IE_ESC_For_Admins_Disabled_Failed = $logpath + "_IE_ESC_For_Admins_Disabled_Failed.txt"
$_WinRM_Allow_Unencrypted_Enabled_Sucessfully = $logpath + "_WinRM_Allow_Unencrypted_Enabled_Sucessfully.txt"
$_WinRM_Allow_Unencrypted_Enabled_Failed = $logpath + "_WinRM_Allow_Unencrypted_Enabled_Failed.txt"
$_WinRM_Allow_Basic_Auth_Enabled_Sucessfully = $logpath + "_WinRM_Allow_Basic_Auth_Enabled_Sucessfully.txt"
$_WinRM_Allow_Basic_Auth_Enabled_Failed = $logpath + "_WinRM_Allow_Basic_Auth_Enabled_Failed.txt"
$_dotNET_Framework_35_Enabled_Sucessfully = $logpath + "_dotNET_Framework_35_Enabled_Sucessfully.txt"
$_dotNET_Framework_35_Enabled_Failed = $logpath + "_dotNET_Framework_35_Enabled_Failed.txt"
$_NotepadPlusPlus_Downloaded_Successfully = $logpath + "_NotepadPlusPlus_Downloaded_Successfully.txt"
$_NotepadPlusPlus_Download_Failed = $logpath + "_NotepadPlusPlus_Download_Failed.txt"
$_NotepadPlusPlus_Installed_Successfully = $logpath + "_NotepadPlusPlus_Installed_Successfully.txt"
$_NotepadPlusPlus_Install_Failed = $logpath + "_NotepadPlusPlus_Install_Failed.txt"

# Disabling IE ESC for Administrators on Target Host. UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
if ((Test-Path $_IE_ESC_For_Admins_Disabled_Sucessfully) -eq $false) {
    $Disable_IE_ESC_Admins = New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" -Name IsInstalled -Value 0 -Force

    if ($Disable_IE_ESC_Admins.IsInstalled -eq 0)
	    {
		    [System.IO.File]::Create($_IE_ESC_For_Admins_Disabled_Sucessfully).Close()
            if (Test-Path $_IE_ESC_For_Admins_Disabled_Failed) {
                [System.IO.File]::Delete($_IE_ESC_For_Admins_Disabled_Failed)
            }
	    }
	
    if ($Disable_IE_ESC_Admins.IsInstalled -ne 0)
	    {
		    [System.IO.File]::Create($_IE_ESC_For_Admins_Disabled_Failed).Close()
	    }

}

# Setting WinRM to allow Unencrypted traffic and setting Authentication to Basic
if ((Test-Path $_WinRM_Allow_Unencrypted_Enabled_Sucessfully) -eq $false) {
    $AllowUnencrypted = winrm set winrm/config/service '@{AllowUnencrypted="true"}'

    If ($?)
	    {
		    [System.IO.File]::Create($_WinRM_Allow_Unencrypted_Enabled_Sucessfully).Close()
            if (Test-Path $_WinRM_Allow_Unencrypted_Enabled_Failed) {
                [System.IO.File]::Delete($_WinRM_Allow_Unencrypted_Enabled_Failed)
            }
	    }
    If (!$?)
	    {
		    [System.IO.File]::Create($_WinRM_Allow_Unencrypted_Enabled_Failed).Close()
	    }

}

if ((Test-Path $_WinRM_Allow_Basic_Auth_Enabled_Sucessfully) -eq $false) {
    $AllowBasicAuth = winrm set winrm/config/service/auth '@{Basic="true"}'

    If ($?)
	    {
		    [System.IO.File]::Create($_WinRM_Allow_Basic_Auth_Enabled_Sucessfully).Close()
            if (Test-Path $_WinRM_Allow_Basic_Auth_Enabled_Failed) {
                [System.IO.File]::Delete($_WinRM_Allow_Basic_Auth_Enabled_Failed)
            }
	    }
    If (!$?)
	    {
		    [System.IO.File]::Create($_WinRM_Allow_Basic_Auth_Enabled_Failed).Close()
	    }
}
	
#Enabling .NET Framework 3.5 for SQL Install.
if ((Test-Path $_WinRM_Allow_Basic_Auth_Enabled_Sucessfully) -eq $false) {
    DISM /Online /Enable-Feature /FeatureName:NetFx3 /All

    If ($?)
	    {
		    [System.IO.File]::Create($_dotNET_Framework_35_Enabled_Sucessfully).Close()
            if (Test-Path $_dotNET_Framework_35_Enabled_Failed) {
                [System.IO.File]::Delete($_dotNET_Framework_35_Enabled_Failed)
            }
	    }
    If (!$?)
	    {
		    [System.IO.File]::Create($_dotNET_Framework_35_Enabled_Failed).Close()
	    }
}	

# Download Notepad++
if ((Test-Path $_NotepadPlusPlus_Downloaded_Successfully) -eq $false) {

    $Notepad_WebClient = New-Object System.Net.WebClient
    $Notepad_URI       = "https://notepad-plus-plus.org/repository/6.x/6.8.1/npp.6.8.1.Installer.exe"
    $Notepad_File      = $logpath + "npp.6.8.1.Installer.exe"
    $Notepad_WebClient.DownloadFile($Notepad_URI,$Notepad_File)

    If ($?)
	    {
		    [System.IO.File]::Create($_NotepadPlusPlus_Downloaded_Successfully).Close()
            if (Test-Path $_NotepadPlusPlus_Download_Failed) {
                [System.IO.File]::Delete($_NotepadPlusPlus_Download_Failed)
            }
	    }
    If (!$?)
	    {
		    [System.IO.File]::Create($_NotepadPlusPlus_Download_Failed).Close()
	    }
}

# Install Notepad++
if ((Test-Path $_NotepadPlusPlus_Installed_Successfully) -eq $false) {
    & "$($logpath)\npp.6.8.1.Installer.exe" /S

    If ($?)
	    {
		    [System.IO.File]::Create($_NotepadPlusPlus_Installed_Successfully).Close()
            if (Test-Path $_NotepadPlusPlus_Install_Failed) {
                [System.IO.File]::Delete($_NotepadPlusPlus_Install_Failed)
            }
	    }
    If (!$?)
	    {
		    [System.IO.File]::Create($_NotepadPlusPlus_Install_Failed).Close()
	    }
}