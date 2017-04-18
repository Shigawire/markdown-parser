@MarkdownParser = (->
    
    # this block describes regular expressions that identify a 
    # particular markdown pattern (e.g. ** for bold  text) and 
    # reference a valid HTML Node type (e.g. strong for bold HTML nodes)

    regExPatterns = { 
        '(\\*\\*)([\\s\\S]+?)\\1': '<strong>$2</strong>',
        '^\\*\\s(.*)': '<li>$1</li>',
        # match all <li> blocks to wrap an OL around. Ugly af, but
        # I have not identified a regex to match the entire <li>...</li> group yet.
        '(<li>.*<\/li>\n)+': (li_set) -> 
            '<ol>\n' + li_set + '</ol>\n'
        ,
        '(\\*)([\\s\\S]+?)\\1': '<i>$2</i>',
        '^##(.*)': '<h2>$1</h2>',
        '^#(.*)': '<h1>$1</h1>',
        # multi line quote
        '^>\\s([\\s\\S]*?\\n|.*?)$': '<p><blockquote>$1</blockquote></p>\n',
        # single line quote
        '^>\\s([\\s\\S]*?)$': '<p><blockquote>$1</blockquote></p>\n',
        '(\n\n)': '\n<p></p>\n'
    }


    # buildHTMLNode = (content, nodeType) ->
    #     # fallback to native browser functions for performance reasons
    #     # http://stackoverflow.com/questions/327047/what-is-the-most-efficient-way-to-create-html-elements-using-jquery
    #     element = $(document.createElement(nodeType))

    #     # set HTML node text
    #     element.text(content)

    #     # get the HTML node as pure string
    #     element.prop('outerHTML')
    

    # matchMDtoHTML = (markdownChunk) ->

    #     console.log markdownChunk
    #     transpiledHTMLChunk = ''
    #     for regExpPattern, nodeType of regExPatterns

    #         regExp = new RegExp(regExpPattern)

    #         console.log regExp + regExp.test(markdownChunk)

    #         # skip the rest of the loop if there is no match
    #         if regExp.test(markdownChunk) == false
    #             transpiledHTMLChunk = buildHTMLNode(markdownChunk, 'p')
    #             continue

    #         matchedTextGroups = regExp.exec(markdownChunk)

    #         # first value in matchedTextGroups is the entire input (including the markdown identifiers)
    #         # second value is the pure text

    #         matchedContent = matchedTextGroups[2]
    #         matchedContent

    #         #transpiledHTMLChunk = buildHTMLNode(matchedContent, nodeType)
            
    #         # we have successfully transpiled our HTML
    #         break
    #     return transpiledHTMLChunk

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
