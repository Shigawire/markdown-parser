@MarkdownParser = (->
    
    # this block describes regular expressions that identify a 
    # particular markdown pattern (e.g. ** for bold  text) and 
    # reference a valid HTML Node type (e.g. strong for bold HTML nodes)
    # the $1 or $2 in the replacement-text refer to the matched group of the regular expression.
    # i.e. for bold text, the second matching-group of the regex is the actual text.
    regExPatterns = { 
        '(\\*\\*)([\\s\\S]+?)\\1': '<strong>$2</strong>',
        '^\\*\\s(.*)': '<li>$1</li>',
        '(<li>.*<\/li>\n)+': (li_set) -> 
            '<ul>\n' + li_set + '</ul>\n'
        ,
        '(\\*)([\\s\\S]+?)\\1': '<i>$2</i>',
        '^##(.*)': '<h2>$1</h2>',
        '^#(.*)': '<h1>$1</h1>',
        # multi line quote
        '^>([\\s\\S]*?\\n|.*?)$': '<p><blockquote>$1</blockquote></p>\n',
        # single line quote
        #'^>([\\s\\S]*?)$': '<p><blockquote>$1</blockquote></p>\n',
        '(\n\n)': '\n<p></p>\n'
    }

    parse = (markdownCode) ->
        # the new HTML code 
        transpiledHTMLOutput = ''

        # iterate through the entire markdownCode and replace know Markdown delimiters with HTML nodes 
        for regExpPattern, replacementRule of regExPatterns
            markdownCode = markdownCode.replace(new RegExp(regExpPattern, 'gm'), replacementRule)

        transpiledHTMLOutput = markdownCode

    {
        parse: parse
    })()
