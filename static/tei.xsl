<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cb="http://www.cbeta.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs cb">
    <!--xpath-default-namespace="http://www.tei-c.org/ns/1.0"-->
    <xsl:output method="html" encoding="utf-8" doctype-system="about:legacy-compat" indent="yes"/>

    <!--当前经集的名字, 形如: T20n1167 -->
    <xsl:variable name="current_sutra" select="/TEI[1]/@xml:id"/>

    <!--当前文件的卷数, 形如: 001; 目前只能靠猜了-->
    <!--xsl:variable name="juan" select="/TEI[1]/text/body//cb:juan[1]/@n|/TEI/text/body//milestone[@unit='juan']/@n|/TEI/text/body//cb:mulu[@type='卷']/@n"/-->
    <xsl:variable name="juan" select="/TEI/text/body//milestone[@unit='juan']/@n"/>

    <!--是否微软浏览器-->
    <xsl:variable name="MSIE" select="system-property('xsl:vendor')='Microsoft'"/>
    <xsl:variable name="firefox" select="system-property('xsl:vendor')='Transformiix'"/>

    <!--xml所在目录前缀, 形如: /xml/T01/-->
    <xsl:variable name="dir" select="concat('/xml/', substring-before($current_sutra, 'n'), '/')"/>

    <!--计算上一页-->
    <xsl:variable name="prev_filepath">
    <xsl:variable name="prevvol">
      <xsl:value-of select="concat($dir, $current_sutra, '_')"/>
      <xsl:number format="001" value="$juan - 1"/>
      <xsl:text>.xml</xsl:text>
    </xsl:variable>
    <xsl:if test="$MSIE or document($prevvol)">
        <xsl:value-of select="$prevvol"/>
    </xsl:if>
    </xsl:variable>

    <!--计算下一页-->
    <xsl:variable name="next_filepath">
        <xsl:variable name="nextvol">
          <xsl:value-of select="concat($dir, $current_sutra, '_')"/>
          <xsl:number format="001" value="$juan + 1"/>
          <xsl:text>.xml</xsl:text>
        </xsl:variable>
        <xsl:variable name="nextsutra">
          <xsl:value-of select="concat($dir, substring-before($current_sutra, 'n'), 'n')"/>
          <xsl:number format="0001" value="substring-after($current_sutra, 'n') + 1"/>
          <xsl:text>_001.xml</xsl:text>
        </xsl:variable>
        <xsl:variable name="nextzang">
          <xsl:text>/xml/</xsl:text>
          <xsl:value-of select="substring(substring-before($current_sutra, 'n'), 1, 1)"/>
          <xsl:number format="01" value="substring(substring-before($current_sutra, 'n'), 2) + 1"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="substring(substring-before($current_sutra, 'n'), 1, 1)"/>
          <xsl:number format="01" value="substring(substring-before($current_sutra, 'n'), 2) + 1"/>
          <xsl:text>n</xsl:text>
          <xsl:number format="0001" value="substring-after($current_sutra, 'n') + 1"/>
          <xsl:text>_001.xml</xsl:text>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$MSIE or document($nextvol)">
              <xsl:value-of select="$nextvol"/>
          </xsl:when>
          <xsl:when test="$MSIE or document($nextsutra)">
              <xsl:value-of select="$nextsutra"/>
          </xsl:when>
          <xsl:when test="$MSIE or document($nextzang)">
              <xsl:value-of select="$nextzang"/>
          </xsl:when>
          <xsl:otherwise>
              <xsl:text>#</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:template match="/">
        <html>
          <xsl:attribute name="lang">
            <xsl:choose>
            <xsl:when test="/TEI/@xml:lang">
                <xsl:value-of select="/TEI/@xml:lang"/>
            </xsl:when>
            <xsl:otherwise>
            <!--xsl:text>zh_TW</xsl:text-->
            <xsl:text>lzh-Hant</xsl:text>
            </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no"/>
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
        <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css"/>
        <link rel="stylesheet" type="text/css" href="/static/tei.css"/>
        <title>
            <xsl:value-of select="concat($current_sutra, ' ', substring-after(substring-after(/TEI/teiHeader/fileDesc/titleStmt/title, 'No. '), ' '))"/>
        </title>

        <script src="https://cdn.bootcss.com/jquery/2.1.1/jquery.min.js"></script>
        <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <!--[if lt IE9]> 
        <script src="http://cdn.staticfile.org/html5shiv/r29/html5.min.js"></script>
        <![endif]-->
        <script src="/static/my.js"></script>

        </head>

        <!--firefox浏览器特有的菜单-->
        <body class="contenttext" contextmenu="supermenu">
        <a href="#">&#128266;</a>

        <menu id="supermenu" type="context">
            <menuitem label="报告错误" onclick="alert('step1')"/>
            <menuitem label="菜单测试1" onclick="imageRotation('rotate-90')" icon="img/arrow-return-090.png"/>
            <menuitem label="菜单测试2" icon="img/arrow-return-180.png"/>
            <menuitem label="菜单测试3" icon="img/arrow-stop-180.png"/>
            <menuitem label="菜单测试4" icon="img/arrow-stop-270.png"/>
        </menu>

            <!--ul class="pagination pagination-sm"-->
        <nav class="navbar navbar-default navbar-fixed-top" role="navigation">
            <!--div class="navbar-header">  
                <a class="navbar-brand">&#9776;</a>  
            </div--> 
            <div class="container">
            <ul class="nav navbar-nav">
            <li>
        <a class="navbar-brand">
          <xsl:attribute name="href">
              <xsl:value-of select="$prev_filepath"/>
          </xsl:attribute>
          上一卷
        </a>
            </li>
            <li>
                <a class="navbar-brand" href="/mulu">返回目录</a>
            </li>
            <li>
        <a class="navbar-brand">
          <xsl:attribute name="href">
              <xsl:value-of select="$next_filepath"/>
          </xsl:attribute>
          下一卷
        </a>
            </li>
        </ul>
      <!--form class="collspae navbar-collspae navbar-form navbar-left" role="search">
         <div class="form-group">
            <input type="search" class="form-control" placeholder="Search"/>
         </div>
         <button type="submit" class="btn btn-default">直达</button>
      </form-->    
  </div>
        </nav>

    <!--侧边栏目录 max(level)=28-->
        <!--aside style="height:100%;width:20%; margin-bottom:-3000px; padding-bottom:3000px; background:#cad5eb; float:left;"-->
        <nav>
            <ul class="toc">

            <!--生成目录-->
                <!--xsl:with-param name="pos" select="document($prev_filepath)//cb:mulu|//cb:mulu|document($next_filepath)//cb:mulu"/-->
            <!--xsl:call-template name="make_catalog">
                <xsl:with-param name="pos" select="//cb:mulu"/>
            </xsl:call-template-->
            </ul>
        </nav>

            <br/>

        <!--div class="content" style="writing-mode:vertical-rl;" 竖排-->
        <!--补上南传等经典的标题以及作者-->
        <xsl:if test="not(//cb:jhead)">
            <h1 class="title">
                <xsl:value-of select="concat($current_sutra, ' ', substring-after(substring-after(/TEI/teiHeader/fileDesc/titleStmt/title, 'No. '), ' '))"/>
            </h1>
            <br/>
            <div class="byline">
                <xsl:value-of select="/TEI/teiHeader/fileDesc/titleStmt/author"/>
            </div>
            <br/>
            <br/>
        </xsl:if>

        <!--正文内容-->
        <div class="contentx">
            <xsl:apply-templates/>
        </div>

        <!--底栏目录-->
        <nav class="navbar-sm navbar-default" role="navigation">
            <ul class="nav navbar-nav">
             <li>
        <a>
          <xsl:attribute name="href">
              <xsl:value-of select="$prev_filepath"/>
          </xsl:attribute>
          上一卷
        </a>
             </li>
             <li>
                <a href="/mulu">返回目录</a>
             </li>
             <li>
        <a>
          <xsl:attribute name="href">
              <xsl:value-of select="$next_filepath"/>
          </xsl:attribute>
          下一卷
        </a>
             </li>
             </ul>
        </nav>

        </body>
        </html>
    </xsl:template>

    <!--处理整体结构: TEI\teiHeader\app-->

    <!--xsl:template match="TEI">
        <xsl:apply-templates/>
    </xsl:template-->

    <xsl:template match="teiHeader"/>

    <!--不显示back部分-->
    <xsl:template match="text/back">
    </xsl:template>

    <!--不能切换段落, 否则显示不正常-->
    <xsl:template match="pb">
        <span>
          <xsl:attribute name="id">
            <xsl:value-of select="@xml:id"/>
          </xsl:attribute>
        </span>
    </xsl:template>

    <!--不在正文显示目录-->
    <xsl:template match="cb:mulu">
        <a class="mulu">
           <xsl:attribute name="id">
               <xsl:value-of select="generate-id()"/>
           </xsl:attribute>
        </a>
    </xsl:template>


    <!--处理表格table-->
    <!--TODO: table rend="border:0"-->
    <xsl:template match="table">
        <table class="table table-bordered">
            <xsl:apply-templates/>
        </table>
    </xsl:template>
    <!--处理表格row-->
    <xsl:template match="row">
        <tr>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>
    <!--处理表格cell-->
    <xsl:template match="cell">
        <td>
            <xsl:if test="@cols">
            <xsl:attribute name="colspan">
                <xsl:value-of select="@cols"/>
            </xsl:attribute>
            </xsl:if>
            <xsl:if test="@rows">
            <xsl:attribute name="rowspan">
                <xsl:value-of select="@rows"/>
            </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </td>
    </xsl:template>

    <!--处理所有的颂-->
    <!-- rend="margin-left:1em;text-indent:-1em" -->
    <xsl:template match="lg">
        <p class="lg">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@rend">
                    <xsl:attribute name="style">
                    <xsl:value-of select="concat('text-indent:', substring-before(substring-after(@rend,'text-indent:'), 'em'), 'em;')"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!--偈中重复的换行只显示一个换行-->
    <xsl:template match="lg/lb">
        <xsl:if test="local-name(preceding-sibling::*[1])!='lb'">
            <br/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="lb">
        <span class="lb">
         <xsl:attribute name="id">
             <xsl:value-of select="concat($current_sutra, '_p', @n)" />
         </xsl:attribute>
        </span>
    </xsl:template>

    <xsl:template match="lg/l">
       <span>
         <xsl:attribute name="class">
           <xsl:choose>
             <xsl:when test="@rend='Alignr'">
               <xsl:text>right</xsl:text>
             </xsl:when>
             <xsl:when test="@rend='Alignc'">
               <xsl:text>center</xsl:text>
             </xsl:when>
             <xsl:when test="starts-with(@rend,'indent(')">
               <xsl:text>indent</xsl:text>
               <xsl:value-of select="concat(substring-before(substring-after(@rend,'('),')'),'em')" />
             </xsl:when>
             <xsl:when test="@rend='indent'">
               <xsl:text>indent1</xsl:text>
             </xsl:when>
             <xsl:otherwise>
               <xsl:text>l</xsl:text>
             </xsl:otherwise>
           </xsl:choose>
         </xsl:attribute>
         <xsl:apply-templates/>
       </span>&#12288;<!--IDEOGRAPHIC SPACE-->
    </xsl:template>

    <!--清除文档中无用空格-->
    <xsl:template match="text()|@*">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

    <!--处理图片-->
    <xsl:template match="figure">
        <figure>
          <xsl:apply-templates/>
          <figcaption>
            <xsl:value-of select="head"/>
          </figcaption>
        </figure>
    </xsl:template>

    <xsl:template match="graphic">
      <img>
        <xsl:attribute name="src">
            <xsl:text>/static</xsl:text>
            <xsl:value-of select="substring(@url, 3)"/>
        </xsl:attribute>
      </img>
    </xsl:template>

    <!--处理段落-->
    <!--xsl:template match="p[contains(@rend, 'inline')]">
        <span><xsl:apply-templates/></span>
    </xsl:template-->

    <xsl:template match="p[contains(@cb:type, 'head')]">
        <xsl:choose>
            <xsl:when test="@cb:type='head1'">
                <h2><xsl:apply-templates/></h2>
            </xsl:when>
            <xsl:when test="@cb:type='head2'">
                <h3><xsl:apply-templates/></h3>
            </xsl:when>
            <xsl:when test="@cb:type='head3'">
                <h4><xsl:apply-templates/></h4>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!--xsl:template match="p[@cb:type='dharani']">
        <p class="dharani">
          <xsl:apply-templates/>
        </p>
    </xsl:template-->

    <xsl:template match="p[@cb:type='pre']">
        <pre>
          <!--xsl:apply-templates/-->
          <xsl:value-of select="."/>
        </pre>
    </xsl:template>

    <xsl:template match="p">
        <p>
          <xsl:if test="@xml:id">
              <xsl:attribute name="id">      
                <xsl:value-of select="@xml:id"/>
              </xsl:attribute>
          </xsl:if>
          <xsl:if test="@cb:type='dharani'">
            <xsl:attribute name="class">
                <xsl:text>dharani</xsl:text>
            </xsl:attribute>
            <a href="#">&#128362;</a>
          </xsl:if>
          <!--xsl:if test="@cb:type='pre'"-->
          <!--xsl:if test="@cb:type='head1'"-->
          <!--xsl:if test="@cb:type='head2'"-->
          <!--xsl:if test="@cb:type='head3'"-->
          <!--xsl:if test="contains(@rend, 'inline')">
            <xsl:attribute name="style">
                <xsl:text>display:inline</xsl:text>
            </xsl:attribute>
          </xsl:if-->
          <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!--处理词典-->
    <xsl:template match="entry"><dl><xsl:apply-templates/></dl></xsl:template>
    <xsl:template match="form"><dt><xsl:apply-templates/></dt></xsl:template>
    <xsl:template match="cb:def"><dd><xsl:apply-templates/></dd></xsl:template>

    <!--处理note-->
    <xsl:template match="note[@place='inline']|note[@type='inline']">
        <span style="color:#A9A9A9">(<xsl:apply-templates/>)</span>
    </xsl:template>

    <xsl:template match="space">
      <span style="display:inline-block">
        <xsl:if test="@quantity">
          <xsl:variable name="unit">
            <xsl:choose>
              <xsl:when test="@unit='chars'">
                <xsl:text>em</xsl:text>
              </xsl:when>
              <xsl:when test="@unit">
                <xsl:value-of select="@unit"/>
              </xsl:when>
              <xsl:otherwise>em</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:attribute name="width">
            <xsl:value-of select="@quantity"/>
            <xsl:value-of select="$unit"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:text> </xsl:text>
      </span>
    </xsl:template>


  <!--xsl:template match="juan">
          <xsl:apply-templates/>
  </xsl:template-->
    <!--连续的cb:tt标签在最后一次性显示-->
    <!--xsl:template name="tt">
        <xsl:param name="ntext"/> 
        <xsl:if test="local-name(following-sibling::*[1])!='tt'">
            <xsl:value-of select="$ntext"/>
        </xsl:if>
        <xsl:if test="local-name(following-sibling::*[1])='tt'">
            <xsl:call-template name="tt" select="preceding-sibling::*[1]">
                <xsl:with-param name="ntext">
                    <xsl:value-of select="cb:t[@xml:lang!='zh']"/>
                    <xsl:value-of select="$ntext"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template-->

    <xsl:template match="cb:tt">
        <xsl:apply-templates select="cb:t[@xml:lang='zh']"/>
        <xsl:if test="local-name(following-sibling::*[1])!='tt'">
            <xsl:apply-templates select="cb:t[@xml:lang!='zh']"/>
            <!--xsl:value-of select="local-name(following-sibling::*[1])"/>
            <xsl:value-of select="local-name(preceding-sibling::*[1])"/>
            <xsl:call-template name="tt" select="preceding-sibling::*[1]">
                <xsl:with-param name="ntext" select="cb:t[@xml:lang!='zh']"/>
            </xsl:call-template-->
        </xsl:if>
    </xsl:template>
    <!--sa,sa-x-rj,sa-Sidd多语言对照 -->
    <xsl:template match="cb:t">
        <xsl:if test="@xml:lang='zh'">
            <xsl:apply-templates/>
        </xsl:if>
        <xsl:if test="@xml:lang!='zh'">
            <span style="color:#A9A9A9"><xsl:apply-templates/></span>
        </xsl:if>
    </xsl:template>

    <!--处理异体字-->
    <xsl:key name="char_id" match="char" use="@xml:id"/>
    <xsl:template match="g">
        <xsl:variable name="Ref" select="substring(@ref, 2)"/>
        <xsl:variable name="char" select="key('char_id', $Ref)"/>
    <!--localName>normalized form</localName>
    <localName>Character in the Siddham font</localName>   xml:id="SD-E2F6"
    <localName>big5</localName>                            xml:id="SD-E2F6"
    <localName>composition</localName> 组字式              xml:id="CB00178"
    <localName>rjchar</localName>                          xml:id="RJ-CBD3"
    <localName>Romanized form in CBETA transcription</localName>
    <localName>Romanized form in Unicode transcription</localName>
    <mapping type="normal_unicode">U+2A31C</mapping-->
    <xsl:choose>
        <xsl:when test="starts-with($Ref, 'SD')">
        <span class="gaiji_sd">
            <ruby>
            <!--xsl:value-of select="."/-->
                <img>
                <xsl:attribute name="src">
                    <xsl:text>/static/sd-gif/</xsl:text>
                    <xsl:value-of select="substring($Ref, 4, 2)"/>
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="$Ref"/>
                    <xsl:text>.gif</xsl:text>
                </xsl:attribute>
                </img>
            <!--装cbeta字库用这句, 没装用上面的图片-->
            <!--xsl:value-of select="/TEI//char[@xml:id=$Ref]/charProp[localName='Character in the Siddham font']/value"/-->
                <rt>
                    <xsl:value-of select="key('char_id', $Ref)/charProp[localName='Romanized form in Unicode transcription']/value"/>
                </rt>
            </ruby>
        </span> 
        </xsl:when>

        <!--蘭札字-->
        <xsl:when test="starts-with($Ref, 'RJ')">
        <span class="gaiji_rj">
            <ruby>
                <img>
                <xsl:attribute name="src">
                    <xsl:text>/static/rj-gif/</xsl:text>
                    <xsl:value-of select="substring($Ref, 4, 2)"/>
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="$Ref"/>
                    <xsl:text>.gif</xsl:text>
                </xsl:attribute>
                </img>
            <!-- 安装了cbeta的蘭扎字库，使用这句，不推荐-->
            <!--xsl:value-of select="/TEI//char[@xml:id=$Ref]/charProp[localName='rjchar']/value"/-->
                <rt>
                    <xsl:value-of select="key('char_id', $Ref)/charProp[localName='Romanized form in Unicode transcription']/value"/>
                <!--xsl:choose>
                    <xsl:when test="/TEI//char[@xml:id=$Ref]/charProp[localName='Romanized form in Unicode transcription']/value"-->
                    <!--/xsl:when>
                    <xsl:when test="/TEI//char[@xml:id=$Ref]/charProp[localName='Romanized form in CBETA transcription']/value">
                        (<xsl:value-of select="/TEI//char[@xml:id=$Ref]/charProp[localName='Romanized form in CBETA transcription']/value"/>)
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose-->
                </rt>
            </ruby>
        </span> 
        </xsl:when>

        <!--組字式-->
        <xsl:when test="starts-with($Ref, 'CB')">
        <span class="gaiji_cb">
            <xsl:variable name="nor" select="$char/charProp[localName='normalized form']/value"/>
            <xsl:choose>
            <xsl:when test="$nor">
                <xsl:value-of select="$nor"/>
            </xsl:when>
            <xsl:when test="$char/mapping[@type='unicode']">
                <xsl:value-of select="."/>
            </xsl:when>
            <!--使用xml实体输出显示，不能用于搜索, 形如: &#x25F9D;-->
            <xsl:when test="$char/mapping[@type='normal_unicode']">
                <xsl:value-of disable-output-escaping='yes' select="concat('&amp;#x', substring($char/mapping[@type='normal_unicode'], 3), ';')"/>
            </xsl:when>
            <xsl:when test="$char/charProp[localName='composition']/value">
                <xsl:value-of select="$char/charProp[localName='composition']/value"/>
            </xsl:when>
            </xsl:choose>
        </span> 
        </xsl:when>
      </xsl:choose>
    </xsl:template>

    <!--处理teiHeader-->
    <xsl:template match="titleStmt/title">
      <xsl:if test="preceding-sibling::title">
        <br/>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:template>

    <!--head 小节的目录。上级节点是div类节点则不显示? -->
    <xsl:template match="head">
      <xsl:variable name="parent" select="local-name(..)"/>
      <!--xsl:if test="not(starts-with($parent,'div'))">
        <xsl:apply-templates/>
      </xsl:if-->
      <h2>
        <xsl:apply-templates/>
      </h2>
    </xsl:template>

  <!--xsl:template match="title">
      <h1 class="title"><xsl:value-of select="."/></h1>
    <br/>
  </xsl:template-->

    <!--标题-->
    <xsl:template match="cb:jhead">
        <h1 class="title">
            <xsl:apply-templates/>
        </h1>
        <!--br/-->
    </xsl:template>

    <!--最后一个作者译者cb:type="author"之后空出两行然后开始正文-->
    <xsl:template match="byline">
        <div class="byline">
            <xsl:apply-templates/>
        </div>
        <xsl:if test="../byline[last()]=.">
         <br/>
         <br/>
        </xsl:if>
    </xsl:template>
    <!--列表中的作者译者不另外换行,应该清洗掉这种标志 XXX-->
    <xsl:template match="list//byline|list//cb:jl_byline">
        <span class="byline">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
   <!--处理列表-->
   <xsl:template match="list"><ul><xsl:apply-templates/></ul></xsl:template>
   <xsl:template match="list/item"><li><xsl:apply-templates/></li></xsl:template>

    <!--处理空缺 unclear@reason-->
    <xsl:template match="unclear">
        <span class="unclear">
            <xsl:text>&#9610;</xsl:text>
        </span>
    </xsl:template>

    <!--使用popover显示注释, 链接三个标签，可能有些不对-->
    <!--跨文件注释？note type="cf1">K19n0663_p0486b18</note-->
    <xsl:template match="note[starts-with(@type, 'cf')]">
        (修訂依據:<xsl:apply-templates/>)
    </xsl:template>
    <!--xsl:template match="reg">
    </xsl:template-->

    <xsl:template match="orig">
        <xsl:apply-templates/>
        <xsl:text>&#8658;</xsl:text>
    </xsl:template>

    <xsl:template match="lem|corr">
        <xsl:apply-templates/>
        <xsl:if test="@wit">
            <xsl:call-template name="tokenize">
                <xsl:with-param name="text" select="@wit"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:text>&#8656;</xsl:text>
    </xsl:template>

    <xsl:template match="rdg|sic">
        <xsl:apply-templates/>
        <xsl:if test="@wit">
            <xsl:call-template name="tokenize">
                <xsl:with-param name="text" select="@wit"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

      <!--比较危险的用法,可能报错: 给替换的部分着红色-->

    <xsl:key name="tt_from" match="cb:tt" use="@from"/>
    <xsl:key name="app_from" match="app" use="@from"/>
    <xsl:key name="choice_from" match="choice" use="@cb:from"/>
    <xsl:key name="note_target" match="note" use="@target"/>
    <xsl:key name="note_n" match="note" use="@n"/>
    <xsl:key name="witness_id" match="witness" use="@xml:id"/>

    <xsl:template match="anchor">
        <xsl:variable name="Ref" select="concat('#', @xml:id)"/>
        <xsl:if test="not($firefox) and starts-with(@xml:id, 'beg')">
            <xsl:text disable-output-escaping="yes">&lt;span style="color:red"&gt;</xsl:text>
        </xsl:if>
        <xsl:if test="not($firefox) and starts-with(@xml:id, 'end')">
            <xsl:text disable-output-escaping="yes">&lt;/span&gt;</xsl:text>
        </xsl:if>
        <sup>
        <a data-toggle="popover" data-placement="auto" data-container="body" data-trigger="hover focus">
        <xsl:if test="@xml:id">
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="@type='cb-app' and key('app_from', $Ref)">
            <!--xsl:when test="key('app_from', $Ref)"-->
                <xsl:attribute name="title">
                    <xsl:text>CBETA修訂註解</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="data-content">
                    <xsl:apply-templates select="key('app_from', $Ref)"/>
                </xsl:attribute>
                <xsl:value-of select="concat('[c', substring(@xml:id, 5), ']')"/>
            </xsl:when>
            <xsl:when test="@type='cb-app' and key('choice_from', $Ref)/sic">
                <xsl:attribute name="title">
                    <xsl:text>勘誤</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="data-content">
                    <!--xsl:apply-templates select="key('choice_from', $Ref)"/-->
                    原文為: <xsl:apply-templates select="key('choice_from', $Ref)/sic"/>
                </xsl:attribute>
                <xsl:value-of select="concat('[c', substring(@xml:id, 5), ']')"/>
            </xsl:when>
            <xsl:when test="@type='cb-app' and key('choice_from', $Ref)/reg">
                <xsl:attribute name="title">
                    <xsl:apply-templates select="key('choice_from', $Ref)/reg/@type"/>  <!--通用詞-->
                </xsl:attribute>
                <xsl:attribute name="data-content">
                    <xsl:apply-templates select="key('choice_from', $Ref)"/>
                </xsl:attribute>
                <xsl:value-of select="concat('[c', substring(@xml:id, 5), ']')"/>
            </xsl:when>
            <xsl:when test="@type='star' and key('app_from', $Ref)">
                <xsl:attribute name="title">
                    <xsl:text>註解</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="data-content">
                    <xsl:apply-templates select="key('app_from', $Ref)"/>,
                    <!--xsl:variable name="tmp" select="substring(key('app_from', $Ref)/@corresp, 2)"/>
                    <xsl:apply-templates select="key('note_n', $tmp)"/-->
                </xsl:attribute>
                <xsl:text>[*]</xsl:text>
            </xsl:when>
            <xsl:when test="key('note_target', $Ref)">
                <xsl:attribute name="title">
                    <xsl:text>註釋</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="data-content">
                    <xsl:apply-templates select="key('note_target', $Ref)"/>
                </xsl:attribute>
                <xsl:value-of select="concat('[', substring(@n, 6), ']')"/>
            </xsl:when>
            <xsl:when test="@type='circle'">
            </xsl:when>
        </xsl:choose>
        </a>
        </sup>
    </xsl:template>


    <!--处理div 折叠式注释 TODO-->
    <!--xsl:template match="cb:div[@type='orig']"-->
    <xsl:template match="cb:div[@type='commentary']">
      <!--div class="commentary" id="collapseTwo" class="panel-collapse collapse"-->
        <div class="commentary panel-collapse">
            <a data-toggle="collapse" data-parent="#accordion" href="#{generate-id()}">點擊閱讀/關閉註疏：</a>
            <div id="{generate-id()}" class="panel-collapse collapse">
              <div class="panel-body">
                <xsl:apply-templates/>
              </div>
            </div>
        </div>
        <br/>
    </xsl:template>

    <!--生成导航目录 max(cb:mulu@level)=28, XXX: 不能显示cb:mulu中的异体字:K34n1257_007.xml-->
    <xsl:template name="make_catalog">
        <xsl:param name="pos"/> 
        <xsl:for-each select="$pos">
        <xsl:choose>
            <xsl:when test="@level=1">
                <li class="toc"><a>
                    <xsl:attribute name="href">
                        <xsl:text>#</xsl:text>
                        <xsl:value-of select="following::*[@xml:id][1]/@xml:id"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </a></li>
            </xsl:when>
            <xsl:when test="@level=2">
                <ul><li><a>
                    <xsl:attribute name="href">
                    <xsl:text>#</xsl:text>
                        <xsl:value-of select="following::*[@xml:id][1]/@xml:id"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </a></li></ul>
            </xsl:when>
            <xsl:when test="@level=3">
                <ul><ul><li><a>
                    <xsl:attribute name="href">
                    <xsl:text>#</xsl:text>
                        <xsl:value-of select="following::*[@xml:id][1]/@xml:id"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </a></li></ul></ul>
            </xsl:when>
            <xsl:when test="@level=4">
                <ul><ul><ul><li><a>
          <xsl:attribute name="href">
              <xsl:text>#</xsl:text>
              <xsl:value-of select="following::*[@xml:id][1]/@xml:id"/>
          </xsl:attribute>
                    <!--xsl:apply-templates select="."/-->
                    <!--xsl:copy-of select="."/-->
                    <xsl:value-of select="."/>
          </a></li></ul></ul></ul>
            </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:template>

    <!--cb:yin><cb:zi>得浪</cb:zi><cb:sg>二合</cb:sg></cb:yin-->
    <xsl:template match="cb:sg">
        (<xsl:apply-templates/>)
    </xsl:template>

    <!--公式强调角标-->
    <xsl:template match="hi">
        <span>
        <xsl:if test="@rend">
        <xsl:attribute name="style">
            <xsl:value-of select="@rend"/>
        </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!--string-split函数: 空格分割后取值witness@id-->
    <xsl:template match="text/text()" name="tokenize">
        <xsl:param name="text" select="."/>
        <xsl:param name="separator" select="' '"/>
        <xsl:choose>
            <xsl:when test="not(contains($text, $separator))">
                <xsl:value-of select="key('witness_id', substring(normalize-space($text), 2))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="key('witness_id', substring(normalize-space(substring-before($text, $separator)), 2))"/>
                <xsl:call-template name="tokenize">
                    <xsl:with-param name="text" select="substring-after($text, $separator)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--计数循环-->
    <xsl:template name="loop">
        <xsl:param name="Count"/>
        <xsl:if test="$Count&lt;1">
            <xsl:value-of select="'finish'"/>
        </xsl:if>
        <xsl:if test="$Count&gt;=1">
            <xsl:value-of select="$Count"/>
            <xsl:call-template name="loop">
                <xsl:with-param name="Count"><xsl:value-of select="number($Count)-1"/></xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
