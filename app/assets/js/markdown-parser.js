(function() {
  this.MarkdownParser = (function() {
    var buildHTMLNode, matchMDtoHTML, parse, regExPatterns;
    regExPatterns = {
      '^(\\*\\*)([\\s\\S]+?)\\1': 'strong',
      '^\\*(.*?)\\*': 'i',
      '^##(.*)': 'h2',
      '^#(.*)': 'h1'
    };
    buildHTMLNode = function(content, nodeType) {
      var element;
      element = $(document.createElement(nodeType));
      element.text(content);
      return element.prop('outerHTML');
    };
    matchMDtoHTML = function(markdownChunk) {
      var matchedContent, matchedTextGroups, nodeType, regExp, regExpPattern, transpiledHTMLChunk;
      console.log(markdownChunk);
      transpiledHTMLChunk = '';
      for (regExpPattern in regExPatterns) {
        nodeType = regExPatterns[regExpPattern];
        regExp = new RegExp(regExpPattern);
        console.log(regExp + regExp.test(markdownChunk));
        if (regExp.test(markdownChunk) === false) {
          transpiledHTMLChunk = buildHTMLNode(markdownChunk, 'p');
          continue;
        }
        matchedTextGroups = regExp.exec(markdownChunk);
        matchedContent = matchedTextGroups[2];
        matchedContent;
        transpiledHTMLChunk = buildHTMLNode(matchedContent, nodeType);
        break;
      }
      return transpiledHTMLChunk;
    };
    parse = function(markdownCode) {
      var i, len, linebreakRegExp, markdownChunk, markdownChunks, transpiledHTMLOutput;
      linebreakRegExp = new RegExp(/[^\n]+/g);
      transpiledHTMLOutput = '';
      markdownChunks = markdownCode.match(linebreakRegExp);
      for (i = 0, len = markdownChunks.length; i < len; i++) {
        markdownChunk = markdownChunks[i];
        transpiledHTMLOutput += matchMDtoHTML(markdownChunk) + '\n';
      }
      return transpiledHTMLOutput;
    };
    return {
      parse: parse
    };
  })();

}).call(this);
