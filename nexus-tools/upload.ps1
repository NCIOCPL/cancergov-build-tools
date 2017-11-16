<#
	.SYNOPSIS
	Upload a file to the Nexus repository.

	.DESCRIPTION
	Upload a file to the Nexus repository.

	.PARAMETER UploadFile
	The file to be uploaded. Required.

	.PARAMETER UserID
	The Nexus user's ID. Required.

	.PARAMETER UserPass
	The Nexus user's Password. Required.

	.PARAMETER RepoURL
	The Location in the Nexus repository to upload to.  Required.
	(e.g. https://ncirepohub.nci.nihg.gov/nexus/repository/raw/organization-path/filename)

#>

Param(
	[Parameter(mandatory=$true, ValueFromPipeline=$false)]
	[string]$UploadFile,

	[Parameter(mandatory=$true, ValueFromPipeline=$false)]
	[string]$UserID,

	[Parameter(mandatory=$true, ValueFromPipeline=$false)]
	[string]$UserPass,

	[Parameter(mandatory=$true, ValueFromPipeline=$false)]
	[string]$RepoURL
)

$securePassword = ConvertTo-SecureString $UserPass -AsPlainText -Force
$credential = New-Object PSCredential ($UserID, $securePassword)


$uploadParams = @{
	Uri = $RepoURL;
	Method = 'PUT';
	Credential = $credential;
}

$result = Invoke-RestMethod @uploadParams

Write-Host $result