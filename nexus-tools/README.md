# Nexus Tools

This is a collection of scripts for working with a Nexus repository.

* **upload.ps1** - Stores the named file in the repository.
* **download.ps1** - Retrieves the named file from the repository.

At a high-level, the repository just deals in file uploads and retrievals.
These scripts just simply the process.

**To upload:**
* Use a PUT request.
* The URL of the PUT is the file's destination, including target filename.
* The body of the request is the actual file content.
* You must send a userid and password.

**To download:**
* Use a GET request.
* The URL of the GET is the targetted file.
* The body of the response is the file content.
* You must send a userid and password.

An API for listing and deleting files can be found by visiting the repository URL and adding /nexus/swagger-ui/ at the end.
(e.g. https://servername/nexus/swagger-ui/)

A *little* more information can be found on the vendor's blog at http://blog.sonatype.com/nexus-repository-new-beta-rest-api-for-content