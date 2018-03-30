<#
    .SYNOPSIS
        Downloads a file associated with a GitHub release.

    .DESCRIPTION
        Downloads a file associated with a GitHub release.

    .PARAMETER releaseName
        The name of the release. (Required)

    .PARAMETER releaseFilename
        The name of the release file to be downloaded.  If not specified, releaseName is used, with a .zip file extension. (Optional)

    .PARAMETER saveToPath
        The filename and path for saving the downloaded file.  If not specified, `releaseFilename` is used, but this may not put
        the file in the expected location. (Optional)

    .PARAMETER gitHubUsername
        User or organization who owns the remote repository

    .PARAMETER gitHubRepository
        Name of the remote repository

#>

Param(
    [Parameter(mandatory=$True, ValueFromPipeline=$False)]
    [string]$gitHubUsername,

    [Parameter(mandatory=$True, ValueFromPipeline=$False)]
    [string]$gitHubRepository,

    [Parameter(mandatory=$True, ValueFromPipeline=$False)]
    [string]$releaseName,

    [Parameter(mandatory=$False, ValueFromPipeline=$False)]
    [string]$releaseFilename,

    [Parameter(mandatory=$False, ValueFromPipeline=$False)]
    [string]$saveToPath)

# Force PowerShell to use TLS v1.2
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;


Function Main($gitHubUsername, $gitHubRepository, $releaseName, $releaseFilename, $saveToPath) {

    If([System.String]::IsNullOrEmpty($releaseFilename)){
        $releaseFilename = "${releaseName}.zip"
    }

    If([System.String]::IsNullOrEmpty($saveToPath)) {
        $saveToPath = $releaseFilename
    }

    $url = "https://github.com/NCIOCPL/wcms-cde/releases/download/${releaseName}/${releaseFilename}"

    Write-Host "Downloading: '${url}'"
    Write-Host "as '${saveToPath}'"

    $client = New-Object System.Net.WebClient
    $client.DownloadFile($url, $saveToPath)
}



Try {
    Main $gitHubUsername $gitHubRepository $releaseName $releaseFilename $saveToPath
}
Catch {
	# Explicitly exit with an error.
	Write-Error "An error has occured $_"
	Exit 1
}
