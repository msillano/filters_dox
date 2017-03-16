/*
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *  http://gnu.org/licenses/gpl.html
 */
// note: following documentation is escaped and formatted to
// give good HTML pages using Doxygen (not javadoc)

/**
 * @mainpage filters4Doxygen 4.02
 *
 *  This addon allows  BAT, SH, INI, XML, XHTML, XSLT files documentation using 
 *  Doxygen (http://www.doxygen.org).
 *  This contains following filters: <BR>
 *      - <B>BATdoxFilter.sh (BATdoxFilter.bat)</B>       for BAT Script files (win)
 *      - <B>ShdoxFilter.sh (ShdoxFilter.bat)</B>         for shellScrip files (linux)
 *      - <B>XMLdoxFilter.sh (XMLdoxFilter.bat)</B>       for generic XML files (2 versions)
 *      - <B>HTMLdoxFilter.sh (HTMLdoxFilter.bat)</B>      for XHTML files (2 versions)
 *      - <B>XSLTdoxFilter.sh (XSLTdoxFilter.bat)</B>      for XSLT stylesheets 
 *      - <B>oneblockdoxFilter.sh (oneblockdoxFilter.bat)</B>  for text files like INI.
 *
 * @par Implementation
 *   All filters are build using 3 main java applications:
 *       - regexfilter.java, general purpose, it uses regular expressions.
 *       - xmlfilter.java, general purpose, it transforms the XML input using a XSLT stylesheet.
 *       - xslt2doxfilter.java special filter for XSLT file and Doxygen.
 *
 *   Actual filters are BAT (for Windows) or SH (for linux) drivers that associate the java 
 *   application, some parameters and the required auxiliary file (regexp or xslt) to perform 
 *   the transformation of input file to a java-like file. <BR>
 *    
 *   All filter come in WIN and Linux version, tested on win7-64 using Doxygen 1.7.2 and
 *      on Linux Debian [TODO] using Doxygen [TODO].<BR>
 *   
 *
 * @par Examples
 *   This documentation is a good example of how filters work. This documentation is built 
 *      using <B>Doxygen 1.7.2</B> and the included <TT>make-(win|linux)-[no]code.dox</TT>
 *      configuration files. <BR>
 *
 * @par Install (Linux)
 *
 * Extract and copy all files in a dir  (e-g. <TT>/usr/local/opt/doxygen-addon-4.02</TT>) then:
 *   - If "java" is not in PATH you must update all <TT>***Filter.sh</TT> files.
 *   - Verify permissions ad make executable all <TT>***Filter.sh</TT> files.
 *   - Link  all <TT>***Filter.sh</TT> files in a dir on PATH (e-g. <TT>/usr/local/bin</TT>).<BR>
 *
 * To enable rebuild documentation from Konqueror, using only one click in context menu::
 *    - Add the ".dox" filetype "text/x-doxygen".
 *    - Link "doxygen-addon.desktop" in a good place (for debian, can vary): <TT>/usr/share/apps/konqueror/servicemenus/doxygen-addon.desktop</TT> (global) or <TT>/home/user-name/.kde/share/apps/konqueror/servicemenus/doxygen-addon.desktop</TT> (only for user-name).
 *
 * @par Use (Linux) 
 *   - Copy in our source root the file <TT>make-linux-[no]code.dox</TT> and change  (using
 *       doxywizard) the filter paths, the documentation root, etc. to suit our needs.
 *   - Build the documentation using the command <TT>>doxygen make-linux-[no]code.dox</TT> or
 *       directly from doxywizard.
 *
 * @par Install (Windows)
 * Extract and copy all files in a dir  (e.g. <TT>c:\filters</TT>) then:
 *   - You must update all <TT>***Filter.BAT</TT> files using our local PATHS. <BR>
 *
 * To enable rebuild documentation from File Explorer, using only one click in context menu:
 *    - Add the ".dox" filetype "text/x-doxygen", "Doxygen config file"
 *    - Associate in context menu the "execute" action with the Doxygen exe: command "C:\Program Files (x86)\doxygen\bin\doxygen.exe" "%1" (for WIN7, can vary).
 *    - Associate in context menu the "edit" action with the doxywizard exe: command "C:\Program Files (x86)\doxygen\bin\doxywizard.exe" "%1" (for WIN7, can vary).
 *
 * @par Use (Windows)
 *   - Copy in our source root the file <TT>make-win-[no]code.dox</TT> and change (using 
 *       doxywizard) the filter paths (in Expert:Input:FILTER_PATTERNS) using our local PATHS.
     - Change the documentation root, etc. to suit our needs.
 *   - Save, and build the documentation directly from doxywizard, to see all messages.
 *
 * @par License
 * filters4Doxygen 4.02 is under the terms of the GNU General Public License. It can be easy 
 * modified, extended, etc, updating java applications (files java in filters/src/), the regex 
 * files (for regexfilter, in filters/bin/rgx) or the stylesheet files (for xmlfilter, in 
 * filters/bin/xslt) and the driver files xxxxFilter.(sh|bat, in filters/).<BR>
 * Please send any major update to marco.sillano@gmail.com.
 */
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import ms.utils.aarray.baseapp.AABaseAppl;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

/**
 * @file xslt2doxfilter.java
 * This special filter for Doxygen transforms the input XSLT stylesheet to a "java-like" format for Doxygen.</br>
 */

/**
 * Special filter for XSLT file, creates a 'java-like' syntax suitable to be
 * processed by Doxygen.
 * 
 * Every template is processed like a 'java' function. <br />
 * The pseudo-function name is <CODE>nameFile_templateXX()</CODE> or (using '-d'
 * option in command line) <CODE>lastDirName_nameFile_templateXX()</CODE> to
 * allow more files with same 'nameFile'.<br />
 * 
 * The template body is processed as 'java' comment.
 * 
 * @par Use
 * 
 *      <PRE>
 *  Usage:                 xslt2dox       -h|-?|--help|--version
 * 			            xslt2dox       [options] [-i=FILE] [-o=FILE] 
 * 			 Translates the XSLT inputFile in java-like outFile for doxygen
 * 			 
 * 			 -i=FILE, --input=FILE     the XSLT input file.
 * 			                           Default = standard input.
 * 			 -o=FILE, --output=FILE    the text output file.
 * 			                           Default = standard output.
 * 			 options:  -h|-?|--help    display this help and exit.
 * 			           --version       print version and exit.
 * 			           -d              uses dir in name.for pseudo-function
 * </PRE>
 * 
 *      <h4>Notes</h4>
 *      <ul>
 *      <li>All comments blocks are java-like ('/'+'*'+'*') inside XML comment
 *      (&lt;!-- -->) and only at first level (i.e. inside the root
 *      'xsl:stylesheet' tag)
 *      <li>The first block is processed as global file documentation, if it
 *      starts "@"+"file &lt;file-name> ".
 *      <li>Next blocks must be placed before the referenced 'xsl:template'
 *      <li>One extra block can be placed at first place if it starts
 *      "@"+"mainpage"
 *      <li>Inside the XSLT body all the xpaths like '*'+'/' MUST be changed to
 *      '*'+'space'+'/' to avoid misinterpretation
 *      </ul>
 * 
 *      <h4>Notes</h4> This filter splits the XSLT file making a documented
 *      pseudo-function for every &lt;<xsl:template>, but the XML code (in
 *      inline code mode) is not collassable (see html2dox.xslt). <BR>
 *      As alternative any XSLT can be processed as a generic XML file using
 *      XMLdoxFilter, that produces a colored collassable tree, but as a whole
 *      (see example02.xml).
 * 
 * @author M. Sillano (marco.sillano@gmail.com)
 * @version 4.02 10/11/25 (c) M.Sillano 2006-2011
 */

public class xslt2doxfilter extends ZeroFilter {
	// =======================================================
	// standard ZeroFIle extensions
	static private final String version = "xslt2doxfilter 4.02 (10/11/25) \n"
			+ "Copyright (C) 2006-2011  M.Sillano \n"
			+ "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html> \n"
			+ "This is free software: you are free to change and redistribute it. \n"
			+ "There is NO WARRANTY, to the extent permitted by law.";
	//
	static private final String[] xsltHelp = {
			"Usage:     xslt2dox      -h|-?|--help|--version",
			"           xslt2dox       [options] [-i=FILE] [-o=FILE] ",
			"Translates the XSLT inputFile in java-like outFile for doxygen",
			"", "-i=FILE, --input=FILE     the XSLT input file.",
			"                          Default = standard input.",
			"-o=FILE, --output=FILE    the text output file.",
			"                          Default = standard output.",
			"options:  -h|-?|--help    display this help and exit.",
			"          --version       print version and exit.",
			"          -d              dir in name." };

	static private final String Opts = "d";
	//
	static private final String[] Params = { "-input", "i", "-output", "o" };
	//
	static private final String DEFAULT_CONFIG = "xslt2doxfilter.cfg";
	static private final String FILETITLE = "by xslt2doxfilter 4.02 (10/11/25)";

	// end standard stuff
	// =======================================================

	private static String methodName = "";
	//
	private static String colFileName = "xslt/nodePrintCol.xsl";
	private static Templates colorTemplate = null;
	private static boolean inline_HEADER = true;

	/**
	 * Initialize all data structures. Custom setup, it uses
	 * ZeroFilter.startup() for input/output standard processing.
	 * 
	 * @param args
	 *            command line from main().
	 */
	protected static void startup(String[] args) {
		// =======================================================
		// static setup, updates const
		AABaseAppl.version = xslt2doxfilter.version;
		AABaseAppl.helpStrings = xslt2doxfilter.xsltHelp;
		AABaseAppl.fileTitle = xslt2doxfilter.FILETITLE;
		// Dynamic setup, updates const
		aaBase = new AABaseAppl(Opts, Params);
		aaBase.setConfigFile(DEFAULT_CONFIG);
		// read command line args
		ZeroFilter.startup(args);
		// end standard setup
		// =======================================================

		// ...for this filter
		File canonical1 = null;
		File canonical2 = null;
		//
		// sets the extra template name
		if (inFile != null) {
			String fullName = inFile.getName().toLowerCase();
			methodName = fullName.substring(0, fullName.indexOf('.'));
			if (aaBase.isOption("d")) {
				try {
					canonical1 = inFile.getCanonicalFile().getParentFile();
					canonical1 = inFile.getCanonicalFile().getParentFile();
					canonical2 = canonical1.getParentFile();
				} catch (Exception e) {
				}
				if (canonical2 != null) {
					methodName = canonical1.getPath()
							.substring(canonical2.getPath().length() + 1)
							.toLowerCase()
							+ "_" + methodName;
				}
			} else
				methodName = "template";
		}
		return;
	}

	/**
	 * Main static, read and process the XSLT input file.<BR>
	 * The file is read in a DOM Document,
	 * 
	 * @param args
	 *            <pre>
	 *            [options] [-i=FILE] [-o=FILE] 
	 * 		    -i=FILE, --input=FILE     the XSLT input file. 
	 * 		                              Default = standard input.
	 * 		    -o=FILE, --output=FILE    the text output file.
	 * 		                              Default = standard output.
	 * 		    options:  -h|-?|--help    display this help and exit.
	 * 		              --version       print version and exit.
	 * 		              -d              dir in name.
	 * </pre>
	 * 
	 */

	public static void main(String[] args) {
		int nComment = 0;
		int nTemplate = 0;
		String Attributs;
		Document d = null;
		startup(args);
		try {
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();
			// Prepare the input file
			InputSource source = new InputSource(fin);
			// Getting root
			d = db.parse(source);
			// processing all first level Nodes
		} catch (Exception e) {
			aaBase.helpAndDies(e.getMessage());
		}
		Node actualNode = d.getDocumentElement().getFirstChild();
		Node docNode = null;
		while (actualNode != null) {
			if (actualNode.getNodeType() == Node.COMMENT_NODE)
				// only process JAVADOC style Comments (starting /+*+* )
				if (actualNode.getNodeValue().contains("/**")) {
					// the first (extract) Comment MUST be about the file but
					// inside the StyleSheet node (first level)
					if (nComment++ == 0) {
						fout.println(actualNode.getNodeValue().replace("*/", ""));
						// creates TEMPLATES group and prints doc info about
						// XML
						Attributs = " \n* <hr /> xsl:stylesheet";
						// here good place to put some global info as comment
						// lines
						if (d.getXmlVersion() != null)
							Attributs = Attributs + "\n *  XML version  = '"
									+ d.getXmlVersion() + "'";
						if (d.getXmlEncoding() != null)
							Attributs = Attributs + "\n *      encoding = '"
									+ d.getXmlEncoding() + "'";
						if (d.getInputEncoding() != null)
							Attributs = Attributs + "\n *      input    = '"
									+ d.getInputEncoding() + "'";
						if ((d.getDoctype() != null)
								&& (d.getDoctype().getPublicId() != null))
							Attributs = "\n *      DOCTYPE  = '"
									+ d.getDoctype().getPublicId() + "'";
						Attributs = Attributs + "\n */\n";
						// Opening Templates group
						// creates globals param group
						fout.println(Attributs);
						extractParams(d.getDocumentElement(), true);
						fout.println("/**@{*/\n");
					} else
						// the second (extract) Comment MUST be about first
						// Template
						docNode = actualNode;
				}
			// and process every xsl:template, producing something like function
			if (actualNode.getNodeName().equals("xsl:template")) {
				nTemplate++;
				if (docNode != null) {
					fout.println(docNode.getNodeValue().replace("*/", ""));
					writeNodeColor(actualNode);
					fout.println("*/");
					docNode = null;
				}
				else {
// builds default doc					
					fout.println("/** template #"+nTemplate+". \n *\n");
					writeNodeColor(actualNode);
					fout.println("*/");
				}
					
				Attributs = "";
				// transforms attributes to parameters
				for (int i = 0; i < actualNode.getAttributes().getLength(); i++) {
					if (i > 0)
						Attributs = Attributs + ", \n";
					Attributs = Attributs + " Attribute "
							+ actualNode.getAttributes().item(i);
				}
				if (nTemplate < 10)
					fout.print(methodName + "_template_0" + (nTemplate) + "("
							+ Attributs);
				else
					fout.print(methodName + "_template_" + (nTemplate) + "("
							+ Attributs);
				// and adds <xsl:param> (if any)
				extractParams(actualNode, false);
				fout.println("); \n ");
				// fout.println(") \n { /*");
				// writeNodeColor(actualNode);
				// fout.println("\n*/ };");
			}
			// processing only 1 level
			actualNode = actualNode.getNextSibling();
		} // endwhile
			// closing templates group
		fout.println("\n/**@}*/\n");
		fout.flush();
	} // endmain

	/**
	 * Extract, format and print all xsl:param nodes childs.
	 * 
	 * @param node
	 *            a <xsl:template> node or the root template.
	 * @param global
	 *            true if node is the root node (xsl:stylesheet).
	 * @post. Puts the result directly to standard out.
	 */
	public static void extractParams(Node node, Boolean global) {
		String Params = "";
		String Include = "";
		if (node.hasChildNodes()) {
			NodeList childs = node.getChildNodes();
			for (int i = 0; i < childs.getLength(); i++) {
				if (childs.item(i).getNodeName().equals("xsl:param")) {
					// format interline start
					if (global & (Params != ""))
						Params = Params + "; \n Param ";
					if (global & (Params == ""))
						Params = " Param ";
					if ((!global) & (Params != ""))
						Params = Params + ", \n Param ";
					if ((!global) & (Params == ""))
						Params = ", \n Param ";
					// now the pseudo-parameter
					Params = Params
							+ childs.item(i).getAttributes()
									.getNamedItem("name").getNodeValue();
					Params = Params + " = \"" + childs.item(i).getTextContent()
							+ "\"";
					// interline format
					if (global)
						Params = Params
								+ " /**<  stylesheet parameter (external) */";
				}
				if (childs.item(i).getNodeName().equals("xsl:import")) {
					// format interline start
					Include += "include \"" + childs.item(i).getAttributes()
					.getNamedItem("href").getNodeValue() + "\"; \n";
				}
			}
			// block format end
			if (global & (Params != ""))
				Params = Params + "; \n  ";
			if ((!global) & (Params != ""))
				Params = Params + "";
			if (Include != "")
				Include = "/** @par import \n" + Include +" */\n";
			fout.println(Include + Params);
		}
	}

	/**
	 * Print out a XML tree.
	 * 
	 * @param node
	 *            the root of tree.
	 * @post. Puts the result directly to standard out.
	 */
	private static void writeNodeSimple(Node node) {
		fout.println(") \n { /*");
		try {
			// Prepare the DOM document for writing
			Source source = new DOMSource(node);
			Result result = new StreamResult(fout);
			// Write the DOM document to output
			Transformer xformer = TransformerFactory.newInstance()
					.newTransformer();
			xformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
			xformer.transform(source, result);
		} catch (TransformerConfigurationException e) {
			e.printStackTrace();
		} catch (TransformerException e) {
			e.printStackTrace();
		}
		fout.println("\n*/ };");
		fout.flush();
	}

	private static void writeNodeColor(Node node) {
		// fout.println(") \n {} /**");
		if (colorTemplate == null) {
			File colFile = new File(colFileName);
			if (!colFile.canRead())
				aaBase.helpAndDies("ERROR: cant read xsl file " + colFileName);
			// Create transformer factory
			TransformerFactory factory = TransformerFactory.newInstance();
			// Use the factory to create a template containing the xsl file
			try {
				colorTemplate = factory.newTemplates(new StreamSource(
						new FileInputStream(colFile)));
			} catch (Exception e) {
				aaBase.helpAndDies("XML ERROR: " + e.getMessage());
			}
		}
		// Use the template to create a transformer
		Transformer xformer = null;
		try {
			xformer = colorTemplate.newTransformer();
		} catch (Exception e) {
			aaBase.helpAndDies("XML ERROR: " + e.getMessage());
		}

		// Setting default output properties
		xformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
		if (inFile == null)
			xformer.setParameter("fileName", "standard input");
		else
			xformer.setParameter("fileName", inFile.getName().toLowerCase());

		if (inline_HEADER == true) {
			xformer.setParameter("INLINE_HEADER", "true");
			inline_HEADER = false;
		}
		// Prepare the input file
		Source source = new DOMSource(node);
		// Prepare the output
		Result result = new StreamResult(fout);
		// Apply the xsl file to the source and put result to out
		try {
			xformer.transform(source, result);
		} catch (TransformerException e) {
			aaBase.helpAndDies("XML ERROR: " + e.getMessage());
		}
		// fout.println("\n*/ ");
		fout.flush();
		return;
	}

}
