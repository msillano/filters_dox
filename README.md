# filters_dox
A kit of java filters for Doxigen: documentation for  BAT, SH, INI, XML, XHTML, XSLT files.

This addon allows BAT, SH, INI, XML, XHTML, XSLT files documentation using Doxygen (http://www.doxygen.org). This contains following filters: 
- BATdoxFilter.sh (BATdoxFilter.bat) for BAT Script files (win)
- ShdoxFilter.sh (ShdoxFilter.bat) for shellScrip files (linux)
- XMLdoxFilter.sh (XMLdoxFilter.bat) for generic XML files (2 versions)
- HTMLdoxFilter.sh (HTMLdoxFilter.bat) for XHTML files (2 versions)
- XSLTdoxFilter.sh (XSLTdoxFilter.bat) for XSLT stylesheets
- oneblockdoxFilter.sh (oneblockdoxFilter.bat) for text files like INI.

Implementation: All filters are build using 3 main java applications:
1. regexfilter.java, general purpose, it uses regular expressions.
2. xmlfilter.java, general purpose, it transforms the XML input using a XSLT stylesheet.
3. xslt2doxfilter.java special filter for XSLT file and Doxygen.

For more informations download, unzip and navigate the doc-code/html.zip, starting from index.html. That is also a good example for see how filter_dox works: they are documentation from BAT, SH, XHTML, XML and XSLT files.


note: to make a new custom filter using regex:
- make the your rgx file and place it in filters_dox/bin/rgx/  (example: bat2dox.rgx)
- make the drivers (bat and/or sh) and place it in . (examples: batdoxfilter.bat / batdoxfilter.sh)
- Using Doxygen GUI, update config in 'expert' tab (example win-doxygen-HTML-includecode.dox)
- For more informations about regexfilter and regular expressions see https://github.com/msillano/regexfilter/blob/master/README.pdf

note: to make a new custom filter using XSLT:
- make a XSLT file to get the rigth output and place it in filters_dox/bin/xslt/   (example xml2dox.xslt)
- make the drivers (bat and/or sh) and place it in . (examples: XMLdoxFilter.bat / XMLdoxFilter.sh)
- Using Doxygen GUI, update config in 'expert' tab (example win-doxygen-HTML-includecode.dox)
