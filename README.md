# filters4Doxygen  ver 4.03
Many projects requires a mix of file formats, so it is useful an unifom documentation tool not only for programmation languages, but also
for extra file required by project.

This addon allows .BAT, .SH, .RGX, .XML, .XHTML, .XSLT files documentation using Doxygen (http://www.doxygen.nl, ver. 1.8.15) 

This contains following filters for Doxygen: 
- BATdoxFilter.sh (BATdoxFilter.bat) for BAT Script files (win)
- ShdoxFilter.sh (ShdoxFilter.bat) for shellScrip files (linux)
- XMLdoxFilter.sh (XMLdoxFilter.bat) for generic XML files
- HTMLdoxFilter.sh (HTMLdoxFilter.bat) for(X)HTML files 
- XSLTdoxFilter.sh (XSLTdoxFilter.bat) for XSLT/XSL stylesheets
- RGXdoxFilter.sh (RGXdoxFilter.bat) for RGX (text files INI-like)

### Implementation
All filters are build using 3 main java applications (sources icluded):
1. regexfilter.java, general purpose, it replace text using regular expressions. 
2. xmlfilter.java, general purpose, it transforms the XML input using a XSLT stylesheet.
3. xslt2doxfilter.java special filter for XSLT file and Doxygen.


For more informations you can download, unzip and navigate the doc/html.zip, starting from index.html.  This is also a good example for see how filters4Doxygen works:  this project uses  JAVA, BAT, SH, RGX,  XML, XSL and XSLT files.

### The architecture of this project simplifies the creation of new custom filters:
how make a new custom filter using regex, to document a new file format (new extension) TXT-like:
- make the your rgx file and place it in filters_dox/bin/rgx/  (example: bat2dox.rgx)
- make the drivers (bat and/or sh) and place it in . (examples: batdoxfilter.bat / batdoxfilter.sh)
- Using Doxygen GUI, update config in 'expert' tab.
- For more informations about regexfilter, rgx syntax and regular expressions see doc or https://github.com/msillano/regexfilter/blob/master/README.pdf

how make a new custom filter using XSLT, to document a new file format (new extension) XML:
- make a XSLT file to get the rigth output and place it in filters_dox/bin/xslt/   (example xml2dox.xslt)
- make the drivers (bat and/or sh) and place it in . (examples: XMLdoxFilter.bat / XMLdoxFilter.sh)
- Using Doxygen GUI, update config in 'expert' tab.
