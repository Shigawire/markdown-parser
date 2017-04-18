(function() {
  this.MarkdownParser = (function() {
    var parse, regExPatterns;
    regExPatterns = {
      '(\\*\\*)([\\s\\S]+?)\\1': '<strong>$2</strong>',
      '^\\*\\s(.*)': '<li>$1</li>',
      '(<li>.*<\/li>\n)+': function(li_set) {
        return '<ol>\n' + li_set + '</ol>\n';
      },
      '(\\*)([\\s\\S]+?)\\1': '<i>$2</i>',
      '^##(.*)': '<h2>$1</h2>',
      '^#(.*)': '<h1>$1</h1>',
      '^>\\s([\\s\\S]*?\\n|.*?)$': '<p><blockquote>$1</blockquote></p>\n',
      '^>\\s([\\s\\S]*?)$': '<p><blockquote>$1</blockquote></p>\n',
      '(\n\n)': '\n<p></p>\n'
    };
    parse = function(markdownCode) {
      var regExpPattern, replacementRule, transpiledHTMLOutput;
      transpiledHTMLOutput = '';
      for (regExpPattern in regExPatterns) {
        replacementRule = regExPatterns[regExpPattern];
        markdownCode = markdownCode.replace(new RegExp(regExpPattern, 'gm'), replacementRule);
      }
      return transpiledHTMLOutput = markdownCode;
    };
    return {
      parse: parse
    };
  })();

}).call(this);
