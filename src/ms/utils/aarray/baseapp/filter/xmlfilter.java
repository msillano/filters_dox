/*
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *  http://gnu.org/licenses/gpl.html
 */
// note: following documentation is escaped and formatted to
// give good HTML pages using Doxygen (not javadoc)

/**
 * @package ms.filters
 * General purpose text filters. 
 */

// note: following documentation is escaped and formatted to
// give good HTML pages using doxygen (see
// http://java.sun.com/javase/6/docs/api/java/util/regex/Pattern.html#sum )


/**
 * @file xmlfilter.java
 * Filter input XML (XHTML) using a XSLT stylesheet.
 * 
 * This application implements a general purpose XML Transformer using XSLT.
 * 
 * The input file (or standard input) must be a valid XML/XHTML file. It is Transformed
 * using a XSLT stylesheet (xslFile) and the output is send to standard output or
 * saved in a file.<br>
 * Parameters on command line or in configuration file allows full control on output.
 * @htmlonly
 * @par Use
 * <PRE>
 Usage:        xmlfilter   -h|-?|--help|--version
               xmlfilter   [-i=FILE] [-u=FILE] [xslFile] [properties]*
               xmlfilter   [--CTextconfigload=FILE]|[--CXmlconfigload=FILE] 
 
             Transforms the XML inputFile, using a XSLT stylesheet (xslFile).

    -i=FILE, --input=FILE     the XML input file. Default = standard input.
    -o=FILE, --output=FILE    the output file. Default = standard output.
    xslFile:                  XSLT stylesheet file. Default = ./xmlfilter.xsl.

    options:  -h|-?|--help    display this help and exit.
              --version       print version and exit.

    more optional output properties for a Transformer: 

    --omit_xml_declaration=yes|no  
                              Default = yes
    --indent=yes|no           Default = indent
    --method=xml|html|text    Default = html
    --encoding=CODE           Char code
    --standalone=yes|no       Declaration style
    --doctype_system=DOCTYPE  used in the document type declaration. 
    --doctype_public=PUBLIC   public identifier.
    --cdata_section_elements="LIST" 
                              specifies a whitespace delimited list of qnames
    --media_type=MIME         output MIME content type.

    --usr_parameter=name&value
                              Additional parameters passed to xslt.
                                &ls;local or qname>+"&amp;"+&lsvalue>   

    --CTextconfigload=FILE     reads option/param from a config file, text mode. 
                                 default=xmlfilter.cfg 
    --CXmlconfigload=FILE      reads option/param from a config file, XML mode. 
                                 default=xmlfilter.cfg 
    --CSaveconfig=FILE         saves all options/parameter to a config file,
                                 default=xmlfilter.cfg"
 </PRE>	  
 @endhtmlonly                        
 * 
*/

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import ms.utils.aarray.baseapp.AABaseAppl;

/**
 * Stand-alone filter using a XSLT Transformer.
 * Extends ZeroFilter defining private data structures: version, help, 
 * Option, Parameter and default file names.<BR>
 * Input/Output from/to files or standard in/out.<BR>
 * Full configurable, this application can read options from command line or
 * from a configuration file. <BR>
 * 
 * @see javax.xml.transform
 * 
 * @author M. Sillano (marco.sillano@gmail.com)
 * @version 4.02 10/11/25 (c) M.Sillano 2006-2011
 */
public class xmlfilter extends ZeroFilter {
	// =======================================================
	// standard ZeroFIle extensions
	static private final String version = "xmlfilter (ms-doxygen-addons) 4.02 (10/11/25) \n"
			+ "Copyright (C) 2006-2011  M.Sillano \n"
			+ "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html> \n"
			+ "This is free software: you are free to change and redistribute it. \n"
			+ "There is NO WARRANTY, to the extent permitted by law.";

	static private final String[] xmlHelp = {
			"Usage:     xmlfilter      -h|-?|--help|--version",
			"           xmlfilter      [-i=FILE] [-o=FILE] [xslFile] [properties]",
			"           xmlfilter      [--CTextconfigload=FILE]|[--CXmlconfigload=FILE]",
			"Transforms the inputFile, using a XSLT stylesheet (xslFile).",
			"",
			"-i=FILE, --input=FILE     the XML input file.",
			"                          Default = standard input.",
			"-o=FILE, --output=FILE    the output file.",
			"                          Default = standard output.",
			"xslFile                   XSLT stylesheet file. Default = ./xmlfilter.xsl.",
			"options:  -h|-?|--help    display this help and exit.",
			"          --version       print version and exit.",
			
			"more optional output properties for a Transformer: ",
			"--omit_xml_declaration=yes|no  ",
			"                          Default = yes",
			"--indent=yes|no           Default = indent",
			"--method=xml|html|text    Default = html",
			"--encoding=CODE           Char code",
			"--standalone=yes|no       Declaration style",
			"--doctype_system=DOCTYPE  used in the document type declaration. ",
			"--doctype_public=PUBLIC   public identifier.",
			"--cdata_section_elements=\"LIST\" ",
			"                          specifies a whitespace delimited list of qnames",
			"--media_type=MIME         MIME content type.",
			"--usr_parameter=name&value Additional parameters passed to xsl.",
			"                          <local|qname>+\"&\"+<value>",

			"--CTextconfigload=FILE    read option/param from a config file, text mode ",
			"                          default=xmlfilter.cfg ",
			"--CXmlconfigload=FILE     read option/param from a config file, XML mode ",
			"                          default=xmlfilter.cfg ",
			"--CSaveconfig=FILE        save all options/parameter to a conifg file,",
			"                          default=xmlfilter.cfg" };

	//
	static private final String Opts = "";

	//
	static private final String[] Params = { "-input", "i", "-output", "o",
			"-omit_xml_declaration", "-indent", "-method", "-encoding",
			"-standalone", "-doctype_system", "-doctype_public",
			"-cdata_section_elements", "-media_type", "-usr_parameter" };

	//
	static private final String DEFAULT_XSLFILE = "xmlfilter.xsl";
	static private final String DEFAULT_CONFIG = "xmlfilter.cfg";
	static private final String FILETITLE = "by xmlfilter 4.02 (10/11/25)";

	// end standard stuff
	// =======================================================

	static private String xslFileN = null;

	/**
	 * Initialize all data structures. Custom setup, it uses ZeroFilter.startup
	 * for input/output standard processing.
	 * 
	 * @param args
	 *            command line from main().
	 */
	protected static void startup(String[] args) {
		// =======================================================
		// static setup
		AABaseAppl.version = xmlfilter.version;
		AABaseAppl.helpStrings = xmlfilter.xmlHelp;
		AABaseAppl.fileTitle = xmlfilter.FILETITLE;
		// Dynamic setup
		aaBase = new AABaseAppl(Opts, Params);
		aaBase.setConfigFile(DEFAULT_CONFIG);
		ZeroFilter.startup(args);
		// end standard setup
		// =======================================================

		// ...for this filter
		// Default XSLT transformation file
		xslFileN = aaBase.getArgument(1);
		if (xslFileN == null)
			xslFileN = DEFAULT_XSLFILE;
		return;
	}

	/**
	 * Main static, implements a XSLT transformer. All user optional output
	 * properties are applied to Transformer.
	 * 
	 * @param args command line processed by startup()
	 */

	public static void main(String[] args) {
		startup(args);
		try {
			File xslFile = new File(xslFileN);
			if (!xslFile.canRead())
				aaBase.helpAndDies("ERROR: cant read xsl file " + xslFileN);
			// Create transformer factory
			TransformerFactory factory = TransformerFactory.newInstance();
			// Use the factory to create a template containing the xsl file
			Templates template = factory.newTemplates(new StreamSource(
					new FileInputStream(xslFile)));
			// Use the template to create a transformer
			Transformer xformer = template.newTransformer();

			// Setting default output properties
			String value = aaBase.getParam("-omit_xml_declaration", "yes");
			xformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, value);

			value = aaBase.getParam("-indent", "yes");
			xformer.setOutputProperty(OutputKeys.INDENT, value);

			value = aaBase.getParam("-method", "html");
			xformer.setOutputProperty(OutputKeys.METHOD, value);

			// Setting user properties
			value = aaBase.getParam("-encoding", 0);
			if (value != null)
				xformer.setOutputProperty(OutputKeys.ENCODING, value);
			value = aaBase.getParam("-standalone", 0);
			if (value != null)
				xformer.setOutputProperty(OutputKeys.STANDALONE, value);
			value = aaBase.getParam("-doctype_system", 0);
			if (value != null)
				xformer.setOutputProperty(OutputKeys.DOCTYPE_SYSTEM, value);
			value = aaBase.getParam("-doctype_public", 0);
			if (value != null)
				xformer.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, value);
			value = aaBase.getParam("-cdata_section_elements", 0);
			if (value != null)
				xformer.setOutputProperty(OutputKeys.CDATA_SECTION_ELEMENTS,
						value);
			value = aaBase.getParam("-media_type", 0);
			if (value != null)
				xformer.setOutputProperty(OutputKeys.MEDIA_TYPE, value);

			// Passing default parameters - input file name
			if (inFile == null)
				xformer.setParameter("fileName", "standard input");
			else {
				xformer.setParameter("fileName", inFile.getName().toLowerCase());
			}

			// Passing user params
			for (int i = aaBase.getParamCount("-usr_parameter"); i > 0; i--) {
				String[] splitted = aaBase.getParam("-usr_parameter", i).split(
						"&", 2);
				if (splitted.length > 1)
					xformer.setParameter(splitted[0], splitted[1]);
			}
			// Prepare the input file
			Source source = new StreamSource(fin);
			// Prepare the output
			Result result = new StreamResult(fout);
			// Apply the xsl file to the source and put result to out
			xformer.transform(source, result);
			// fin.close();
			fout.flush();
			fout.close();
			return;
		} catch (FileNotFoundException e) {
			e.printStackTrace();

		} catch (TransformerConfigurationException e) {
			// An error occurred in the XSL file
			e.printStackTrace();
		} catch (TransformerException e) {
			// An error occurred while applying the XSL file
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return;
	}
}
