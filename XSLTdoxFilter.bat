rem global
:: /**  
:: *   @file 
:: *   Enables XSLT ("*.xsl") files documentation in doxygen (win).
:: *   This filter does a transformation of input 'xsl' file to a 'C-like' style for Doxygen process.
:: *   Any "xsl:template" is processed as a pseudo-function, and can have a documentation block.
:: *   
:: *  @par use:
:: *  Using Doxygen GUI, update config in 'expert' tab:
:: *  @li in project/EXSTENSION_MAPPING add 'xsl=C';
:: *  @li input/FILTER_PATTERNS section set value '*.xsl=C:/filters_dox/XSLTdoxFilter.bat' (path can change).
:: *  @li input/FILE_PATTERNS section add value '*.xsl' 
:: *  @li For <tt>*.xslt</tt> file, do same, changing 'xsl' with 'xslt'.
:: * @par Inline code
:: *  - To include the <i>XML code </i>as a colorful tree in documentation: set <tt>INLINE_SOURCE&true</tt> in this driver.
:: *  - When <tt>INLINE_SOURCE&true</tt> you can choose the tree initial look: open|close. Modify the parameter <tt>'status'</tt> on @ref nodePrintCol.xsl
:: *  @see <tt>make_win.doxygen</tt> for basic doxygen config file.
:: *  @see XSLTdoxFilter.sh for linux version
:: */
::/** @file
:: * @version 06/01/19 for Doxygen 1.8.15
:: * @author Copyright &copy;2006 Marco Sillano.
:: */
rem
::/**
::*  Pseudo-function with actual BAT code.
::*   Uses the xslt2doxfilter.java application to process &lt;xsl:template> and the transformation nodePrintCol.xsl to build the XSLT tree.
::*  @par XSLT &rarr; C-like transformation rules:
::*    @li Extracts only XML comments (&lt;!-- -->) followed by a javadoc style comment: '/'+'*'+'*'
::*    and '*'+'/' <br /> 
::*    @li processes only documentation blocks at first livel, inside the &lt;xsl:stylesheet> root tag.
::*    @li the first documentation block (starting '@'+'file') is the file descripition block.
::*    @li more documentation blocks can be associated to any &lt;xsl:template> tag.
::*  @param %1 the path of the input <tt>*.XSLT</tt> file (mandatory).
::*  @return it uses sout (as required by Doxygen).
::*  @par Debug
::*  The penultimate commented line in code saves the filtered output to file <tt>%1filter.txt</tt>.
::*  @par Example:
::*     See sample_files/.
::*/
rem code starts here:
@ECHO OFF
C:
CD "C:\filters_dox\bin"
  :: rem debug only:
  rem :: java.exe xslt2doxfilter  -d  -i %1  --usr="INLINE_SOURCE&true" > %1out.txt
java.exe xslt2doxfilter -d -i %1   --usr="INLINE_SOURCE&true"
