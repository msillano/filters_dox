rem global
:: /**  
:: *   @file  
:: *   Enables "*.xml" files documentation in Doxygen (win).
:: *  Tranforms the input 'XML' file to a 'C-like' file for Doxygen process.
:: *  @par use:
:: *  Using Doxygen GUI, update config in 'expert' tab:
:: *  @li in input/FILTER_PATTERNS section add the value '*.xml=C:/filters_dox/XMLdoxFilter.bat' (path can change).
:: *  @li in input/FILE_PATTERNS section add the value '*.xml' 
:: *  @li in project/EXSTENSION_MAPPING add 'xml=C';
:: * @par Inline code
:: *  - To include the <i>XML code </i>as a colorful tree in documentation: set <tt>INLINE_SOURCE&true</tt> in this driver.
:: *  - When <tt>INLINE_SOURCE&true</tt> you can choose the tree initial look: open|close. Modify the parameter <tt>'status'</tt> on @ref xml2dox.xslt
:: *  @see <tt>make_win.doxygen</tt> for basic doxygen config file.
:: *  @see XMLdoxFilter.sh for linux version
:: */
::/** @file
:: * @version 06/01/19 for Doxygen 1.8.15
:: * @author Copyright &copy;2006 Marco Sillano.
:: */
rem
::/**
::*  Pseudo-function with actual BAT code.
::*  This driver uses @ref xmlfilter.java  with the transformation 'ad hoc': xslt\xml2dox.xslt.
::*  @par XML &rarr; C-like transformation rules:
::*   @li processes comments (&lt;!-- -->) followed by a C++ style comment: '/'+'*'+'*'
::*    and '*'+'/' <br /> 
::*    @li processes only documentation blocks at first livel, inside the root tag.
::*    @li The first documentation block (starting  with  <tt>'@'+'file' </tt>) is the file descripition block.
::*    @li the last bock can be the XML code documentation.
::*  @param %1 the path of the input <tt>*.xml</tt> file (mandatory).
::*  @return it uses sout (as required by Doxygen).
::*  @par Debug
::*  The penultimate commented line in code saves the filtered output to file <tt>%1filter.txt</tt>.
::*  @par example:
::*     See sample_files/example01.xml.
::*   @see xmlfilter.java
::*/
rem code starts here:
@ECHO OFF
C:
CD "C:\filters_dox\bin"
  :: rem debug only:
  rem :: java.exe  xmlfilter  xslt\xml2dox.xslt -i %1  --usr="INLINE_SOURCE&true" > %1filter.txt
java.exe  xmlfilter  xslt\xml2dox.xslt -i %1  --usr="INLINE_SOURCE&true" 
