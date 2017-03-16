#!/bin/sh
#/**  @file XSLTdoxFilter.sh    Filter for stylesheet transformation files (*.xslt, *.xsl) */

#/**  This filter process every template-tag as a pseudo-function, putting the XMLT as comment in the function body.@n
#* For more uniform results, use in config FILTER_SOURCE_FILES    = YES, INLINE_SOURCES         = YES.
#*
#* @see xslt2dox.java
#*/

# /**  
# *   @file XSLTdoxFilter.sh 
# *    Enables XSLT ("*.xsl") files documentation in doxygen (linux).
# *  @par use:
# *  Using Doxygen GUI, update config in 'expert' tab:
# *  @li in project/EXSTENSION_MAPPING add 'xsl=java';
# *  @li in input/FILE_PATTERNS section add the value '*.xsl'
# *  @li in input/FILTER_PATTERNS section add the value '*.xml=C:/filters/HTMLdoxFilter.bat' (path can change).
# *  @li to include the source in documentation set source_browser/INLINE_SOURCE = true and
# *   input/FILTER_SOURCE_FILES = true.
# *  @see XSLTdoxFilter.bat for Win version
# */
#
#/**
#*  This filter does a transformation of input 'xmlt' file 
#*   to a 'java-like' style for Doxygen process. Uses the xslt2doxfilter.java application.
#*  @param %1 the path of the XSLT input file.
#*  @return it uses sout.
#*  @par note:
#*    @li Extracts only XML comments (&lt;!-- -->) followed by a javadoc style comment: '/'+'*'+'*'
#*    and '*'+'/' <br /> 
#*    @li processes only documentation blocks at first livel, inside the &lt;xsl:stylesheet> root tag.
#*    @li a first optional block (starting '@'+mainpage) is the global documentation block.
#*    @li a second optional block (starting '@'+'file' +&lt;name_file>) is the detailed descripition block.
#*    @li all next blocks are associated to following &lt;xsl:template>
#*  @par example:
#*     See bin/xslt/libPrintCol.xsl.
#*   @see xslt2doxfilter.java
#*/

xslt_filter () {
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
#test  only
#java xslt2dox -d $1  >xsltout.txt
java xslt2dox -d $1
}
#/** calls xmlt_filter to do the job.
# *  @param $1 the input file name, required. */

xslt_filter $1