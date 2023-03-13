<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<meta name="Cargo" content=""/>
		<meta name="Assunto" content=""/>
		<meta name="Categoria" content=""/>
		<meta name="Palavras-chave" content=""/>
		<meta name="Descrição" content=""/>
		<meta name="Autor" content="."/>
		<meta name="Gerente" content=""/>
		<meta name="Empresa" content="simples"/>

		<title>Atendimento</title>
		<script src="atendimento_arquivos/frameset.js" type="text/jscript" language="jscript"></script>
		<script type="text/jscript" language="jscript" >

function FileEntry (pageIndex, pageID, pageName, priImage, secImage) 
{
	this.PageIndex = pageIndex;
	this.PageID	  = pageID;
	this.PageName = pageName;
	this.PriImage = priImage;
	this.SecImage = secImage;
}

var viewMgr = null;

var g_FileList = new  Array(
 new FileEntry (2, 4, "Atendimento", "vml_2.htm", "jpg_2.htm")

);

var g_CurPageIndex = 0;
var g_ZoomLoaded = false;
var g_WidgetsLoaded = false;
var g_FileProtocol = "file://";

var g_HLMenuEntry = "menuEntry";
var g_HLMenuEntryDiv = "menuEntryDiv";

var g_LoadingWidgets = false;


function CViewMgr(convertedImgID, highlightDivID)
{
	this.onResize = null;
	this.ApplyZoom = null;
	this.ChangingView = false;

	this.put_Location = ViewMgrDefaultFind;
	this.Zoom = ViewMgrDefaultResize;
	this.PostZoomProcessing = null;
	this.setView = null;
	this.PostSetViewProcessing = null;
	this.viewChanged = null;

	this.SupportsDetails = false;
	this.SupportsSearch = false;

	this.visBBoxLeft = 0.0;
	this.visBBoxRight = 0.0;
	this.visBBoxBottom = 0.0;
	this.visBBoxTop = 0.0;

	this.highlightDiv = null;
	this.stepWidth = 10;

	this.id = convertedImgID;
	this.zoomFactor = -1;
	this.zoomLast = -1;
	this.origWH = 1;
	this.origWidth = 100;	
	this.aspectRatio = 1;

	this.docDrawing = null;
	var docDrawing = frmDrawing.document;
	if(docDrawing)
	{
		this.docDrawing = docDrawing;
		var docEl = docDrawing.all(this.id);
		if (docEl)
		{
			this.s = docEl.style;
			this.origWidth = this.s.pixelWidth;
			this.origWH = this.s.pixelWidth / this.s.pixelHeight;
		}
		this.highlightDiv = docDrawing.all(highlightDivID);
	}

	this.loadPage = DefPageLoad;
	this.getPNZ	= null;
}

function DefPageLoad (pageIndex)
{
	if (pageIndex >= 0)
	{
		var curPath = frmDrawing.location.href;
		var fileDelim = curPath.lastIndexOf ('/');
        if (fileDelim == -1)
            fileDelim = curPath.lastIndexOf ('\\');
		var newPath = curPath.substring (0, fileDelim + 1);
		newPath += g_FileList[pageIndex].PriImage;
		frmDrawing.location.href = newPath;

		SetPNZDisplay (pageIndex);
	}
}

function CurPageUpdate (pageIndex)
{
	if (pageIndex >= 0)
	{
		g_CurPageIndex = pageIndex;

		SetCurPageInGoto (pageIndex);

		var divDetails = frmToolbar.document.all("divDetails");
		if (divDetails)
		{
			var displayStatus = "block";
			if (!viewMgr || !viewMgr.SupportsDetails)
			{
				displayStatus = "none";
			}

			divDetails.style.display = displayStatus;
		}

		var divSearch = frmToolbar.document.all("divSearch");
		if (divSearch)
		{
			var displayStatus = "block";
			if (!viewMgr || !viewMgr.SupportsSearch)
			{
				displayStatus = "none";
			}

			divSearch.style.display = displayStatus;
		}

		SetPNZDisplay (pageIndex);

		LoadZoom ();
	}
}

function FramePageLoaded ()
{
	if (isUpLevel && viewMgr == null)
	{
		var curPath = frmDrawing.location.href;
		var fileDelim = curPath.lastIndexOf ('/');
		if (fileDelim >= 0)
		{
			var fileName = curPath.substring (fileDelim + 1, curPath.length);
			var pageIndex = PageIndexFromFileName (fileName);
			SetCurPageInGoto (pageIndex);
			SetPNZDisplay (pageIndex);
		}
	}
}

function LoadZoom ()
{
	var zoomWidget = frmToolbar.ifrmPNZ;
	if (zoomWidget)
	{
		if (g_ZoomLoaded)
		{
			zoomWidget.findContent();
			PageLoadedDoCallback ();
		}
		else
		{
			window.setTimeout("LoadZoom()", 500);
		}
	}
	else
	{
		PageLoadedDoCallback ();
	}
}

function SetCurPageInGoto (pageIndex)
{
	var gotoPageSelect = frmToolbar.document.all("Select1");
	if (gotoPageSelect != null)
	{
		gotoPageSelect.value = pageIndex;
	}
}

function SetPNZDisplay (pageIndex)
{
	var divPNZ = frmToolbar.document.all("divPNZ");
	if (divPNZ)
	{
		var displayStatus = "block";
		if (g_FileList[pageIndex].PageID < 0)
		{
			displayStatus = "none";
		}

		divPNZ.style.display = displayStatus;
	}
}

function ViewMgrDefaultFind()
{
	return;
}

function ViewMgrDefaultResize(size)
{
	return;
}



g_callBackFunctionArray = new Array();
function PageLoadedDoCallback()
{
	if (g_WidgetsLoaded)	
	{
		for( var i=0; i < g_callBackFunctionArray.length; i++ )
		{
			g_callBackFunctionArray[i]();
		}
		g_callBackFunctionArray = new Array();
	}
	else
	{
		window.setTimeout("PageLoadedDoCallback()", 500);
	}
}


function ParseParams (strRawParams)
{
	strRawParams = strRawParams.substring(1);

	var arrayParamTokens = strRawParams.split('&');
	for (var count = 0; count < arrayParamTokens.length; count++)
	{
		arrayParamTokens[count] = unescape(arrayParamTokens[count]);
		this[count] = arrayParamTokens[count].substring(0, arrayParamTokens[count].indexOf('='));
		this[this[count]] = arrayParamTokens[count].substring(arrayParamTokens[count].indexOf('=') + 1);
	}

	return this;
}

var gParams = ParseParams (location.search);

var g_PageParamValue = gParams['page'];
if (g_PageParamValue != null && 
	g_PageParamValue.length > 0)
{
	var pageIndex = PageIndexFromName (g_PageParamValue);
	if (pageIndex > 0 && pageIndex < g_FileList.length)
	{
		g_CurPageIndex = pageIndex;
	}
}
else
{
	g_PageParamValue = null;
}

var g_FirstPageToLoad = g_PageParamValue;

var g_ZoomParamValue = gParams['zoom'];
if (g_ZoomParamValue != null && g_ZoomParamValue.length > 0)
{
	g_ZoomParamValue = 1.0 * g_ZoomParamValue;
	if (g_ZoomParamValue >= 10 && g_ZoomParamValue <= 500)
	{
		g_callBackFunctionArray[g_callBackFunctionArray.length] = function () { if (viewMgr && viewMgr.Zoom) { viewMgr.Zoom(g_ZoomParamValue); } };
	}
}

var g_ShapeParamValue = gParams['shape'];
if (g_ShapeParamValue != null && g_ShapeParamValue.length > 0)
{
	if (g_PageParamValue != null && g_PageParamValue.length > 0)
	{
		g_callBackFunctionArray[g_callBackFunctionArray.length] = function () { var shapeNode = FindShapeXMLByName (g_PageParamValue, g_ShapeParamValue); if (shapeNode) { frmToolbar.TreeSelect (g_FileList[g_CurPageIndex].PageID, shapeNode.attributes.getNamedItem ("ID").text); } };
	}
	else
	{
		g_ShapeParamValue = null;
	}
}

var g_SearchParamValue = gParams['search'];
if (g_SearchParamValue != null && g_SearchParamValue.length > 0)
{
	g_callBackFunctionArray[g_callBackFunctionArray.length] = function () { if (frmToolbar.theForm) { frmToolbar.theForm.findString.value = g_SearchParamValue; } };
	g_callBackFunctionArray[g_callBackFunctionArray.length] = function () { var goButton = frmToolbar.document.all('GoButton'); if(goButton) { goButton.click(); } };
}


var strHLTooltipText = "Clique para seguir hiperlink.";
var strPropsTooltipText = "Pressione Ctrl + Click para exibir detalhes.";

var strFocusHLTooltipText = "Digite para seguir hiperlink.";
var strFocusPropsTooltipText = "Pressione Ctrl + Enter para exibir detalhes.";


function UpdateTooltip (element, pageID, shapeID)
{
	if (isUpLevel)
	{
		var strHL, strProps;
	
		if(frmDrawing.event.type == "focus")
		{
			strHL = strFocusHLTooltipText;
			strProps = strFocusPropsTooltipText;
		}
		else
		{
			strHL = strHLTooltipText;
			strProps = strPropsTooltipText;
		}

		var strTooltip = "";
		if (element.origTitle)
		{
			strTooltip = element.origTitle.toString();
		}
			
		var shapeNode = FindShapeXML (pageID, shapeID);

		if( shapeNode != null )
		{
			var propColl = shapeNode.selectNodes ("Prop");
			if (propColl != null && propColl.length > 0)
			{
				if (strTooltip.length > 0)
				{
					strTooltip += "\n";
				} 
				strTooltip += strProps;
			}
		}

		var hlObj = GetHLAction (shapeNode, pageID, shapeID);
		if (hlObj != null && (hlObj.DoFunction.length > 0 || hlObj.Hyperlink.length > 0))
		{
			if (strTooltip.length > 0)
			{
				strTooltip += "\n";
			}	
			strTooltip += strHL;
		}

		element.title = strTooltip;
		if (element.alt != null)
		{
			element.alt = strTooltip;
		}
	}
}


function GetHLAction (shapeNode, pageID, shapeID)
{
	var hlObj = new HLObj ("", "", "", false);

	if (shapeNode != null)
	{
		var hlColl = shapeNode.selectNodes ("Scratch/B/SolutionXML/HLURL:Hyperlinks/HLURL:Hyperlink");

		if (hlColl.length > 1)
		{
			hlObj.DoFunction = "showMenu(" + pageID + ", " + shapeID + ");"
		}
		else if (hlColl.length == 1)
		{
			hlObj = CreateHLObj (hlColl.item(0));
		}
	}

	return hlObj;
}

function HLObj (strHyperlink, strDoFunction, strDesc, newWindow) 
{
	this.Hyperlink = strHyperlink;
	this.DoFunction = strDoFunction;
	this.Desc = strDesc;
	this.NewWindow = newWindow;
}

function clickMenu()
{
	var e = window.frmDrawing.event;
	var menu = frmDrawing.document.all("menu1")
	
	if (menu != null && menu.style.display != "none")
	{
		menu.style.display="none";

		if (e && e.srcElement && e.srcElement.doFunction != null)
		{
			eval(e.srcElement.doFunction);
		}
	}
}

function toggleMenuDiv(el, highlight) 
{
	var divEl = el;
	var aEl = null;

	var ID = el.id.substring (g_HLMenuEntryDiv.length, el.id.length) * 1.0;
	aEl = divEl.all(g_HLMenuEntry + ID);

	toggleMenu(divEl, aEl, highlight);
}

function toggleMenuLink(el, highlight) 
{
	var divEl = null;
	var aEl = el;

	var ID = el.id.substring (g_HLMenuEntry.length, el.id.length) * 1.0;
	divEl = frmDrawing.document.all(g_HLMenuEntryDiv + ID);

	toggleMenu(divEl, aEl, highlight);
}

function toggleMenu(divEl, aEl, highlight)
{
	if (highlight)
	{
	  divEl.className="highlightItem";
	  aEl.className="highlightItem";
	} 
	else 
	{
	  divEl.className="menuItem";
	  aEl.className="menuItem";
	}
}

function showMenu(pageID, shapeID)
{
	var shapeXML = FindShapeXML (pageID, shapeID);
	if (shapeXML != null)
	{
		CreateHLMenu (shapeXML);
		var menu = frmDrawing.document.all("menu1");
		if (menu != null)
		{
			menu.style.visibility = "hidden";
			menu.style.display = "inline";

			var e = window.frmDrawing.event;
			var elem = e.srcElement;

			var clientWidth = frmDrawing.document.body.clientWidth;
			var clientHeight = frmDrawing.document.body.clientHeight;

			var menuWidth = menu.clientWidth;
			var menuHeight = menu.clientHeight;

			var menuLeft = e.x;
			var menuTop = e.y;
			
			var doc = frmDrawing.document;
			var img = doc.all("ConvertedImage");
			
			if( (menuLeft + doc.body.scrollLeft < elem.offsetLeft) || (menuLeft + doc.body.scrollLeft > elem.offsetLeft + elem.offsetWidth + img.offsetLeft) )
			{
				menuLeft = elem.offsetLeft + img.offsetLeft + elem.offsetWidth/2;
			}
			
			if( (menuTop + doc.body.scrollTop < elem.offsetTop) || (menuTop + doc.body.scrollTop > elem.offsetTop + elem.offsetHeight + img.offsetTop) )
			{
				menuTop = elem.offsetTop + img.offsetTop + elem.offsetHeight/2;
			}

			var scrollBarSize = 20;
			if (menuLeft + menuWidth > clientWidth - scrollBarSize)
			{
				menuLeft = clientWidth - menuWidth - scrollBarSize;
			}

			if (menuTop + menuHeight > clientHeight - scrollBarSize)
			{
				menuTop = clientHeight - menuHeight - scrollBarSize;
			}

			menu.style.posLeft = menuLeft + frmDrawing.document.body.scrollLeft;
			menu.style.posTop = menuTop + frmDrawing.document.body.scrollTop;
			menu.style.visibility = "visible";

			var firstLink = menu.all(g_HLMenuEntry + "0");
			firstLink.focus ();
			
			if (e.keyCode == 13)
			{
				toggleMenuLink(firstLink, true);
			}

			e.cancelBubble = true;
		}
	}
}

function MenuKeyDown ()
{
	var e = window.frmDrawing.event;
	var el = e.srcElement;

	if (e.keyCode == 27)	// 27 == ESC
	{
		clickMenu();
		e.cancelBubble = true;
		return;
	}

	var curSelID = el.id.substring (g_HLMenuEntry.length, el.id.length) * 1.0;
	var newSelID = -1;

	if (e.keyCode == 40)	// 40 == down arrow
	{
		newSelID = curSelID + 1;
	}
	else if (e.keyCode == 38) // 38 == up arrow
	{
		newSelID = curSelID - 1;
	}

	var newSelEntry = frmDrawing.document.all(g_HLMenuEntry + newSelID);

	if (newSelEntry)
	{
		newSelEntry.focus();

		var curSelEntry = frmDrawing.document.all(g_HLMenuEntry + curSelID);
		toggleMenuLink (curSelEntry, false);
		toggleMenuLink (newSelEntry, true);
	}

	e.cancelBubble = true;
}

function CreateHLMenu (shapeNode)
{
	var strHLMenuHTML = "";

	if (shapeNode != null)
	{
		var hlColl = shapeNode.selectNodes ("Scratch/B/SolutionXML/HLURL:Hyperlinks/HLURL:Hyperlink");

		strHLMenuHTML = "<div class='innerhlMenu'>";

		var hlCount = hlColl.length;
		for (var count = 0; count < hlCount; count++)
		{
			var hlObj = CreateHLObj (hlColl.item(count));
			if (hlObj != null)
			{
				if (hlObj.Desc.length > 0)
				{
					strHLMenuHTML += "<div id='" + (g_HLMenuEntryDiv + count) + "' class='menuItem' onmouseover='toggleMenuDiv(this, true)' onmouseout='toggleMenuDiv(this, false)' onclick='" + (g_HLMenuEntry + count) + ".click()'>";
					strHLMenuHTML += "<a href=";

					if (hlObj.DoFunction.length > 0)
					{
						strHLMenuHTML += "'javascript:" + hlObj.DoFunction + "'";
					}
					else
					{
						var targetVal = "_top";
						if (hlObj.NewWindow)
						{
							targetVal = "_blank";
						}
						strHLMenuHTML += "'" + hlObj.Hyperlink + "' target='" + targetVal + "'";
					}

					strHLMenuHTML += " class='menuItem' id='" + (g_HLMenuEntry + count) + "' onkeydown='parent.MenuKeyDown();' onmouseover='toggleMenuLink(this, true)' onmouseout='toggleMenuLink(this, false)'>";
					strHLMenuHTML += hlObj.Desc + "</a></div>";
				}
			}
		}
		
		strHLMenuHTML += "</div>";
	}

	frmDrawing.menu1.innerHTML = strHLMenuHTML;
}

function CreateHLObj (hlNode)
{
	var strAddress = "";
	var hlObj = new HLObj ("", "", "", false);

	if (hlNode != null)
	{
		var hlAddress = hlNode.selectSingleNode("HLURL:Address/textnode()");
		if (hlAddress != null && hlAddress.text.length > 0)
		{
			var absoluteURL = hlNode.selectSingleNode("HLURL:AbsoluteURL/textnode()");
			var strAbsURL = absoluteURL.text;
			var strAddr = hlAddress.text;

			if (strAbsURL.indexOf (g_FileProtocol) == 0)
			{
				var strAbsPath = strAbsURL.substring (g_FileProtocol.length, strAbsURL.length);
				strAbsPath.toLowerCase ();
				strAddr.toLowerCase ();
				if (strAbsPath == strAddr)
				{
					strAddress = strAbsPath;
				}
				else
				{
					strAddress = strAddr;
					
					var hlSubAddress = hlNode.selectSingleNode("HLURL:SubAddress/textnode()");
					if (hlSubAddress != null && hlSubAddress.text.length > 0)
					{
						strAddress += '#';
						strAddress += hlSubAddress.text;
					}

					var hlExtraInfo = hlNode.selectSingleNode("HLURL:ExtraInfo/textnode()");
					if (hlExtraInfo != null && hlExtraInfo.text.length > 0)
					{
						strAddress += '?';
						strAddress += hlExtraInfo.text;
					}
				}
			}
			else
			{
				strAddress = strAbsURL;
			}		

			strAddress = HTMLEscape (strAddress);
			hlObj.Hyperlink += strAddress;
		}
		else
		{
			hlAddress = hlNode.selectSingleNode("HLURL:SubAddress/textnode()");
			if (hlAddress != null && hlAddress.text.length > 0)
			{
				strAddress = hlAddress.text;

				var pageShapeSep = strAddress.lastIndexOf ('/');
				if (pageShapeSep > 0)
				{
					if (PageIndexFromName (strAddress) < 0)
					{
						strAddress = unescape (strAddress);
						if (PageIndexFromName (strAddress) < 0)
						{
							strAddress = strAddress.substring (0, strAddress.lastIndexOf ('/'));
						}
					}
				}

				var pageIndex = PageIndexFromName (strAddress);

				hlObj.DoFunction = "GoToPage (" + pageIndex + ");";
				strAddress = HTMLEscape (strAddress);
				hlObj.Desc = strAddress;
			}
		}

		hlDesc = hlNode.selectSingleNode("HLURL:Description/textnode()");
		if (hlDesc != null && hlDesc.text.length > 0)
		{
			hlObj.Desc = HTMLEscape (hlDesc.text);
		}
		else
		{
			hlObj.Desc = strAddress;
		}
	
		var hlNewWindow = hlNode.selectSingleNode("HLURL:NewWindow/textnode()");
		if (hlNewWindow != null && hlNewWindow.text.length > 0)
		{
			hlObj.NewWindow = (hlNewWindow.text == "1");
		}		
	}

	return hlObj;
}


		</script>
	</head>
	
	<frameset id="frmstOuter" cols="237,*" title="Atendimento">
		<frame src="atendimento_arquivos/toolbar.htm" name="frmToolbar" id="frmToolbar" title="Este quadro contém ferramentas para manipulação do desenho." frameborder="6" bordercolor="#999999" scrolling="no" marginheight="0" marginwidth="0" >
		<frame src="atendimento_arquivos/jpg_2.htm" name="frmDrawing" title="Este quadro contém as páginas do desenho." marginheight="10" marginwidth="10" onload="if (parent.isUpLevel) FramePageLoaded()" >

		<noframes>
			<body>

				<h1>Atendimento</h1>
				<ul>
				<li><a href="atendimento_arquivos/jpg_2.htm">Atendimento</a></li>

				</ul>
			</body>
		</noframes>
	</frameset>
	
</html>

