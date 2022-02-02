# FurAffinity Pandoc Modules
Pandoc modules to convert to and from the BBCode-style used by FurAffinity.

## Usage
*Note you'll need [pandoc](https://pandoc.org/) installed before you can use the custom
readers and writers here.*

To convert a file to FurAffinity Markup, run:

```
pandoc -t to_furaffinity.lua -o output.txt [YOUR FILE HERE]
```

This will convert your file (in any of the support pandoc input formats) to FurAffinity
markup, and place the output in a file named `output.txt`. 

Similarly, to convert a file from FurAffinity markup run:

```
pandoc -f from_furaffinity.lua -o output.docx [YOUR FILE HERE]
```

This will convert a downloaded work from FurAffinity into Microsoft Word docx file
named `output.docx`.

## Limitations
Pandoc doesn't have a concept of text alignment or color, so these attributes will not
be captured when using the filters. 

## Acknowledgements
The `to_furaffinity.lua` code is based on [2bbcode](https://github.com/lilydjwg/2bbcode). 