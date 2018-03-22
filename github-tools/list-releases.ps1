# Outputs a comma-delimited list of the releases associated with a repo.

Param(
    [Parameter(mandatory=$True, ValueFromPipeline=$False)]
    [string]$gitHubUsername,

    [Parameter(mandatory=$True, ValueFromPipeline=$False)]
    [string]$gitHubRepository
)

$gitHubApiKey = $env:GITHUB_TOKEN
if( $gitHubApiKey -eq $null ) {
    Write-Error -Message "The GITHUB_TOKEN environment variable was not set."
    exit 1
}

# Force PowerShell to use TLS v1.2
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;


Function Main($gitHubUsername, $gitHubRepository) {
    $releaseList = GetReleaseList $gitHubUsername $gitHubRepository
    DisplayResults $releaseList
}


Function GetReleaseList($gitHubUsername, $gitHubRepository) {

    $auth = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes($gitHubApiKey + ":x-oauth-basic"));

    $releaseRequest = @{
       Uri = "https://api.github.com/repos/$gitHubUsername/$gitHubRepository/releases";
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

Function DisplayResults($releaseList) {
    Write-Host """Release Name"",""ID"",""Is Prelease"""
    $releaseList | Sort-Object -Property name | ForEach-Object {
        $name = $_.name
        $id = $_.id
        $isPrelease = $_.prerelease
        Write-Host "${name},${id},${isPrelease}"
    }
}


Try {
    Main $gitHubUsername $gitHubRepository
}
Catch {
	# Explicitly exit with an error.
	Write-Error "An error has occured $_"
	Exit 1
}
