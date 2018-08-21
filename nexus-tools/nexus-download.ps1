<#
	.SYNOPSIS
	Retrieves a file from the Nexus repository.

	.DESCRIPTION
	Retrieves a file from the Nexus repository.

	.PARAMETER Filename
	The file to be downloaded. Required.

	.PARAMETER UserID
	The Nexus user's ID. Required.

	.PARAMETER UserPass
	The Nexus user's Password. Required.

	.PARAMETER saveToPath
        The filename and path for saving the downloaded file.  If not specified, `Filename` is used, but this may not put
        the file in the expected location. (Optional)
#>

Param(
	[Parameter(mandatory=$true, ValueFromPipeline=$false)]
	[string]$Filename,

	[Parameter(mandatory=$true, ValueFromPipeline=$false)]
	[string]$UserID,

	[Parameter(mandatory=$true, ValueFromPipeline=$false)]
	[string]$UserPass,

	[Parameter(mandatory=$false, ValueFromPipeline=$false)]
	[string]$SaveToPath = $null
)

# NCI has deprecated TLS v1 and v1.1
# This sets PowerShell to use TLS v1.2
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;

# Calculate the save file name.
    If([System.String]::IsNullOrEmpty($SaveToPath)) {
        $SaveLocation = Join-Path -path "." $Filename
    } else {
		$SaveLocation = $SaveToPath
	}
write-Host $SaveLocation


# Calculate the upload destination URL.
$configFile = [System.IO.Path]::Combine($PSScriptRoot, "nexus-config.json")
$config = (Get-Content $configFile) -join "`n" | ConvertFrom-Json
$remoteUrl = $config.baseUrl.Trim()
if ( -not $remoteUrl.EndsWith('/') ) { $remoteUrl = $remoteUrl + '/' }
$remoteUrl = $remoteUrl + $Filename

# Create login credential
$bytes = [System.Text.Encoding]::UTF8.GetBytes("${UserID}:${UserPass}")
$credential = [System.Convert]::ToBase64String($bytes)

$downloadParams = @{
	Uri = $remoteUrl;
	Method = 'GET';
	Headers = @{"Authorization"="Basic $credential"};
	OutFile = $SaveLocation;
}

$result = Invoke-RestMethod @downloadParams

Write-Host $result
