# PowerShell scripts for managing releases in GitHub

## github-release.ps1

Creates releases and uploads artifacts.

Inspired by the [GitHub Release Tool](https://github.com/aktau/github-release) written in Go.

### Why reinvent the wheel?

The Go-based tool works wonderfully in Linux, and Go is available cross-platform, so why do we need to create another tool that fulfills the same purpose?

Unfortunately, [VirusTotal identifies the Windows version as potential malware](https://www.virustotal.com/#/file/7f986241fbde12c6dc85c5b9888f11815e22338c73741266fdee76588e8c197f/detection).  This may be a false positive; VirusTotal has also identified a Go-based "Hello World!" application as potential malware.  But in an enterprise environment, this is a hassle we don't need.  So we have a PowerShell script.

### Execution

Execute with the command

```
powershell .\github-release.ps1 <arguments>
```

The full set of command line arguments is:

* **-tagname** The Name of the tag the release should be associated with. **(Required)**
* **-releaseName** The name of the release.**(Required)**
* **-commitId** The hash value the tag should be placed on. **(Optional)**
* **-IsPreRelease** If present, marks the release as a pre-release, else the release is marked as finalized. **(Optional)**
* **-releaseNotes** A text description of the release. **(Required)**
* **-artifactDirectory** Path to where the artifact to be uploaded may be found. **(Optional)**
* **-artifact**  Name of the file to be uploaded. This value also becomes the name of the artifact file to be downloaded.**(Optional)**
* **-gitHubUsername** User or organization who owns the remote repository
* **-gitHubRepository** Name of the remote repository
* **-gitHubApiKey** Personal access token with repo full control permission.  (See https://github.com/settings/tokens)

#### Notes:

* An error occurs if the tag already exists.
* The -CommitID switch is optional:
* * If commitID is blank, the tag is created on master.
* * If commitID is a commit hash, the tag is created on the commit.
* * If commitID is null, and the tag doesn't already exist, the tag is created on master, else the existing tag is used.

## list-releases.ps1

Outputs a comma-delimited list of the releases associated with a repo.

## delete-release.ps1

Deletes a single release.  The release must be marked as a pre-release.

## download-release.ps1

### Execution

Execute with the command

```
powershell .\download-release.ps1 <arguments>
```

The full set of command line arguments is:

* **-releaseName** The name of the release. **(Required)**
* **-releaseFilename** The name of the release file to be downloaded.  If not specified, `releaseName` is used, with a .zip file extension. **(Optional)**
* **-saveToPath** The filename and path for saving the downloaded file.  If not specified, `releaseFilename` is used, but this may not put
    the file in the expected location. **(Optional)**
* **-gitHubUsername** User or organization who owns the remote repository **(Required)**
* **-gitHubRepository** Name of the remote repository **(Required)**
