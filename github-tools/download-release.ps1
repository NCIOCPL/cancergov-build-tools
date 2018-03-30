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

    $client = New-Object System.Net.WebClient
    $result = $client.DownloadFile($url, $saveToPath)
}



Try {
    Main $gitHubUsername $gitHubRepository $releaseName $releaseFilename $saveToPath
}
Catch {
	# Explicitly exit with an error.
	Write-Error "An error has occured $_"
	Exit 1
}
