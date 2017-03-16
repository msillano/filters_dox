#!/bin/sh

# /**  
# *   @file XMLdoxFilter_is.sh 
# *   Enables "*.xml" files documentation (source) in doxygen (linux).
# *   Includes the xml source as collassable tree, syntax colored.
# *  @par use:
# *  Using Doxygen GUI, update config in 'expert' tab:
# *  @li in project/EXSTENSION_MAPPING add 'xml=java';
# *  @li in input/FILE_PATTERNS section add the value '*.xml'
# *  @li in input/FILTER_PATTERNS section add the value '*.xml=C:/filters/HTMLdoxFilter.bat' (path can change).
# *  @li to exclude the source XML in documentation use XMLdoxFilter.sh.
# *  @see XMLdoxFilter_is.bat for Win version
# */
#
#/**
#*  This filter uses a XSLT file (xslt\xml2dox.xslt) to do a tranformation on the input, a well formed XML 
#*   file to a 'java-like' function style for Doxygen process.
#*  @param %1 the path of the XML input file.
#*  @return it uses sout.
#*  @par note:
#*   @li processes comments (&lt;!-- -->) followed by a javadoc style comment: '/'+'*'+'*'
#*    and '*'+'/' <br /> 
#*    @li processes only blocks at first livel, inside the root tag.
#*    @li a first optional block (starting '@'+'mainpage') is the global documentation block.
#*    @li a second optional block (starting '@'+'file' +&lt;name_file>) is the detailed descripition block.
#*    @li the last bock is the XML documentation (as a whole).
#*    @li the source XML code is included in the documentation (INLINE_SOURCE = true).
#*  @par example:
#*     See sample_files/example01.xml.
#*   @see xmlfilter.java
#*/


xmlis_filter (){
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
java ms/filters/xmlfilter  xml2dox.xslt  -i $1 
}
#/** calls xmlis_filter to do the job.
# *  @param $1 the input file name, required. */
xmlis_filter $1

