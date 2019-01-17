rem file doc
::/**  
:: *  @file 
:: *  Enables  <tt>"*.bat" </tt> files documentation in Doxygen (win).
:: *  Tranforms the input 'BAT' file (shellScript) to a 'java-like' file for Doxygen process.
:: *  @par Use:
:: *  Using Doxygen GUI, update doxygen config file in 'expert' tab:
:: *  @li in project/EXSTENSION_MAPPING add 'bat=Java';
:: *  @li in input/FILE_PATTERNS section add value '*.bat'.
:: *  @li in input/FILTER_PATTERNS section set value '*.bat=C:/filters_dox/BatdoxFilter.bat' (path can change).
:: *  @li in input/EXCLUDE_SYMBOLS section add values from '%__pad0__' to '%__pad10__'(workaround for obscure Doxygen quirk).
:: * @par Inline code
:: *  - To include the  <i>BAT code </i> in documentation: set source_browser/INLINE_SOURCE = true and
:: *       input/FILTER_SOURCE_FILES = true.
:: *  @see <tt>make_win.doxygen</tt> for basic doxygen config file.
:: *  @see BatdoxFilter.sh for linux version.
:: */
::/** @file
:: * @version 06/01/19 for Doxygen 1.8.15
:: * @author Copyright &copy;2006 Marco Sillano.
:: */
rem code doc
::/**
::*  Pseudo-function with actual BAT code.
::*  This driver uses @ref regexfilter.java with a regex file 'ad hoc': <tt>rgx\bat2dox.rgx</tt>.
::*  @par BAT &rarr; Java-like transformation rules:
::*    @li Accepts  <tt>'::' </tt> and  <tt>'r|R'+'e|E'+'m|M'+' ' </tt> BAT style comments.
::*    @li Extracts only BAT comments followed by a javadoc style comment:  <tt>'/'+'*'+'*' </tt>
::*    and  <tt>'*'+'/' </tt>
::*    @li In multiline comments, every line must have  <tt>'::'+'*' </tt> or <tt>'rem '+'*' </tt>
::*    @li In code section, double the "rem" or "::" to take a comment in documentation.
::*    @li The first comment block (starting  with  <tt>'@'+'file' </tt>) is the file descripition block.
::*    @li Last comment bock can be the Pseudo-function documentation.
::*    @li Creates a pseudo-function <b><tt> BAT_code() </tt></b> that contains, as comment, the BAT code.
::*  @param %1 the path of the input <tt>*.bat</tt> file (mandatory).
::*  @return it uses sout (as required by Doxygen).
::*  @par Debug
::*  The penultimate commented line in code saves the filtered output to file <tt>%1filter.txt</tt>.
::*  @par Example:
::*     See all  drivers <tt>filters/*.bat</tt>, used by Doxygen.
::*/
@ECHO OFF
C:
CD "C:\filters_dox\bin"
  :: rem debug only:
  rem :: java.exe regexfilter -b rgx\bat2dox.rgx  -i %1 -o %1filter.txt
java.exe regexfilter -b rgx\bat2dox.rgx  -i %1 
