<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:pf="http://www.daisy.org/ns/pipeline/functions"
                xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:px="http://www.daisy.org/ns/pipeline/xproc"
                exclude-result-prefixes="#all"
                version="2.0">
	
	<xsl:param name="input-base-uri"/>
	<xsl:param name="output-base-uri"/>
	
	<xsl:include href="serialize.xsl"/>
	<xsl:include href="../lib/uri-functions.xsl"/>
	
	<xsl:output name="html" method="html"/>
	
	<xsl:variable name="output-uri" select="concat(resolve-uri(pf:relativize-uri(base-uri(/*),$input-base-uri),$output-base-uri), '.html')"/>
	
	<xsl:template match="/">
		<xsl:result-document format="html" href="{$output-uri}">
			<html vocab="http://www.daisy.org/ns/pipeline/" typeof="source">
				<xsl:variable name="source" select="pf:relativize-uri(base-uri(/*),$output-uri)"/>
				<head>
					<link rev="doc" href="{$source}"/>
				</head>
				<body>
					<div class="code" about="{$source}">
						<xsl:apply-templates mode="serialize" select="/*"/>
					</div>
				</body>
			</html>
		</xsl:result-document>
	</xsl:template>

	<xsl:template mode="attribute-value"
	              match="p:import/@href|
	                     p:xslt/p:input[@port='stylesheet']/p:document/@href">
		<a href="{pf:relativize-uri(resolve-uri(.,base-uri(/*)),$output-uri)}" class="source">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	
	<xsl:template mode="serialize" match="/p:*/p:option[not(@px:output=('result','temp') or @px:type='anyFileURI')]">
		<span rel="option">
			<xsl:next-match/>
		</span>
	</xsl:template>
	
	<xsl:template mode="serialize" match="/p:*/p:input|
	                                      /p:*/p:option[not(@px:output=('result','temp')) and @px:type='anyFileURI']">
		<span rel="input">
			<xsl:next-match/>
		</span>
	</xsl:template>
	
	<xsl:template mode="serialize" match="/p:*/p:output|
	                                      /p:*/p:option[@px:output='result']">
		<span rel="output">
			<xsl:next-match/>
		</span>
	</xsl:template>
	
	<xsl:template mode="serialize" match="/p:*/p:option[@px:output='temp']">
		<!--
		    ignore
		-->
	</xsl:template>
	
	<xsl:template mode="attribute-value" match="/p:*/p:input/@port|
	                                            /p:*/p:output/@port|
	                                            /p:*/p:option/@name">
		<span property="id">
			<xsl:value-of select="."/>
		</span>
	</xsl:template>
	
	<xsl:template mode="attribute-value" match="/p:*/p:input/@sequence|
	                                            /p:*/p:output/@sequence|
	                                            /p:*/p:option[@px:type='anyFileURI']/@px:sequence">
		<span property="sequence" datatype="xsd:boolean">
			<xsl:value-of select="."/>
		</span>
	</xsl:template>
	
	<xsl:template mode="attribute-value" match="/p:*/p:option[not(@px:output='result' or @px:type='anyFileURI')]/@required">
		<span property="required" datatype="xsd:boolean">
			<xsl:value-of select="."/>
		</span>
	</xsl:template>
	
	<xsl:variable name="STRING_RE">^\s*('([^']*)'|"([^"]*)")\s*$</xsl:variable>
	
	<xsl:template mode="attribute-value" match="/p:*/p:option[not(@px:output='result' or @px:type='anyFileURI')]/@select">
		<span property="default">
			<xsl:value-of select="replace(.,$STRING_RE,'$2$3')"/>
		</span>
	</xsl:template>
	
	<xsl:template mode="attribute-value" match="/p:*/p:option[not(@px:output='result' or @px:type='anyFileURI')]/@px:data-type|
	                                            /p:*/p:option[not(@px:output='result' or @px:type='anyFileURI' or @px:data-type)]/@px:type">
		<span property="data-type">
			<xsl:value-of select="."/>
		</span>
	</xsl:template>
	
	<xsl:template mode="attribute-value" match="/p:*/p:input/@px:media-type|
	                                            /p:*/p:output/@px:media-type|
	                                            /p:*/p:option[@px:output='result' or @px:type='anyFileURI']/@px:media-type">
		<span property="media-type">
			<xsl:value-of select="."/>
		</span>
	</xsl:template>
	
	<xsl:template mode="serialize"
	              match="/p:*/p:option/p:documentation/*[@px:role='name']|
	                     /p:*/p:input/p:documentation/*[@px:role='name']|
	                     /p:*/p:output/p:documentation/*[@px:role='name']">
		<span property="name" content="{string(.)}">
			<xsl:next-match/>
		</span>
	</xsl:template>
	
	<xsl:template mode="serialize"
	              match="/p:*/p:option/p:documentation/*[@px:role='desc']|
	                     /p:*/p:input/p:documentation/*[@px:role='desc']|
	                     /p:*/p:output/p:documentation/*[@px:role='desc']">
		<xsl:variable name="content" as="node()*">
			<xsl:apply-templates mode="serialize"/>
		</xsl:variable>
		<span property="desc" content="{string-join($content/string(),'')}">
			<xsl:next-match/>
		</span>
	</xsl:template>
	
</xsl:stylesheet>
