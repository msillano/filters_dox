#!/bin/sh
# /**  
# *   @file
# *   Enables "*.xml" files documentation (no source) in doxygen (linux).
# *  @par use:
# *  Using Doxygen GUI, update config in 'expert' tab:
# *  @li in project/EXSTENSION_MAPPING add 'xml=java';
# *  @li in input/FILE_PATTERNS section add the value '*.xml'
# *  @li in input/FILTER_PATTERNS section add the value '*.xml=HTMLdoxFilter.sh' (if in path).
# *  @see XMLdoxFilter.bat for Win version
# */
#
#/**
#*  This filter uses a XSLT file (xslt\xml2dox.xslt) to do a tranformation on the input 'xml'
#*   file to a 'java-like' function style for Doxygen process.
#*  @param %1 the path of the XML input file.
#*  @return it uses sout.
#*  @par note:
#*   @li processes comments (&lt;!-- -->) followed by a javadoc style comment: '/'+'*'+'*'
#*    and '*'+'/' <br /> 
#*    @li processes only blocks at first livel, inside the root tag.
#*    @li a first optional block (starting '@'+'mainpage') is the global documentation block.
#*    @li a second optional block (starting '@'+'file') is the detailed descripition block.
#*    @li the last bock is the XML documentation (as a whole).
#*  @par example:
#*     See sample_files/example01.xml.
#*   @see xmlfilter.java
#*/

xml_filter (){
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
# usr_parameter INLINE_SOURCE=true (same as doxygen flag) default
java  xmlfilter  xslt\xml2dox.xslt  -i $1 --usr="INLINE_SOURCE&false"
}
#/** calls xml_filter to do the job.
# *  @param $1 the input file name, required. */
xml_filter $1

