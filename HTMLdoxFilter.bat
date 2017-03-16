 rem global:
:: /**  
:: *   @file HTMLdoxFilter.bat 
:: *   Enables "*.html" (XHTML) files documentation (no source) in doxygen (win).
:: *  This filter works only on XHTML files. (You can use <b>tidy</b> to transform HTML to XHTML).<br />
:: *  @par use:
:: *  Using Doxygen GUI, update config in 'expert' tab:
:: *  @li in project/EXSTENSION_MAPPING add 'html=Javascript';
:: *  @li in input/file_patterns section add the value '*.html' (same for '*.htm', '*xhtml').
:: *  @li in input/filter_patterns section add the value '*.html=C:/filters/HTMLdoxFilter.bat' (path can change).
:: *  @li to include the source HTML in documentation use HTMLdoxFilter_is.bat.
:: *  @li to include the Javascript source in documentation set source_browser/INLINE_SOURCE = true and
:: *    input/FILTER_SOURCE_FILES = true.
:: *  @see HTMLdoxFilter.sh for linux version
:: *  @see Tidy (http://www.w3.org/People/Raggett/tidy/)
:: */
rem code doc
::/**
::*  This filter uses a XSLT file (xslt\html2dox.xslt). 
::*  It tranforms the input 'xhtml' file to a 'javascript-like' function style for Doxygen process.
::*  @param %1 the path of the XHTML input file.
::*  @return it uses sout.
::*  @par note:
::*   @li HTML: this processes HTML comments (&lt;!-- -->) followed by a javadoc style comment: '/'+'*'+'*'
::*    and '*'+'/' <br /> 
::*    @li HTML: processes only blocks at first livel, inside the &lt;HTML> tag.
::*    @li HTML: a first optional block (starting '@'+mainpage) is the global documentation block.
::*    @li HTML: a second optional block (starting '@'+file +&lt;name_file>) is the detailed descripition block.
::*    @li HTML: the last bock is the HTML documentation.
::*    @li HTML: the source HTML code is NOT included in documentation
::*    @li javascript: all javascript bocks are deplaced 'as is' after the HTML section
::*    @li javascript: all documentation blocks (variables, functions etc.) are processes as usual by doxygen 
::*  @par example:
::*     See filter/sample_files/example01.html.
::*  @see xmlfilter.java
::*/
rem code starts here:
@ECHO OFF
C:
CD "C:\filters\bin"
rem usr_parameter INLINE_SOURCE=false (same as doxygen flag)
rem java.exe  xmlfilter  xslt\html2dox.xslt -i %1   --usr="INLINE_SOURCE&false" >%1out.txt
java.exe  xmlfilter  xslt\html2dox.xslt -i %1  --usr="INLINE_SOURCE&false" 
