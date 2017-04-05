@editor = ace.edit('markdown-input')
@output = ace.edit('html-output')
@output.$blockScrolling = Infinity
# @editor.setTheme('ace/theme/monokai')
#@editor.getSession().setMode("ace/mode/markdown");
# transpile Markdown to HTML as soon as the editor contents change
@editor.getSession().on 'change', ->
    markdownCode = editor.getSession().getValue()
    htmlCode = MarkdownParser.parse markdownCode

    output.getSession().setValue(htmlCode)

    $('#html-render').html(htmlCode)
    #$('#html-output').html(htmlCode)
