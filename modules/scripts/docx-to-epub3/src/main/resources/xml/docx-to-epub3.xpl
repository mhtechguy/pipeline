<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step type="px:docx-to-epub3" version="1.0"
                xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:px="http://www.daisy.org/ns/pipeline/xproc"
                xmlns:xsw="http://coko.foundation/xsweet"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                exclude-inline-prefixes="#all">
	
	<p:option name="docx" required="true" px:type="anyFileURI" px:sequence="false"
	          px:media-type="application/vnd.openxmlformats-officedocument.wordprocessingml.document"/>
	
	<p:option name="output-dir" required="true" px:output="result" px:type="anyDirURI">
		<p:documentation xmlns="http://www.w3.org/1999/xhtml">
			<h2 px:role="name">EPUB</h2>
			<p px:role="desc">The resulting EPUB 3 publication.</p>
		</p:documentation>
	</p:option>
	
	<p:import href="http://coko.foundation/xsweet/library.xpl"/>
	<p:import href="http://www.daisy.org/pipeline/modules/file-utils/library.xpl"/>
	<p:import href="http://www.daisy.org/pipeline/modules/html-to-epub3/library.xpl"/>
	<p:import href="http://www.daisy.org/pipeline/modules/epub3-ocf-utils/library.xpl"/>
	
	<px:normalize-uri name="output-dir-uri">
		<p:with-option name="href" select="concat($output-dir,'/')"/>
	</px:normalize-uri>
	<p:sink/>
	
	<p:group>
		<p:variable name="output-dir-uri" select="/c:result/string()">
			<p:pipe port="normalized" step="output-dir-uri"/>
		</p:variable>
		<p:variable name="epub-file-uri"
		            select="concat($output-dir-uri, replace($docx,'^.*/([^/]*)\.[^/\.]*$','$1.epub'))"/>
		
		<xsw:docx-to-html5>
			<p:with-option name="docx-file-uri" select="$docx"/>
		</xsw:docx-to-html5>
		
		<px:html-to-epub3-convert name="convert">
			<p:with-option name="output-dir" select="$output-dir-uri"/>
		</px:html-to-epub3-convert>

		<px:epub3-store>
			<p:with-option name="href" select="$epub-file-uri"/>
			<p:input port="in-memory.in">
				<p:pipe port="in-memory.out" step="convert"/>
			</p:input>
		</px:epub3-store>
	</p:group>
	
</p:declare-step>
