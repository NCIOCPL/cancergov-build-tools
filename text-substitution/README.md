This is a simple PowerShell script for doing string substitutions.


# Execution

Execute with the command:

```powershell .\substitution.ps1 <input> <output> <substitution_list>```

*where*

*`<input>`* is a text file containing text to be processed. Words to be replaced are surrounded by curly braces
    _e.g. {REPLACE}

*`<output>`* is the name of the output file

*`<substitution_list>`* is a list of substitutions.

## Substitution List format

The subsitution_list file contains an XML document containing a list of `substitute` elements, each containing a pair of `find` and `replacement` elements.  If the `replacement` element contains XML or HTML, it must be enclosed in a CDATA secton.

```xml
<substitutions>
	<substitute>
		<find>SIMPLE_TEXT</find>
		<replacement>This is some text</replacement>
	</substitute>
	<substitute>
		<find>HTML_TEXT</find>
		<replacement><![CDATA[This is a longer bit of text,  it contains<br> some HTML.
		]]></replacement>
	</substitute>
</substitutions>
```

## NOTES

* Text replacement is case-sensitive.  "Replace" is not the same as "REPLACE".
* Words to be replaced must be enclosed in curly braces in the input file. Curly braces are *NOT* used in the substitution list data file.
* The substitution script does exact maches and replacements. There is no support for trimming leading/trailing whitespace.
