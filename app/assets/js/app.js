(function() {
  this.editor = ace.edit('markdown-input');

  this.output = ace.edit('html-output');

  this.output.$blockScrolling = 2e308;

  this.editor.getSession().on('change', function() {
    var htmlCode, markdownCode;
    markdownCode = editor.getSession().getValue();
    htmlCode = MarkdownParser.parse(markdownCode);
    output.getSession().setValue(htmlCode);
    return $('#html-render').html(htmlCode);
  });

}).call(this);
