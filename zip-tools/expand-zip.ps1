Param(
    [Parameter(mandatory=$True, ValueFromPipeline=$False, Position=0)]
    [string]$source,

    [Parameter(mandatory=$True, ValueFromPipeline=$False, Position=0)]
    [string]$destinationPath
)

<#
    .SYNOPSIS
    Expands a ZIP file.

    .DESCRIPTION
    Expands the content of source, placing the extracted files at the location specified by destinationPath.

    .PARAMETER source
    The name and path of the ZIP file to be expanded.


    .PARAMETER destinationPath
    The location where the contents of the ZIP file are to be placed.
#>

Write-Host "Creating '${destinationPath}' from '${sourcePath}'."
Expand-Archive -Path $source -DestinationPath $destinationPath
