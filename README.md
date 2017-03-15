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

For more information download and navigate the doc-code/html  dir, starting from index.html.