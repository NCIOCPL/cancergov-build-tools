# Deletes a single release from a GitHub repository.
#
# Because deletes cannot be undone, this tool includes three deliberate
# design choices:
#
#   1. Delete only one release per invocation.
#   2. Only delete items marked as pre-release (final releases should be marked as such).
#   3. Require the user to confirm the deletion.


Param(
    [Parameter(mandatory=$True, ValueFromPipeline=$False)]
    [string]$gitHubUsername,

    [Parameter(mandatory=$True, ValueFromPipeline=$False)]
    [string]$gitHubRepository,

    [Parameter(mandatory=$True, ValueFromPipeline=$False)]
    [string]$releaseID
)

$gitHubApiKey = $env:GITHUB_TOKEN
if( $gitHubApiKey -eq $null ) {
    Write-Error -Message "The GITHUB_TOKEN environment variable was not set."
    exit 1
}

# Force PowerShell to use TLS v1.2
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;


Function Main ($gitHubUsername, $gitHubRepository, $releaseID) {
    $release = GetReleaseSingle $gitHubUsername $gitHubRepository $releaseID
    $OKToProceed = ValidateRelease $release
    if($OKToProceed){
        Write-Host "deleting..."
        DeleteRelease $gitHubUsername $gitHubRepository $releaseID
    } else {
        Write-Host -ForegroundColor "Yellow" "Aborting..."
    }
}


# Retrieves information about a single release.
Function GetReleaseSingle($gitHubUsername, $gitHubRepository, $releaseID) {

    $auth = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($gitHubApiKey + ":x-oauth-basic"));

    $releaseRequest = @{
       Uri = "https://api.github.com/repos/$gitHubUsername/$gitHubRepository/releases/$releaseID";
       Method = 'GET';
       Headers = @{
         Authorization = $auth;
       }
       ContentType = 'application/json';
       Body = (ConvertTo-Json $releaseData -Compress)
    }

    $result = Invoke-RestMethod @releaseRequest
    return $result
}


Function ValidateRelease($releaseData) {
    $name = $releaseData.name

    Write-Host -ForegroundColor "Green" "`n`n`You are about to delete release '$name'."
    Write-Host -ForegroundColor "Red"   "Warning! This operation cannot be undone."
    $response = $null

    do {
        $response = Read-Host "`nAre you sure you want to proceed? (y/n)`n"
    } while($response -ne 'y' -and $response -ne 'n' )

    if( $response -eq 'n') {
        return $False
    }

    if( -Not $releaseData.prerelease ) {
        Write-Host -ForegroundColor "Red" "Error: '$name' is not a prerelease."
        return $False
    }

    return $True
}

Function DeleteRelease($gitHubUsername, $gitHubRepository, $releaseID) {

    $auth = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($gitHubApiKey + ":x-oauth-basic"));

    $releaseRequest = @{
       Uri = "https://api.github.com/repos/$gitHubUsername/$gitHubRepository/releases/$releaseID";
       Method = 'DELETE';
       Headers = @{
         Authorization = $auth;
       }
       ContentType = 'application/json';
       Body = (ConvertTo-Json $releaseData -Compress)
    }

    $result = Invoke-RestMethod @releaseRequest
    return $result
}


Try {
    Main $gitHubUsername $gitHubRepository $releaseID
}
Catch {
	# Explicitly exit with an error.
	Write-Error "An error has occured $_"
	Exit 1
}
