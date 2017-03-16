#!/bin/sh
#/**  @file HTMLdoxFilter_is.sh   
# *   Enables "*.html" (XHTML) files documentation (source) in doxygen (linux).
# *  This filter works only on XHTML files. (You can use <b>tidy</b> to transform HTML to XHTML).<br />
# *  @par use:
# *  Using Doxygen GUI, update config in 'expert' tab:
# *  @li in project/EXSTENSION_MAPPING add 'html=Javascript';
# *  @li in input/FILE_PATTERNS section add the value '*.html' (same for '*.htm', '*xhtml').
# *  @li in input/FILTER_PATTERNS section add the value '*.html=HTMLdoxFilter_is.sh' (path can change).
# *  @li the source HTML code is included in documentation as colored collassable tree.
# *  @li to include the Javascript source in documentation set source_browser/INLINE_SOURCE = true and
# *    input/FILTER_SOURCE_FILES = true.
# *  @see HTMLdoxFilter.sh for no source.
# *  @see HTMLdoxFilter_is.bat for Win version
# *  @see tidy (http://www.w3.org/People/Raggett/tidy/) 
# */

#/**
#*  This filter uses a XSLT file (xslt\html2dox.xslt).
#*  It tranforms the input 'xhtml'
#*   file to a 'javascript-like' function style for Doxygen process.
#*  @param %1 the path of the XHTML input file.
#*  @return it uses sout.
#*  @par note:
#*   @li HTML: this processes comments (&lt;!-- -->) including a javadoc style comment: '/'+'*'+'*'
#*    and '*'+'/' <br /> 
#*    @li HTML: processes only blocks at first livel, i.e. inside the &lt;HTML> tag.
#*    @li HTML: a first optional block (starting '@'+mainpage) is the global documentation block.
#*    @li HTML: a second optional block (starting '@'+file +&lt;name_file>) is the detailed descripition block.
#*    @li HTML: the last bock is the HTML documentation.
#*    @li javascript: all javascript bocks are placed 'as is' after the HTML
#*    @li javascript: all documentation blocks (variables, functions etc.) are processes as usual by doxygen 
#*  @par example:
#*     See filter/sample_files/example01.html.
#*  @see xmlfilter.java
#*/
htmlis_filter (){
# first changedir to the directory of this script
# resolve links - $0 may be a softlink
PRG="$0"

while [ -h "$PRG" ] ; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done
 
cd `dirname "$PRG"`
# test only
java ms/filters/xmlfilter  html2dox.xslt  -i $1
}
#/** Calls htmlis_filter to do the job.
#*   @param $1 the input file path, required */
htmlis_filter $1