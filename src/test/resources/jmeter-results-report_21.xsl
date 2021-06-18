<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" />
	<!-- Defined parameters (overrideable) -->
	<xsl:param    name="showData" select="'n'"/>
	<xsl:param    name="titleReport" select="'测试报告'"/>
	<xsl:param    name="dateReport" select="'date not defined'"/>

	<xsl:template match="testResults">
		<html>
			<head>
				<title><xsl:value-of select="$titleReport" /></title>
				<style type="text/css">
					body {
					font:normal 12px verdana,arial,helvetica;
					color:#000000;
					}
					table tr td, table tr th {
					font-size: 12px;
					}
					table.details tr th{
					color: #ffffff;
					font-weight: bold;
					background:#2674a6;
					white-space:pre-wrap;
					}
					table.details tr td{
					background:#eeeee0;
					}
					h1 {
					margin: 0px 0px 5px; font: 165% verdana,arial,helvetica
					}
					h2 {
					margin-top: 1em; margin-bottom: 0.5em; font: bold 125% verdana,arial,helvetica
					}
					h3 {
					margin-bottom: 0.5em; font: bold 115% verdana,arial,helvetica
					}

					a {
					text-decoration:none;
					}

					.Failure {
					font-weight:bold; color:red;
					}

					img
					{
					border-width: 0px;
					}

					.expand_link
					{
					font-size:20px;
					}

					.page_details
					{
					display: none;
					}

					.page_details_expanded
					{
					display: block;
					display/* hide this definition from  IE5/6 */: table-row;
					}
					.detail, #tdetail {
					display: block;
					white-space: pre-wrap;
					}

				</style>
				<script language="JavaScript"><![CDATA[
                           function expand(details_id)
               {

                  document.getElementById(details_id).className = "page_details_expanded";
               }

               function collapse(details_id)
               {

                  document.getElementById(details_id).className = "page_details";
               }

               function change(details_id)
               {
                    var objImg = document.getElementById(details_id+"_image");
                  if(objImg.alt == "collapse")
                  {
                     objImg.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAAZiS0dEALQADQANam36RQAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAd0SU1FB9wDDQ0hOymuu20AAAL5dEVYdENvbW1lbnQATGljZW5zZWQgdG8gdGhlIEFwYWNoZSBTb2Z0d2FyZSBGb3VuZGF0aW9uIChBU0YpIHVuZGVyIG9uZSBvciBtb3JlCmNvbnRyaWJ1dG9yIGxpY2Vuc2UgYWdyZWVtZW50cy4gIFNlZSB0aGUgTk9USUNFIGZpbGUgZGlzdHJpYnV0ZWQgd2l0aAp0aGlzIHdvcmsgZm9yIGFkZGl0aW9uYWwgaW5mb3JtYXRpb24gcmVnYXJkaW5nIGNvcHlyaWdodCBvd25lcnNoaXAuClRoZSBBU0YgbGljZW5zZXMgdGhpcyBmaWxlIHRvIFlvdSB1bmRlciB0aGUgQXBhY2hlIExpY2Vuc2UsIFZlcnNpb24gMi4wCih0aGUgIkxpY2Vuc2UiKTsgeW91IG1heSBub3QgdXNlIHRoaXMgZmlsZSBleGNlcHQgaW4gY29tcGxpYW5jZSB3aXRoCnRoZSBMaWNlbnNlLiAgWW91IG1heSBvYnRhaW4gYSBjb3B5IG9mIHRoZSBMaWNlbnNlIGF0CgogICBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjAKClVubGVzcyByZXF1aXJlZCBieSBhcHBsaWNhYmxlIGxhdyBvciBhZ3JlZWQgdG8gaW4gd3JpdGluZywgc29mdHdhcmUKZGlzdHJpYnV0ZWQgdW5kZXIgdGhlIExpY2Vuc2UgaXMgZGlzdHJpYnV0ZWQgb24gYW4gIkFTIElTIiBCQVNJUywKV0lUSE9VVCBXQVJSQU5USUVTIE9SIENPTkRJVElPTlMgT0YgQU5ZIEtJTkQsIGVpdGhlciBleHByZXNzIG9yIGltcGxpZWQuClNlZSB0aGUgTGljZW5zZSBmb3IgdGhlIHNwZWNpZmljIGxhbmd1YWdlIGdvdmVybmluZyBwZXJtaXNzaW9ucyBhbmQKbGltaXRhdGlvbnMgdW5kZXIgdGhlIExpY2Vuc2UuhUUAtwAAAC1JREFUOMtjVCtZ9p+BAsDEQCEYNYAKBrAgc252RxKlSb10OfVcwDiakIaDAQDXcQefpMw+jAAAAABJRU5ErkJggg==";
                        objImg.alt = "expand";
                     expand(details_id);
                  }
                  else
                  {
                     objImg.src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAAZiS0dEALQADQANam36RQAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAd0SU1FB9wDDQ0cLbeSRoIAAAL5dEVYdENvbW1lbnQATGljZW5zZWQgdG8gdGhlIEFwYWNoZSBTb2Z0d2FyZSBGb3VuZGF0aW9uIChBU0YpIHVuZGVyIG9uZSBvciBtb3JlCmNvbnRyaWJ1dG9yIGxpY2Vuc2UgYWdyZWVtZW50cy4gIFNlZSB0aGUgTk9USUNFIGZpbGUgZGlzdHJpYnV0ZWQgd2l0aAp0aGlzIHdvcmsgZm9yIGFkZGl0aW9uYWwgaW5mb3JtYXRpb24gcmVnYXJkaW5nIGNvcHlyaWdodCBvd25lcnNoaXAuClRoZSBBU0YgbGljZW5zZXMgdGhpcyBmaWxlIHRvIFlvdSB1bmRlciB0aGUgQXBhY2hlIExpY2Vuc2UsIFZlcnNpb24gMi4wCih0aGUgIkxpY2Vuc2UiKTsgeW91IG1heSBub3QgdXNlIHRoaXMgZmlsZSBleGNlcHQgaW4gY29tcGxpYW5jZSB3aXRoCnRoZSBMaWNlbnNlLiAgWW91IG1heSBvYnRhaW4gYSBjb3B5IG9mIHRoZSBMaWNlbnNlIGF0CgogICBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjAKClVubGVzcyByZXF1aXJlZCBieSBhcHBsaWNhYmxlIGxhdyBvciBhZ3JlZWQgdG8gaW4gd3JpdGluZywgc29mdHdhcmUKZGlzdHJpYnV0ZWQgdW5kZXIgdGhlIExpY2Vuc2UgaXMgZGlzdHJpYnV0ZWQgb24gYW4gIkFTIElTIiBCQVNJUywKV0lUSE9VVCBXQVJSQU5USUVTIE9SIENPTkRJVElPTlMgT0YgQU5ZIEtJTkQsIGVpdGhlciBleHByZXNzIG9yIGltcGxpZWQuClNlZSB0aGUgTGljZW5zZSBmb3IgdGhlIHNwZWNpZmljIGxhbmd1YWdlIGdvdmVybmluZyBwZXJtaXNzaW9ucyBhbmQKbGltaXRhdGlvbnMgdW5kZXIgdGhlIExpY2Vuc2UuhUUAtwAAADtJREFUOMtjVCtZ9p+BAsDEQCGgrQE3uyMZbnZHDmUvEAMYkaORkH9hQL10OY1cgC0W0G0c7rEwNL0AAJeCEpM4iWKGAAAAAElFTkSuQmCC";
                        objImg.alt = "collapse";
                     collapse(details_id);
                  }
                           }
            ]]></script>
			</head>
			<body>

				<xsl:call-template name="pageHeader" />

				<xsl:call-template name="summary" />
				<hr size="1" width="100%" align="center" />

				<xsl:call-template name="pagelist" />
				<hr size="1" width="100%" align="center" />

			</body>
		</html>
	</xsl:template>

	<xsl:template name="pageHeader">
		<h1><xsl:value-of select="$titleReport" /></h1>
		<table width="100%">
			<tr>
				<td align="left">日期: <xsl:value-of select="$dateReport" /></td>
				<td align="right">Made in China</td>
			</tr>
		</table>
		<hr size="1" />
	</xsl:template>

	<xsl:template name="summary">
		<h2>执行概述</h2>
		<table align="center" class="details" border="0" cellpadding="5" cellspacing="2" width="100%">
			<tr valign="top">
				<th>请求数量</th>
				<th>失败</th>
				<th>成功率</th>
				<th>平均响应时间</th>
				<th>最短时间</th>
				<th>最长时间</th>
				<th>RT(≤0.5s) </th>
				<th>RT(0.5~1s)</th>
				<th>RT(>1s)</th>
			</tr>
			<tr valign="top">
				<xsl:variable name="allCount" select="count(/testResults/*)" />
				<xsl:variable name="allFailureCount" select="count(/testResults/*[attribute::s='false'])" />
				<xsl:variable name="allSuccessCount" select="count(/testResults/*[attribute::s='true'])" />
				<xsl:variable name="allSuccessPercent" select="$allSuccessCount div $allCount" />
				<xsl:variable name="allTotalTime" select="sum(/testResults/*/@t)" />
				<xsl:variable name="scount" select="count(/testResults/*[@t > 500])" />
				<xsl:variable name="scount2" select="count(/testResults/*[@t > 1000])" />
				<xsl:variable name="scount3" select="count(/testResults/*[@t &lt;= 500])" />
				<xsl:variable name="scount1" select="$scount - $scount2" />
				<xsl:variable name="allAverageTime" select="$allTotalTime div $allCount" />
				<xsl:variable name="allMinTime">
					<xsl:call-template name="min">
						<xsl:with-param name="nodes" select="/testResults/*/@t" />
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="allMaxTime">
					<xsl:call-template name="max">
						<xsl:with-param name="nodes" select="/testResults/*/@t" />
					</xsl:call-template>
				</xsl:variable>

				<xsl:attribute name="class">
					<xsl:choose>
						<xsl:when test="$allFailureCount &gt; 0">Failure</xsl:when>
					</xsl:choose>
				</xsl:attribute>
				<td align="center">
					<xsl:value-of select="$allCount" />
				</td>
				<td align="center">
					<xsl:value-of select="$allFailureCount" />
				</td>
				<td align="center">
					<xsl:call-template name="display-percent">
						<xsl:with-param name="value" select="$allSuccessPercent" />
					</xsl:call-template>
				</td>
				<td align="center">
					<xsl:call-template name="display-time">
						<xsl:with-param name="value" select="$allAverageTime" />
					</xsl:call-template>
				</td>
				<td align="center">
					<xsl:call-template name="display-time">
						<xsl:with-param name="value" select="$allMinTime" />
					</xsl:call-template>
				</td>
				<td align="center">
					<xsl:call-template name="display-time">
						<xsl:with-param name="value" select="$allMaxTime" />
					</xsl:call-template>
				</td>
				<td align="center">
					<xsl:value-of  select="$scount3" />
				</td>
				<td align="center">
					<xsl:value-of  select="$scount1" />
				</td>
				<td align="center">
					<xsl:value-of  select="$scount2" />
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="pagelist">
		<h2>接口详情</h2>
		<table align="center" class="details" border="0" cellpadding="5" cellspacing="2" width="100%">
			<tr valign="top">
				<th>编号</th>
				<th align="left">描述</th>
				<th align="left">URL</th>
				<th>method</th>
				<th>结果</th>
				<th>响应时间</th>
				<th></th>
			</tr>
			<xsl:for-each select="/testResults/*[not(@lb = preceding::*/@lb)]">
				<xsl:variable name="label" select="@lb" />
				<xsl:variable name="tresult" select="@s" />
				<xsl:variable name="count" select="count(current()/@tn)" />
				<xsl:variable name="failureCount" select="count(../*[@lb = current()/@lb][attribute::s='false'])" />
				<xsl:variable name="successCount" select="count(../*[@lb = current()/@lb][attribute::s='true'])" />
				<xsl:variable name="successPercent" select="$successCount div $count" />
				<xsl:variable name="totalTime" select="sum(../*[@lb = current()/@lb]/@t)" />
				<xsl:variable name="averageTime" select="$totalTime div $count" />
				<xsl:variable name="minTime">
					<xsl:call-template name="min">
						<xsl:with-param name="nodes" select="../*[@lb = current()/@lb]/@t" />
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="maxTime">
					<xsl:call-template name="max">
						<xsl:with-param name="nodes" select="../*[@lb = current()/@lb]/@t" />
					</xsl:call-template>
				</xsl:variable>
				<tr valign="top">
					<xsl:attribute name="class">
						<xsl:choose>
							<xsl:when test="$failureCount &gt; 0">Failure</xsl:when>
						</xsl:choose>
					</xsl:attribute>
					<td align="center">
						<xsl:value-of select="position()" />
					</td>
					<td>
						<xsl:value-of select="$label" />
					</td>
					<td>
						<xsl:value-of select="java.net.URL"/>
					</td>
					<td align="center">
						<xsl:value-of select="method"/>
					</td>
					<td align="center">
						<xsl:if test="$tresult = 'true'">
							<xsl:text>pass</xsl:text>
						</xsl:if>
						<xsl:if test="$tresult = 'false'">
							<xsl:text>Fail</xsl:text>
						</xsl:if>
					</td>
					<td align="center">
						<xsl:call-template name="display-time">
							<xsl:with-param name="value" select="@t" />
						</xsl:call-template>
					</td>
					<td align="center">
						<a class="expand_link" href="">
							<xsl:attribute name="id"><xsl:text/>page_details_<xsl:value-of select="position()" />_a</xsl:attribute>
							<xsl:attribute name="href"><xsl:text/>javascript:change('page_details_<xsl:value-of select="position()" />')</xsl:attribute>
							<img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAAZiS0dEALQADQANam36RQAAAAlwSFlzAAALEwAACxMBAJqcGAAAAAd0SU1FB9wDDQ0cLbeSRoIAAAL5dEVYdENvbW1lbnQATGljZW5zZWQgdG8gdGhlIEFwYWNoZSBTb2Z0d2FyZSBGb3VuZGF0aW9uIChBU0YpIHVuZGVyIG9uZSBvciBtb3JlCmNvbnRyaWJ1dG9yIGxpY2Vuc2UgYWdyZWVtZW50cy4gIFNlZSB0aGUgTk9USUNFIGZpbGUgZGlzdHJpYnV0ZWQgd2l0aAp0aGlzIHdvcmsgZm9yIGFkZGl0aW9uYWwgaW5mb3JtYXRpb24gcmVnYXJkaW5nIGNvcHlyaWdodCBvd25lcnNoaXAuClRoZSBBU0YgbGljZW5zZXMgdGhpcyBmaWxlIHRvIFlvdSB1bmRlciB0aGUgQXBhY2hlIExpY2Vuc2UsIFZlcnNpb24gMi4wCih0aGUgIkxpY2Vuc2UiKTsgeW91IG1heSBub3QgdXNlIHRoaXMgZmlsZSBleGNlcHQgaW4gY29tcGxpYW5jZSB3aXRoCnRoZSBMaWNlbnNlLiAgWW91IG1heSBvYnRhaW4gYSBjb3B5IG9mIHRoZSBMaWNlbnNlIGF0CgogICBodHRwOi8vd3d3LmFwYWNoZS5vcmcvbGljZW5zZXMvTElDRU5TRS0yLjAKClVubGVzcyByZXF1aXJlZCBieSBhcHBsaWNhYmxlIGxhdyBvciBhZ3JlZWQgdG8gaW4gd3JpdGluZywgc29mdHdhcmUKZGlzdHJpYnV0ZWQgdW5kZXIgdGhlIExpY2Vuc2UgaXMgZGlzdHJpYnV0ZWQgb24gYW4gIkFTIElTIiBCQVNJUywKV0lUSE9VVCBXQVJSQU5USUVTIE9SIENPTkRJVElPTlMgT0YgQU5ZIEtJTkQsIGVpdGhlciBleHByZXNzIG9yIGltcGxpZWQuClNlZSB0aGUgTGljZW5zZSBmb3IgdGhlIHNwZWNpZmljIGxhbmd1YWdlIGdvdmVybmluZyBwZXJtaXNzaW9ucyBhbmQKbGltaXRhdGlvbnMgdW5kZXIgdGhlIExpY2Vuc2UuhUUAtwAAADtJREFUOMtjVCtZ9p+BAsDEQCGgrQE3uyMZbnZHDmUvEAMYkaORkH9hQL10OY1cgC0W0G0c7rEwNL0AAJeCEpM4iWKGAAAAAElFTkSuQmCC" alt="collapse"><xsl:attribute name="id"><xsl:text/>page_details_<xsl:value-of select="position()" />_image</xsl:attribute>
							</img>
						</a>
					</td>
				</tr>

				<tr class="page_details">
					<xsl:attribute name="id"><xsl:text/>page_details_<xsl:value-of select="position()" /></xsl:attribute>
					<td colspan="8" bgcolor="#FF0000">
						<div align="center">
							<table bordercolor="#000000" bgcolor="#2674A6" border="0"  cellpadding="1" cellspacing="1" width="95%">
								<xsl:attribute name="id"><xsl:text/><xsl:value-of select="@lb" />_detail_<xsl:value-of select="position()" /></xsl:attribute>
								<tr valign="top"><th colspan="2"><xsl:value-of select="@lb" /><xsl:text> # </xsl:text><xsl:value-of select="@tn"/></th></tr>
								<tr><td class="key">Request Data</td><td><xsl:value-of select="queryString"/></td></tr>
								<tr style="white-space: pre-wrap;"><td class="key">Request Headers</td><td><xsl:value-of select="requestHeader"/></td></tr>
								<tr style="white-space: pre-wrap;"><td class="key">Response Headers</td><td><xsl:value-of select="responseHeader"/></td></tr>
								<tr><td class="key">Response Data</td><td><xsl:value-of select="substring(responseData,0,200)"/></td></tr>
								<tr><td class="key">Response Code</td><td><xsl:value-of select="@rc"/></td></tr>
								<tr><td class="key">Response Message</td><td><xsl:value-of select="@rm"/></td></tr>
								<tr><td class="key">Failure Message</td><td><xsl:value-of select="assertionResult/failureMessage"/></td></tr>
								<tr><td class="key">Cookies</td><td><xsl:value-of select="cookies"/></td></tr>


							</table>
						</div>
					</td>
				</tr>

			</xsl:for-each>
		</table>
	</xsl:template>

	<xsl:template name="min">
		<xsl:param name="nodes" select="/.." />
		<xsl:choose>
			<xsl:when test="not($nodes)">NaN</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="$nodes">
					<xsl:sort data-type="number" />
					<xsl:if test="position() = 1">
						<xsl:value-of select="number(.)" />
					</xsl:if>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="max">
		<xsl:param name="nodes" select="/.." />
		<xsl:choose>
			<xsl:when test="not($nodes)">NaN</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="$nodes">
					<xsl:sort data-type="number" order="descending" />
					<xsl:if test="position() = 1">
						<xsl:value-of select="number(.)" />
					</xsl:if>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="display-percent">
		<xsl:param name="value" />
		<xsl:value-of select="format-number($value,'0.00%')" />
	</xsl:template>

	<xsl:template name="display-time">
		<xsl:param name="value" />
		<xsl:value-of select="format-number($value,'0 ms')" />
	</xsl:template>

</xsl:stylesheet>