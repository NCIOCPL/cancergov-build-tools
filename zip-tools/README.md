# PowerShell scripts for managing ZIP files

## create-zip.ps1

Creates a .zip file.

### Execution

Execute with the command

```
powershell .\create-zip.ps1 <arguments>
```

The full set of command line arguments is:

* **-sourcePath** Location of the files to be compressed.  This may be a directory, or an individual filespec (wildcards are supported). **(Required)**
* **-destinationPath** The name and path of the ZIP file to be created. **(Required)**

## expand-zip.ps1

Expands the content of a .zip file.

### Execution

Execute with the command

```
powershell .\expand-zip.ps1 <arguments>
```

The full set of command line arguments is:

* **-source** The name and path of the ZIP file to be expanded. **(Required)**
* **-destinationPath** The location where the contents of the ZIP file are to be placed. **(Required)**

