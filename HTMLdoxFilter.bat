 rem global
:: /**  
:: *  @file 
:: *  Enables  <tt>"*.html" </tt> (XHTML) files documentation in doxygen (win).
:: *  Tranforms the input '(X)HTML' file to a 'Javascript-like' file for Doxygen process.
:: *  This filter works only on XHTML files. (You can use <b>tidy</b> to transform HTML to XHTML).<br />
:: *  @par use:
:: *  Using Doxygen GUI, update config in 'expert' tab:
:: *  @li in project/EXSTENSION_MAPPING add 'html=Javascript';
:: *  @li in input/file_patterns section add the value '*.html' (same for '*.htm', '*xhtml').
:: *  @li in input/filter_patterns section add the value '*.html=C:/filters_dox/HTMLdoxFilter.bat' (path can change).
:: * @par Inline code
:: *  - To include the <i>XHTML code </i>as a colorful tree in documentation: set <tt>INLINE_SOURCE&true</tt> in this driver.
:: *  - When <tt>INLINE_SOURCE&true</tt> you can choose the tree initial look: open|close. Modify the parameter <tt>'status'</tt> on @ref html2dox.xslt
:: *  - To include the   <i>Javascript source  </i>(if any) in documentation: set in Doxygen GUI: source_browser/INLINE_SOURCE = true and
:: *       input/FILTER_SOURCE_FILES = true.
:: *  @see <tt>make_win.doxygen</tt> for basic doxygen config file.
:: *  @see HTMLdoxFilter.sh for linux version
:: *  @see Tidy (http://www.w3.org/People/Raggett/tidy/)
:: */
::/** @file
:: * @version 06/01/19 for Doxygen 1.8.15
:: * @author Copyright &copy;2006 Marco Sillano.
:: */
rem code doc
::/**
::*  Pseudo-function with actual BAT code.
::*  This driver uses @ref xmlfilter.java  with the transformation 'ad hoc': xslt\html2dox.xslt.
::*  @par XHTML -> javascript-like transformation rules:
::*    @li HTML:  processes HTML comments (&lt;!-- -->) followed by a javadoc style comment: '/'+'*'+'*'
::*    and '*'+'/' <br /> 
::*    @li HTML: processes only documentation blocks at first livel, inside the &lt;HTML> tag.
::*    @li HTML: The first documentation block (starting  with  <tt>'@'+'file' </tt>) is the file descripition block.
::*    @li HTML: the last bock can be the HTML documentation.
::*    @li javascript: all javascript bocks are deplaced 'as is' after the HTML section
::*    @li javascript: all documentation blocks (variables, functions etc.) are processes as usual by Doxygen 
::*  @param %1 the path of the XHTML input file.
::*  @return it uses sout (as required by Doxygen).
::*  @par Debug
::*  The penultimate commented line in code saves the filtered output to a file, in same dir as %1.
::*  @par example:
::*     See filter/sample_files/example01.html.
::*  @see xmlfilter.java
::*/
@ECHO OFF
C:
CD "C:\filters_dox\bin"
  :: rem debug only:
  rem rem java.exe  xmlfilter  xslt\html2dox.xslt -i %1   --usr="INLINE_SOURCE&true" >%1out.txt
java.exe  xmlfilter  xslt\html2dox.xslt -i %1  --usr="INLINE_SOURCE&true" 
