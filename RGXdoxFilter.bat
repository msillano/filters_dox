rem global
::   /**  @file   
:: *  Enables "*.rgx" files documentation in doxygen (win).
:: *  Transforms the input '.rgx' file to a java-like style for Doxygen process.<br> 
:: *  <i>RGX is a custom TXT format to store the regular expressions used by @ref regexfilter.java.</i>
:: *  @par use:
:: *  Using Doxygen GUI, update config in 'expert' tab:
:: *  @li project/EXTENSION_MAPPING section set 'rgx=Java'
:: *  @li input/FILTER_PATTERNS section set value '*.rgx=C:/filters_dox/oneblockdoxFilter.bat' (path can change).
:: *  @li input/FILE_PATTERNS section add value '*.rgx' 
:: * @par Inline code
:: *  - To include the  <i>RGX code </i> in documentation: set source_browser/INLINE_SOURCE = true and
:: *       input/FILTER_SOURCE_FILES = true.
:: *  @see <tt>make_win.doxygen</tt> for basic doxygen config file.
:: * @see RGXFilter.sh for linux version.
:: * @note
:: *   Here this filter is used to document <tt>*.rgx</tt> files, but 
:: *  it can be useful for many TXT formats not programmation-like, as INI file. Filters only documentation blocks.
::   */
::  /** @file
:: * @version 06/01/19 for Doxygen 1.8.15
:: * @author Copyright &copy;2006 Marco Sillano.
:: */
::
::/**
::*  Pseudo-function with actual BAT code.
::*  This driver uses @ref regexfilter.java with a regex file 'ad hoc': <tt>rgx\rgx2dox.rgx</tt>.
::*  @param %1 the path of the input file.
::*  @par RGX &rarr; Java-like transformation rules:
::*    @li Accepts '#' (in first position) as comment mark.
::*    @li Extracts only '#' comments followed by a java block style comment: '#'+'/'+'*'+'*'  and '#'+'*'+'/'. 
::*    @li In multiline comments, every line can have '#'+'*' or only "#".
::*    @li The first block (starting '@'+'file') is the detailed file descripition block.
::*    @li The last bock can be the RGX code documentation.
::*    @li A pseudo-function <tt>RGX_code()</tt> contains (as Java comment) the original RGX code.
::*    @li For inline comments into the RGX code use duplicate '#' ('##').
::*  @param %1 the path of the input <tt>*.rgx</tt> file (mandatory).
::*  @return it uses sout (as required by Doxygen).
::*  @par Debug
::*    The penultimate commented line in code saves the filtered output to file <tt>%1filter.txt</tt>.
::*  @par example:
::*     See all filters/bin/rgx/*.rgx files.
::*  @see regexfilter.java
::*/
@ECHO OFF
C:
CD "C:\filters_dox\bin"
  :: rem debug only:
  rem :: java.exe regexfilter -b rgx\rgx2dox.rgx  -i %1 > %1filter.txt
java.exe regexfilter -b rgx\rgx2dox.rgx  -i %1
