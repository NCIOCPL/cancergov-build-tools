#Text substitution
Param(
	[Parameter(mandatory=$true, ValueFromPipeline=$false)]
	[string]$InputFile,

#	[Parameter(mandatory=$true, ValueFromPipeline=$false)]
#	[string]$OutputFile,

	[Parameter(mandatory=$true, ValueFromPipeline=$false)]
	[string]$SubstituteList
)

[xml]$substitutions = Get-Content $SubstituteList
[string]$data = Get-Content -Raw $InputFile

foreach($substitute in $substitutions.substitutions.substitute) {

	$find = $substitute.find
	$replacement = $substitute.replacement
	if($replacement.GetType() -eq [System.Xml.XmlElement] ) {
		if($replacement.FirstChild -ne $null -and $replacement.FirstChild.GetType() -eq [System.Xml.XmlCDataSection]) {
			$replacement = $replacement.FirstChild.Value
		} else {
			Write-Error "Unknown replacement node type."
			exit
		}
	}

	$data = $data.Replace($find, $replacement)
}

Write-Output $data



