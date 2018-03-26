
/***************************************************************************************************
 **
 ** ERROS, WARNINGS, MESSAGES, ETC.
 **
 **************************************************************************************************/

function fadeOut()
{
	var myDiv = document.getElementById("message");
	//myDiv.style.visibility = "hidden";
	//myDiv.style.opacity = 0;
}

// this is not as simple because in the CSS we use a rule to write the start from right to left
// so computation of the elements based on the mouse position is inverted, hence the break
// whenever the value turns from negative to positive. Then the number i actually starts at 0
// from the right, so to get the start from the left (hug) we need to remove i from the total number
// of stars (5). That's our star rating.

//var is_running = 0;
//var pop_up = document.getElementById("error_pop_up");
//document.getElementById("error_pop_up").addEventListener('transitionEnd', function() { is_running = 0; }, false);

function displayErrorMessage(elem, message)
{
	var msg = document.getElementById("error_pop_up");
	if (msg == null)
	{
		console.log('ERRROR');
		return;
	}
	
    msg.style.transition = 'none';
    msg.style.opacity = '1';
    // <embed width='30px' height='30px' style='color: red;' src='/images/exclamation-mark-in-a-circle-1.svg'/>
    // <embed width='30px' height='30px' style='color: red;' src='/images/exclamation-mark-in-a-circle-1.svg'/>
    msg.innerHTML = "<div style='display: table; background-color: rgb(250, 250, 250); border: 1px none green; width: 960px; margin: 0 auto; height: 100%; vertical-align: middle;'> \
    	<div style='display: table-cell; border: 1px none blue; padding-left: 0px; vertical-align: middle; font-size: 16px; font-weight: 800; color:rgb(200, 100, 100);'>" + message + "</div></div>";    
    // It's absolutely necessary to keep this line here even though it doesn't do anything.
    // Well, it does something internally, which is that because the browser things the element
    // has moved, then it forces the evaluation of its CSS which in our particular case, whent
    // from transition none to something else. This is what actually triggers the transitionning
    // reset. The point is, if you remove it, it will stop working.
    var tmp = elem.offsetTop;
    msg.style.bottom = '0';
    msg.style.borderTop = '2px solid rgb(200, 200, 200)';
    msg.style.backgroundColor = 'rgb(250, 250, 250)';
    msg.style.transition = 'opacity 1s linear';
    msg.style.transitionDelay = '3s';
    msg.style.opacity = '0';
}

/***************************************************************************************************
 **
 ** RATING
 **
 **************************************************************************************************/

function canVote(callback, userId, lessonId)
{
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.open("GET", "/rating.php?action=check&lesson_id=" + lessonId + "&user_id=" + userId, true);
	xmlhttp.send();
	var result = true;
	xmlhttp.onreadystatechange=function()
	{
		if (xmlhttp.readyState == 4 && xmlhttp.status == 200)
		{
			callback(xmlhttp.responseText);
		}
	}
}

function starRating(evt, elem, lessonId, ratingDivElem, isMember, userId)
{
	if (!isMember)
	{
		displayErrorMessage(elem, "You need to be logged in to vote");
		return false;
	}

	canVote(function(result)
	{
		if (result == false)
		{
			displayErrorMessage(elem, "You can only vote once a day");
		}
		else
		{
			// What's the current user's vote? The way we count the current rating is based on JS
			// only and the position of the mouse relative to the position of the first star
			// in the row of a total of 5 stars. But it's a bit tricky because to get to the star
			// hightlight thing working in CSS, we need to reverse the writing direction (right to left)
			// so the match involve to compute the final rating as 5 - i (see below).
			var child = elem.childNodes;
			count = 0;
			var stars = 0;
			for (i = 0; i < child.length; ++i) {
				var c = child[i];
				var offset = evt.clientX - c.offsetLeft;
				if (offset > 0) { stars = 5 - i; break; }
			}
			// create an AJAX request and send to PHP page responsible for voting and wait for answer
			var xmlhttp = new XMLHttpRequest();
			xmlhttp.open("GET", "/rating.php?action=rating&stars=" + stars + "&lesson_id=" + lessonId + "&user_id=" + userId, true);
			xmlhttp.send();
			xmlhttp.onreadystatechange=function()
			{
				if (xmlhttp.readyState == 4 && xmlhttp.status == 200)
				{
					//result = xmlhttp.responseText;
					// the rating.php page returns a percentage (rate of the lesson)
					//console.log(xmlhttp.responseText);
					document.getElementById(ratingDivElem).style.width = xmlhttp.responseText;
				}
			}
			//document.getElementById("myDiv").innerHTML=xmlhttp.responseText;
		}
	}, userId, lessonId);
}

/***************************************************************************************************
 **
 ** CODE BEAUTIFIERS & CODE PAGE RELATED FUNCTIONS
 **
 **************************************************************************************************/

// see comment in code.php
function onMouseDownCodeCtxt(caller, link)
{
	// link when on right click/contextual menu, when user wants to download file
	// see comment in code.php
	caller.href = link;
}

function pad(n, width, z) 
{
  z = z || '0';
  n = n + '';
  return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
}

function codePretty(parent, text, startLine)
{
	//col2.style.id = "code_" + n; 
	var lines = text.split('\n');
	var code = '';
	var numbers = '';

	for (var i = 0; i < lines.length; i++)
	{
		numbers += pad(startLine + i + 1, 3) + '<br/>';
		var whiteSpaces = lines[i].search(/[^\s\\]/); // match anything that is not a white space
		//console.log(whiteSpaces);
		var words = lines[i].trim().split(' ');
		var line = '';
		//console.log(words[0]);
		if (words[0].search('//') == 0)
		{
			//console.log('toto ' + words[0]);
			line = "<span style='color: rgb(100, 100, 100);'>" + lines[i].substr(whiteSpaces, lines[i].length) + "</span>";
		}
		else
		{
			for (j = 0; j < words.length; ++j)
			{
				var word = words[j];
				/*
				for (k = 0; k < word.length; ++k)
				{
					var c = word.charAt(k);
					if (c == '<') c = '&#60';
					else if (c == '>') c = '&#62';
					line = line.concat('x');
				}
				*/
				var keywords = ['if', 'for', 'public', 'class', 'return', 'const', 'int', 'float', 'char', 'double', 'unsigned', 'template', 'typename'];
				var pos = -1;
				var k = 0;
				
				for (; k < keywords.length; ++k)
				{
					//console.log(word.search(keywords[n]));
					pos = word.search(keywords[k]);
					/*
					// we may have found the occurence but it could be int in Point for example
					// so we also need to check the character before and after the occurence.
					// for an int it can only be (int for instance or for something like
					// public it can only be followed by ':'
					*/
					if (pos >= 0)
					{
						var cStart = (pos > 0) ? word.charAt(pos - 1) : '';
						var cEnd = word.charAt(pos + keywords[k].length);
						//console.log(word + ', ' + cStart);
						if ((cStart == '(' || cStart == '') && (cEnd == ';' || cEnd == ':' || cEnd == ''))
						{
							break;
						}
					}
				}
				if (k < keywords.length)
				{
					line = line.concat(word.substr(0, pos) + '<b>' + word.substr(pos, keywords[k].length) + '</b>' + word.substr(keywords[k].length + pos, word.length) + ' ');
				}
				else
				{
					/*
					var tmp = '';
					for (k = 0; k < word.length; ++k)
					{
						var c = word.charAt(k);
						if (c == '<') c = '&#60';
						else if (c == '>') c = '&#62';
						tmp += c;
					}
					*/
					line = line.concat(word + ' ');
				}
			}
		}
		code += lines[i].substr(0, whiteSpaces) + line + '<br/>';
	}

	var col1 = document.createElement("div");
	var col2 = document.createElement("div");
	col1.style.cssText = "margin: 0px 10px 0px 10px; display: inline-block; float: left; width: auto; text-align: center; color: rgb(100, 100, 100);";
	col2.style.cssText = "width: 100%; border-left: 1px solid rgb(100, 100, 100); padding-left: 10px; display: inline-block; width: auto; color: rgb(50, 50, 50);";
	col1.innerHTML = numbers;
	col2.innerHTML = code;
	parent.appendChild(col1);
	parent.appendChild(col2);
}

function codeBeautifier()
{
	var x = document.getElementsByName("code");
	// iterate over all code blocks you can find in the page and process each block individually
	for (n = 0; n < x.length; ++n) {
		var lines = x[n].innerHTML.split('\n');
		x[n].innerHTML = '';
		var k = 0, kStart = 0;
		var text = '';
		while (1)
		{
			//var words = lines[k].trim().split(' ');
			var textInTag = '';
			var tag = '';
			var pos = lines[k].search(/[^\s\\]/);
			//console.log(pos);
			if (lines[k].charAt(pos) == '/' && ((lines[k].length > pos + 1) && lines[k].charAt(pos + 1) == '/'))
			{
				// look for a tag?
				//console.log("look for tag?");
				var l = pos + 2;
				for (; l < lines[k].length; ++l)
				{
					//console.log('here ' + lines[k].charAt(l));
					if (lines[k].charAt(l) == '[')
					{
						while (lines[k].charAt(++l) != ']' && l < lines[k].length) tag += lines[k].charAt(l);
						//console.log("tag name " + tag);
						break; // break from look if we have our tag
					}
					else if (lines[k].charAt(l) != ' ')
						break;
				}
				if (tag.length > 0)
				{
					// we have a tag, extract the content
					for (++l; l < lines[k].length; ++l)
					{
						textInTag += lines[k].charAt(l);
					}
					var extract = true;
					var lastInsertWasNewLine = true;
					while (extract)
					{
						if ((k + 1) == lines.length) break;
						k++;
						//textInTag += (textInTag.length > 0) ? '\n' : '';
						// if the lines starts with '//' add text until we find closing tag?
						pos = lines[k].search(/[^\s\\]/);
						if (lines[k].charAt(pos) == '/' && ((pos + 1 < lines[k].length) && lines[k].charAt(pos + 1) == '/')) {
							var lineContent = '';
							for (var m = pos + 2; m < lines[k].length && extract == true; ++m)
							{
								if (lines[k].charAt(m) == '[')
								{
									//console.log("here " + lines[k].charAt(m + 1));
									// It has to be a closing tag or some text such as 'v[0]' otherwise it's a syntax error. 
									// We don't deal with nested tags (for now)
									if ((m + 1) < lines[k].length && lines[k].charAt(++m) == '/')
									{
										// extract tag
										var tmp = '';
										while (lines[k].charAt(++m) != ']' && m < lines[k].length) tmp += lines[k].charAt(m);
										//console.log("tag name " + tmp + ', ' + tag);
										if (tmp != tag) 
										{
											tag = '';
										}
										else
										{
											extract = false;
										}
									}
									else
									{
										lineContent += '[' + lines[k].charAt(m);
									}
								}
								else
								{
									lineContent += lines[k].charAt(m);
								}
							}
							if (lineContent.length > 0)
							{
								if (lastInsertWasNewLine && lineContent.charAt(0) == ' ')
								{
									lineContent = lineContent.substr(1);
								}
								textInTag += lineContent;
								lastInsertWasNewLine = false;
							}
							else
							{
								textInTag += '\n';
								lastInsertWasNewLine = true;
							}
						}
					}
					if (tag != '')
					{
						// if we have text, export it
						if (text.length > 0)
						{
							codePretty(x[n], text, kStart);
							text = '';
						}
						//console.log(k + '>> ' + tag + ', ' + textInTag + '<<');
						var tagContent = document.createElement("div");
						if (tag == 'compile')
						{
							tagContent.style.cssText = 'padding: 10px; white-space: pre-wrap; border-left: 8px none rgb(73, 139, 234); background-color: #C8E6C9;';
							tagContent.innerHTML = "Instructions to compile this program:<br/>" + textInTag;
						} 
						else if (tag != 'ignore')
						{
							tagContent.style.cssText = 'width: 100%; padding: 10px; white-space: pre-wrap; border-left: 8px none rgb(73, 139, 234); background-color: #FFE0B2;';	
							tagContent.innerHTML = textInTag;
						}
						x[n].appendChild(tagContent);
						textInTag = '';
						tag = '';
						kStart = k + 1;
					}
				}
				else
				{
					// it's a comment just add it
					text += (text.length > 0 ? '\n' : '') + lines[k];
				}
			}
			else
			{
				text += (text.length > 0 ? '\n' : '') + lines[k];
			}
			if (++k == lines.length) break;
		}
		// dump what's left of the text if any
		if (text.length > 0)
		{
			codePretty(x[n], text, kStart);
			text = '';
		}
		//console.log("test " + x[n].innerHTML);
	}
}

/***************************************************************************************************
 **
 ** COMMENTS
 **
 ** Comments are a bit complicated -- of course. There's an add comment button at the bottom
 ** of each chapter. When you click on the link it calls a first js function (addComment).
 ** This function is responsible to add a text area in which you can type the comment. Then
 ** when you click on the Add Comment again, then it calls the processAddComment. This JS function
 ** recovers the text which was typed, remove the text area, put the add comment link back in, 
 ** add finally push the comment's text to the db. This is done via an AJAX process.
 ** The AJAX request calls comment.php and use the _GET method to pass the data. When we return
 ** form the AJAX call, then we add the comment to the page (register the callbacks for the
 ** mouse).
 **
 **************************************************************************************************/

function commentOnMouseOver(elem)
{
	var child = elem.childNodes;
	for (i = 0; i < child.length; i++)
	{
		if (child[i].className == 'comment-edit') child[i].style.visibility = 'visible';
	}
}

function commentOnMouseLeave(elem)
{
	var child = elem.childNodes;
	for (i = 0; i < child.length; i++)
	{
		if (child[i].className == 'comment-edit') child[i].style.visibility = 'hidden';
	}
}

// \callback is the callback function that we need to call once we return from the AJAX call
// \src is the image we need to check in the db
function checkRessourceCallback(callback, src)
{
	// create an AJAX request to add the comment to the database
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.onreadystatechange=function()
	{
		if (xmlhttp.readyState == 4 && xmlhttp.status == 200)
    	{
    		callback(xmlhttp.responseText);
    	}
	}

	// set the header after opening the connection (this is bug in w3school)
	xmlhttp.open("POST", "/resource.php", true);
	xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	xmlhttp.send("src=" + src);
}

function processResources(callback, src)
{
	var concat = '';
	for (i = 0; i < src.length; i++)
	{
		concat += src[i];
		if (i != src.length - 1)
		{
			concat += ",";
		}
	}
	// create an AJAX request to add the comment to the database
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.onreadystatechange=function()
	{
		if (xmlhttp.readyState == 4 && xmlhttp.status == 200)
    	{
    		callback(xmlhttp.responseText);
    	}
	}

	// set the header after opening the connection (this is bug in w3school)
	xmlhttp.open("POST", "/resource.php", true);
	xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	xmlhttp.send("src=" + concat);
	/*
	var result = [];
	for (i = 0; i < src.length; i++)
	{
		result.push(src[i]);
	}

	callback(result);
	*/
}

function getTagAndLink(commentText, data)
{
	for (i = data.count; i < commentText.length; i++)
	{
		var c = commentText.charAt(i);
		if (c == '[')
		{
			while (++i < commentText.length - 1 && commentText.charAt(i) != ']')
			{
				data.tag += commentText.charAt(i);
			}
		}
		if (commentText.charAt(++i) == '(')
		{
			while (++i < commentText.length - 1 && commentText.charAt(i) != ')')
			{
				data.link += commentText.charAt(i);
			}
		}
		data.count = i;
		break;
	}
}

function getOneLineOfCode(commentText, data)
{
	var i = 0;
	for (i = 0; i < 4; i++)
	{
		if (commentText.charAt(data.count + i) != ' ')
		{
			break;
		}
	}
	//console.log("i: " + i);
	if (i == 4)
	{
		data.count += 4;
		//console.log(commentText.charAt(data.count));
		while (commentText.charAt(data.count) != '\n' && data.count < commentText.length - 1)
		{
			data.tmp += commentText.charAt(data.count);
			data.count++;
		}
		data.tmp += '\n';
		//console.log("here >>" + data.tmp + "<<");
	}
}

function cleanAndProcessComment(commentText)
{
	/*
	// we first 'quickly iterate over all the text to check for images and extract links
	var src = [];
	for (i = 0; i < commentText.length; i++)
	{
		var c = commentText.charAt(i);
		if (c == '!')
		{
			// if this is an image?
			var data = { count: i + 1, tag: "", link: "" };
			getTagAndLink(commentText, data);
			if (data.tag.length > 0 && data.link.length > 0)
			{
				i = Math.min(data.count, commentText.length - 1);
				src.push(data.link);
			}
		} 
	}
	*/

	//console.log("found " + src.length + " images");
	// we now will post-poned the processing of the comment until we return from the 
	// AJAX call that checks all resources for us
	//processResources(function(result)
	//{
	//	console.log("result of AJAX query: " + result.length + ");
	//}, src);

	var numChars = 0;
	var code = "";
	var text = "";
	var isNewLine = true;
	for (i = 0; i < commentText.length; i++)
	{
		var c = commentText.charAt(i);
		//var isText = true;

		// let's now check what we do with this current character
		if (c == ' ' && numChars == 0)
		{
			// is this is code?
			var data = { count: i, tmp: "" };
			getOneLineOfCode(commentText, data);
			if (data.tmp.length > 0)
			{
				code += data.tmp;
				i = Math.min(data.count, commentText.length - 1);
				numChars = 0;
				isNewLine = true;
			}
			else
			{
				// it's a simple space, just add it to the text
				text += ' ';
				numChars++;
			}
		}
		else
		{
			if (code.length > 0)
			{
				text += "<div class='comment-content-code'>" + code + "</div>\n";
				code = '';
				isNewLine = true;
			}
			// If we start a new line either because the last character was a \n or because
			// we inserted a block of code (check the satement if (code.length > 0) above)
			// then we need to start a new paragraph.
			if (isNewLine == true)
			{
				text += "<p class='comment-content-p'>";
				isNewLine = false;
			}
			if (c == '<')
			{
				// remove that HTML tag
				for (; i <  commentText.length; i++)
				{
					if (commentText.charAt(i) == '>') break;
				}
			}
			else if (c == '*')
			{
				if ((i + 1 < commentText.length - 1) && commentText.charAt(i + 1) == '*')
				{
					var bold = '';
					for (i = i + 2; i < commentText.length; i++)
					{
						if (commentText.charAt(i) == '*' && commentText.charAt(i + 1) == '*')
							break;
						else
							bold += commentText.charAt(i);
					}
					text += "<b>" + bold + "</b>";
				}
			}
			else if (c == '\n')
			{
				numChars = 0;
				if (isNewLine == false)
				{
					text += "</p>\n";
					isNewLine = true;
				}
			}
			else if (c == '!')
			{
				// if this is an image?
				if ((i + 1 < commentText.length + 1) && commentText.charAt(i + 1) == '[')
				{
					var data = { count: i + 1, tag: "", link: "" };
					getTagAndLink(commentText, data);
					if (data.tag.length > 0 && data.link.length > 0)
					{
						i = Math.min(data.count, commentText.length - 1);
						text += " \
							<a href=\"" + data.link +  "\"> \
							<img class='comment-content-img' src=\"" + data.link + "\" tag=\"" + data.tag + "\"></a>";
					}
				}
			}
			else if (c == '[')
			{
				// if this is a link?
				var data = { count: i, tag: "", link: "" };
				getTagAndLink(commentText, data);
				if (data.tag.length > 0 && data.link.length > 0)
				{
					i = Math.min(data.count, commentText.length - 1);
					text += "<a class='comment-content-a' href=\"" + data.link + "\">" + data.tag + "</a>";
				}
			}
			else
			{
				text += c;
				numChars++;
			}
		}
	}

	// if it's the end of the line and that we don't have a \n then we need
	// to close the tag with </p> (assuming a new line was started)
	if (isNewLine == false)
	{
		text += "</p>\n";
	}

	// residual code
	if (code.length > 0)
	{
		text += "<div class='comment-content-code'>" + code + "</div>";
	}

	//checkRessourceCallback(function(resource)
	//{
	//	console.log("back from resource " + resource);
	//}		
	//console.log(text);

	return text;
}

function removeAddCommentTextField(isLoggedIn, userId, chapterId)
{
	// find the div that embeds all comment stuff
	var commentDiv = document.getElementById('comment');
	var form = document.getElementById('comment-form');

	// we are just adding the link back for add comment
	var commentLink = document.createElement("a"); // create a new link, set properties, append
	commentLink.setAttribute('id', 'comment-link');
	commentLink.href = '#';
	cmd = "addComment(this, " + isLoggedIn + ", " + userId + ", " + chapterId + "); return false;";
	commentLink.setAttribute("onclick", cmd);
	var linkText = document.createTextNode("add comment");
	commentLink.className = "add-comment-line";
	commentLink.appendChild(linkText);

	// using replace child is better because it insures that the link or the form or always
	// at the top of the div and that all comments are displayed right after.
	commentDiv.replaceChild(commentLink, form); 
}

//
// This is the function called when the user has actually entered some text in the text
// area and pushed the Add Comment button. If you want to find the function that is actually
// called the first time (before the text area is displayed), check the addComment function below.
//
// What? remove the text-area and replace it with the actual comment and also addd the link 
// to the 'add comment' link back in.
//
function processAddComment(isLoggedIn, userId, chapterId)
{
	// the first we need to do is copy the content of the text that was types by the user
	// into a temp variable, before it gets deleted.
	var commentText = document.getElementById('comment-text-area').value; // store the comment text
	//console.log(commentText);

	removeAddCommentTextField(isLoggedIn, userId, chapterId);

	// find the div that embeds all comment stuff
	var commentDiv = document.getElementById('comment');

	//console.log("process comment");
	if (commentText.length == 0) return false; // no need to add if the comment is empty
	//console.log(textArea.value);

	// create an AJAX request to add the comment to the database
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.onreadystatechange=function()
	{
		if (xmlhttp.readyState == 4 && xmlhttp.status == 200)
    	{
    		var tmp = document.createElement('div');
			tmp.innerHTML = xmlhttp.responseText;
			// that's a pretty neat trick
			// http://stackoverflow.com/questions/494143/creating-a-new-dom-element-from-an-html-string-using-built-in-dom-methods-or-pro
			commentDiv.insertBefore(tmp.firstChild, document.getElementById('comment-link'));
    	}
	}

	// okay this not super useful to do the processing of the comment in PHP because in fact
	// when I pass the data to the comment.php file using the AJAX function it reformats
	// it, which means that thingsl ike \n just go away. So HELAS we need to write the same
	// code by in JS.
	var commentHTML = cleanAndProcessComment(commentText);

	//url = "http://localhost/maquette/lessons/3d-basic-rendering/introduction-to-ray-tracing";
	// set the header after opening the connection (this is bug in w3school)
	xmlhttp.open("POST", "/comment.php", true);
	xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	xmlhttp.send("what=add&comment=" + commentText + "&commentHTML=" + commentHTML + "&userId=" + userId + "&chapterId=" + chapterId);
	
	/*
	// insert comment
	var newComment = document.createElement('div');
	newComment.className = 'comment-entry';
	var commentText = document.createTextNode(commentText);
	newComment.appendChild(commentText);
	
	//var user_link_text = document.createTextNode('jeancp');
	//newComment.appendChild(user_link_text);
	
	commentDiv.insertBefore(newComment, commentLink);
	*/
}

function showMoreCommentCallback(callback, chapterId, userId)
{
	// first delete the element?
	
	var commentDiv = document.getElementById('comment'); // should only be one
	var showMoreElement = document.getElementById('comment-showmore');
	
	/*
	// The issue here is that we only want to show more comments if we haven't done it yet.
	// and the only way we can check if the comments have already been all expanded, is by 
	// checking whether showMoreElement is null or not. If it's null it's because we remove
	// it when we expanded the list of comments the first time around. However we still need
	// to call the callback function because that's only within the scope of that function
	// that the add comment block is created. But we immediatly return right after as 
	// we don't want the Ajax call to be made.
	*/

	if (showMoreElement != null)
	{
		// Delete the node, leaving the comment-link node (add comment) the last child
		// of the comment block.
		commentDiv.removeChild(showMoreElement);
	}
	else
	{
		// If the comments are already all displayed, then just call the callback function
		// to get the add comment box displayed and return from this function (don't
		// make the Ajax request
		callback(true);
		return;
	}

	// Create an AJAX request to add the comment to the database
	var comments;
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.onreadystatechange=function()
	{
		if (xmlhttp.readyState == 4 && xmlhttp.status == 200)
    	{
    		var tmp = document.createElement('div');
			tmp.innerHTML = xmlhttp.responseText;
			//console.log("return from " +  xmlhttp.responseText);
			var elements = tmp.childNodes;
			var next = document.getElementById('comment-link');
			//console.log("number of child " + elements.length);
			for (i = elements.length - 1; i >= 0; i--)
			{
				//§console.log("here " + i + ", " + elements[i].nodeName + ', node value: ' + elements[i].innerHTML);
				next = commentDiv.insertBefore(elements[i], next);
			}
			callback(true);
    	}
	}

	xmlhttp.open("POST", "/comment.php", true);
	xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	xmlhttp.send("what=showmore&chapterId=" + chapterId + "&userId=" + userId);
}

function showMoreComment(chapterId, userId)
{
	showMoreCommentCallback(function(tmp) {}, chapterId, userId);
}

function cancelAddComment(isLoggedIn, userId, chapterId)
{
	removeAddCommentTextField(isLoggedIn, userId, chapterId);
}

//
// This is the function called when someone clicks on the add comment button
// It passes the div, a boolean (whether the person who clicked on the button is logged in or not)
// the member id (if he is logged in), and the chapter id so we can add the comment to the right
// field.
// What happens at this point, when someone wants to add a comment, is to replace the add comment
// button with a text area in which the user can actually type the message. Then of course
// we also need another Add Comment button which is going to push the content of the message
// to the SQL database.
// The 'processAddComment' JS script is attached to the Add Comment button, then of course
// it will be called when this happens - (when the button is clicked).
//
// PLEASE READ CAREFULLY HOW THINGS WORK WITH THE CALLBACK --
//
//
function addComment(elem, isMember, memberId, chapterId)
{
	if (isMember == 0)
	{
		displayErrorMessage(elem, "You need to be logged in to add a comment");
		return false;
	}

	/*
	// THIS DOESN"T SEEM TO BE VALID ANY LONGER
	// first expand all comments -- I changed the code so that now all comments are re-displayed
	// starting from the first one -- this has for effect to close all text-area which were open to
	// edit any of the comments -- and only leave you with the add comment text area.
	// I don't think displaying the first 3 comments plus all the others is making a great
	// difference in terms of speed, and it gives us a nice behaviour in which only one thing
	// can be edited at a time (well doesn't mean you can't edit several comments at a time).
	//showMoreComment(chapterId);
	*/

	////////////////////////////////////////////////////////////////////////////////////////////////
	//
	// PLEASE READ CAREFULLY HOW THINGS WORK WITH THE CALLBACK --
	//
	// What we need to do, is expand the list of hidden comments (if any) before adding the 
	// text field for the user to enter the comment - The problem with this is that if we call
	// the showMoreComment functon directly, because the AJAX call is asynchronous, the 
	// text field is actually displayed before the hidden comments are revealed -- so the box
	// is not inserted in the right place. We use the same trick as we use for the ratings.
	// We actually use the showMoreCommentCallback function, which uses a callback function
	// executed only when we get the response from the AJAX call. That callback function
	// contains the code to add the text field for the comment - That way, the text field
	// is only inserted once all comments have been expanded. Et voila!
	//
	////////////////////////////////////////////////////////////////////////////////////////////////

	showMoreCommentCallback(function(tmp)
	{	
		// it looks for the comment section in the page. Should only be one
		var commentId = document.getElementById('comment'); // should only be one
		var commentLink = document.getElementById('comment-link');
	
		var commentBox = document.createElement("div");
		commentBox.setAttribute('id', 'comment-form');
		var textArea = document.createElement("textarea");
		textArea.className = 'comment-text-area';
		textArea.name = 'comment';
		textArea.setAttribute('id', 'comment-text-area');
		textArea.setAttribute('autofocus', 'yes');
		var form = document.createElement("form");
		form.action = 'javascript:processAddComment(' + isMember + ', ' + memberId + ', ' + chapterId + ');';
		form.method = 'post';
		var submit = document.createElement("input");
		submit.type = 'submit';
		submit.style.cssText = "font-size: 14px; width: 110px;";
		submit.value = 'Add Comment';
		form.appendChild(submit);
		
		var cancel = document.createElement('a');
		cancel.href = 'javascript:cancelAddComment(' + isMember + ', ' + memberId + ', ' + chapterId + ');';
		cancel.innerHTML = "cancel";
		cancel.style.cssText = "margin-left: 10px; font-size: 14px; display: inline-block;";
		form.appendChild(cancel);
		
		var text = document.createElement('div');
		text.className = "comment-add-guideline";
		text.innerHTML =  "We reserve the right to remove without notification comments which we feel are in breach of our guidelines.";
		commentBox.appendChild(textArea);
		commentBox.appendChild(text);
		commentBox.appendChild(form);
		commentId.replaceChild(commentBox, commentLink); // replacing child is better than deleting commentLink (see above)
		//console.log(commentId.innerHTML);
	}, chapterId);
}

function deleteComment(elem, commentId)
{
	var commentDiv = document.getElementById('comment'); // should only be one
	var parent = elem.parentNode;
	commentDiv.removeChild(parent);
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.onreadystatechange=function()
	{
		if (xmlhttp.readyState == 4 && xmlhttp.status == 200)
    	{
    		result = xmlhttp.responseText;
		}
	}
	
	//url = "http://localhost/maquette/lessons/3d-basic-rendering/introduction-to-ray-tracing";
	// set the header after opening the connection (this is bug in w3school)
	xmlhttp.open("POST", "/comment.php", false);
	xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	xmlhttp.send("what=delete&id=" + commentId);
	
	return false;
}

function processEditComment(elem, commentId)
{
	var commentDiv = document.getElementById('comment'); // should only be one
	var divName = 'comment-form-' + commentId;
	var commentForm = document.getElementById(divName);

	// create an AJAX request to add the comment to the database
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.onreadystatechange=function()
	{
		if (xmlhttp.readyState == 4 && xmlhttp.status == 200)
    	{
			var tmp = document.createElement('div');
			tmp.innerHTML = xmlhttp.responseText;
			// that's a pretty neat trick
			// http://stackoverflow.com/questions/494143/creating-a-new-dom-element-from-an-html-string-using-built-in-dom-methods-or-pro
			commentDiv.replaceChild(tmp.firstChild, commentForm);
    	}
	}

	var commentHTML = cleanAndProcessComment(commentForm.firstChild.value);

	//console.log("no html:" + commentForm.firstChild.value);
	//console.log("html: " + commentHTML);

	if (commentHTML.length == 0)
	{
		deleteComment(elem, commentId);
	}

	xmlhttp.open("POST", "/comment.php", true);
	xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	xmlhttp.send("what=edit&comment=" + commentForm.firstChild.value + "&commentHTML=" + commentHTML + "&commentId=" + commentId);

	return false;
}

// \elem: is the div corresponding to this comment
// \commentId: is the idea of th comment
// \username: is the name of the user name
// \comment: is the ORIGINAL comment -- before it's actually converted to HTML
function editComment(elem, commentId)
{
	var commentDiv = document.getElementById('comment'); // should only be one
	var commentBox = document.createElement("div");
	commentBox.style.cssText = 'border: 1px none red; margin: 10px 10px 5px 10px;';
	var divName = 'comment-form' + '-' + commentId;
	commentBox.setAttribute('id', divName);
	var textArea = document.createElement("textarea");
	textArea.className = 'comment-text-area';
	textArea.name = 'comment';
	textArea.setAttribute('autofocus', 'yes');

	var commentEntry = elem.parentNode;
	var child = commentEntry.childNodes;

	// create an AJAX request to add the comment to the database
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.onreadystatechange=function()
	{
		if (xmlhttp.readyState == 4 && xmlhttp.status == 200)
    	{
			textArea.value = xmlhttp.responseText;
    	}
	}

	xmlhttp.open("POST", "/comment.php", true);
	xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	xmlhttp.send("what=request&id=" + commentId);

	var form = document.createElement("form");
	//console.log(commentId);
	form.action = 'javascript:processEditComment(this, ' + commentId + ');';
	form.method = 'post';
	var submit = document.createElement("input");
	submit.type = 'submit';
	submit.style.cssText = "font-size: 14px; width: 110px";
	submit.value = 'Edit Comment';
	form.appendChild(submit);
	commentBox.appendChild(textArea);
	commentBox.appendChild(form);

	commentDiv.replaceChild(commentBox, commentEntry);
	
	return false;
}

function voteComment(elem, isMember, userId, commentId)
{
	if (isMember == 0)
	{
		displayErrorMessage(elem, "You need to be logged in to vote");
		//console.log("not a member");
		return false;
	}

	// create an AJAX request to add the comment to the database
	var xmlhttp = new XMLHttpRequest();
	xmlhttp.onreadystatechange=function()
	{
		if (xmlhttp.readyState == 4 && xmlhttp.status == 200)
    	{
    		document.getElementById("comment-vote-" + commentId).innerHTML = xmlhttp.responseText;
			//var response = xmlhttp.responseText;
    	}
	}

	xmlhttp.open("POST", "/comment.php", true);
	xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	xmlhttp.send("what=vote&userId=" + userId + "&commentId=" + commentId);
}

// used to fade in and out the title of the lesson when we list all lessons for a particular
// category
function highlightTitle(elem, inout)
{
	var cells = elem.getElementsByTagName("h2");
	//console.log(cells.length);
	if (inout == 0)
		cells[0].style.color = "rgb(73, 139, 234)";
	else
		cells[0].style.color = "rgb(70, 70, 70)";
}

/***************************************************************************************************
 **
 ** LOGIN REGISTER ETC.
 **
 **************************************************************************************************/

// because of the way the register page works, all forms are actually on the same
// page but only the form on top can have its first element with the attribute
// autofocus on. Thus when you click on a link (login, register, recover, reset, etc.), 
// it actually call this script and it sets the autofocus on the element we want
// for the current form (the one that is on top of the others).
function set_autofocus(tag)
{
	if (tag == "login")
	{
		document.getElementById('login-icon').style.backgroundColor = "rgb(73, 139, 234)";
		document.getElementById('register-icon').style.backgroundColor = "grey";
		var elem_focus = document.getElementById('login-form-name'); // should only be one
		//console.log(elem_focus.placeholder);
		elem_focus.focus();
	}
	else if (tag == "register")
	{
		document.getElementById('register-icon').style.backgroundColor = "rgb(73, 139, 234)";
		document.getElementById('login-icon').style.backgroundColor = "grey";
		var elem_focus = document.getElementById('register-form-name'); // should only be one
		//console.log(elem_focus.placeholder);
		elem_focus.focus();
	}
	else if (tag == "recover")
	{
		document.getElementById('login-icon').style.backgroundColor = "rgb(73, 139, 234)";
		document.getElementById('register-icon').style.backgroundColor = "grey";
		var elem_focus = document.getElementById('recover-form-email'); // should only be one
		elem_focus.focus();
	}
	else if (tag == "reset")
	{
		//var elem_focus = document.getElementById('register_focus'); // should only be one
		//elem_focus.setAttribute('autofocus', 'yes');
	}
}

//
// Process the error code for the login/register/etc. forms
// We are using a code system to pass on the messages
//
// LOGIN
//
// 1: missing data (either the username or password is empty)
// 2: user name doesn't exist
// 3: account not active
// 4: password not active
// 5: no data received
//
// REGISTER
//
// 10: name already taken
// 11: email address already in use
// 12: bad email address
// 13: not a valid password (8 characters min)
// 14: passwords don't match
// 15: missing data
//
// RECOVER
//
// 20: no data
// 21: can't find email
//
// RESET
//
// 30: no data
// 31: invalid passwd
// 32: don't match
//
function process_error(errorCode)
{
	//console.log(errorCode);
	if (errorCode == 1)
	{
		document.getElementById('login-form-name').style.backgroundColor = "rgb(255, 200, 200)";
		document.getElementById('login-form-password').style.backgroundColor = "rgb(255, 200, 200)";	
	}
	else if (errorCode == 2)
	{
		document.getElementById('login-form-name').placeholder = "Name (user name doesn't exist)";
		document.getElementById('login-form-name').style.backgroundColor = "rgb(255, 200, 200)";
	}
	else if (errorCode == 3)
	{
		document.getElementById('login-form-name').placeholder = "Name (account not active)";
		document.getElementById('login-form-name').style.backgroundColor = "rgb(255, 200, 200)";	
	}
	else if (errorCode == 4)
	{
		document.getElementById('login-form-password').placeholder = "Password (invalid pasword)";
		document.getElementById('login-form-password').style.backgroundColor = "rgb(255, 200, 200)";	
	}
	else if (errorCode == 10)
	{
		document.getElementById('register-form-name').placeholder = "Name (already used)";
		document.getElementById('register-form-name').style.backgroundColor = "rgb(255, 200, 200)";	
	}
	else if (errorCode == 11)
	{
		document.getElementById('register-form-email').placeholder = "Email (already used)";
		document.getElementById('register-form-email').style.backgroundColor = "rgb(255, 200, 200)";	
	}
	else if (errorCode == 12)
	{
		document.getElementById('register-form-email').placeholder = "Email (address doesn't seem right)";
		document.getElementById('register-form-email').style.backgroundColor = "rgb(255, 200, 200)";	
	}
	else if (errorCode == 13)
	{
		document.getElementById('register-form-password').placeholder = "Password (invalid - check the rules)";
		document.getElementById('register-form-password').style.backgroundColor = "rgb(255, 200, 200)";	
	}
	else if (errorCode == 14)
	{
		document.getElementById('register-form-password').placeholder = "Password (passwords don't match)";
		document.getElementById('register-form-password').style.backgroundColor = "rgb(255, 200, 200)";	
		document.getElementById('register-form-confirm').style.backgroundColor = "rgb(255, 200, 200)";	
	}
	else if (errorCode == 15)
	{
		document.getElementById('register-form-name').style.backgroundColor = "rgb(255, 200, 200)";
		document.getElementById('register-form-email').style.backgroundColor = "rgb(255, 200, 200)";
		document.getElementById('register-form-password').style.backgroundColor = "rgb(255, 200, 200)";
		document.getElementById('register-form-confirm').style.backgroundColor = "rgb(255, 200, 200)";
	}
	else if (errorCode == 20)
	{
		document.getElementById('recover-form-email').style.backgroundColor = "rgb(255, 200, 200)";
		document.getElementById('recover-form-email').placeholder = "Email";
	}
	else if (errorCode == 21)
	{
		document.getElementById('recover-form-email').style.backgroundColor = "rgb(255, 200, 200)";
		document.getElementById('recover-form-email').placeholder = "Email (can't be found)";
	}
	else if (errorCode == 30)
	{
		document.getElementById('reset-form-password').style.backgroundColor = "rgb(255, 200, 200)";
		document.getElementById('reset-form-confirm').style.backgroundColor = "rgb(255, 200, 200)";
	}
	else if (errorCode == 31)
	{
		document.getElementById('reset-form-password').style.backgroundColor = "rgb(255, 200, 200)";
		document.getElementById('reset-form-password').placeholder = "New Password (invalid)";
	}
	else if (errorCode == 32)
	{
		document.getElementById('reset-form-password').style.backgroundColor = "rgb(255, 200, 200)";
		document.getElementById('reset-form-confirm').style.backgroundColor = "rgb(255, 200, 200)";
		document.getElementById('reset-form-password').placeholder = "Password (passwords don't match)";
	}
}

/***************************************************************************************************
 **
 ** ON LOAD
 **
 **************************************************************************************************/

function setTestimonialStr()
{
	var elem = document.getElementById("testimonial");
	if (elem != null)
	{
		// create an AJAX request to add the comment to the database
		var xmlhttp = new XMLHttpRequest();
		xmlhttp.onreadystatechange=function()
		{
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200)
			{
				elem.innerHTML = "\"" + xmlhttp.responseText + "\"";
			}
		}
	
		xmlhttp.open("POST", "/testimonial.php", true);
		xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		xmlhttp.send("");
	}
}

// I had to change that code. Before I was using an onclick mechanism to get to the content
// section when you'd click on the content link. However the problem is that when you do
// this, the javascript is executed before the page is loaded, thus, you just get
// an error reported in the console and the script fails going any further, and you had
// to click another time (once the page was loaded) to actually get to the content section.
// So this is changed so that now I pass as a GET the keyword ?content. And this function
// is executed on page load() (once the page is loaded). This is workng however the problem
// is that onload() is now called and used by every single page (since I am using templates
// to build pages. However this is light enough probably and also this mechanism might
// be useful in the future for other pages (I can extent it, using other keywords).
// 14/08/2014
function onload()
{
	//var test = document.getElementById("toto");
	//test.style.display = "none";
	//console.log("test");

	// location is simply the url for the current page
	//if (location.search.substring(1) == 'content')
	//{
	//	var dest = document.getElementById('contentxx');
	//	document.body.scrollTop = dest.offsetTop - 47;
	//}
	//else
	//{
		//var loc = window.location;
		//console.log(">> info about loc, " + loc);
	
		//document.body.scrollTop = 0;
	//}
	
	var isPage = document.getElementById('sap-root');
	if (isPage != null)
	{
		// you need to find all the H2 in the document
		var allH2 = document.getElementsByTagName("h2");
		if (allH2.length > 0)
		{
			//alert("i found " + allH2.length + " elements");
			var rand = Math.floor(Math.random() * allH2.length);
			if (rand == allH2.length) rand = rand - 1;
			var text = document.createTextNode('the text');
			var newDiv = document.createElement('div');
			newDiv.setAttribute('class', 'donate-style');
			newDiv.innerHTML = "If Scratchapixel is important to you, make a big difference with a small monthly <a href=\'https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&amp;hosted_button_id=78FWLXMM9YGPN'\'>donation</a>.\
			</br><span style='font-size: 12px;'>All the lessons on Scratchapixel are free, but we now need your help to keep adding new content on the website. This will help recovering the cost of running the project. Making a donation is also a way\
			of showing that you care about this website because you think it's cool and that it is valuable to you! If you do it, it will help us developing the project further\
			but more importantly you will secure access to free high quality content for yourself and the generations to come. Everybody should have equal access to knowledge and this is why we are here. To give everybody an equal opportunity to learn something we believe is fun and important.\
			We try to make a difference but you also play a critical part in that chain.</br><b>Contribute to Scratchapixel in your own way, with a donation, and show it matters to you</b>.</span>";
			allH2[rand].parentNode.insertBefore(newDiv, allH2[rand]);
		}
	}
	
	codeBeautifier();
}