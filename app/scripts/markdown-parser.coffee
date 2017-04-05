@MarkdownParser = (->
    
    # this block describes regular expressions that identify a 
    # particular markdown pattern (e.g. ** for bold  text) and 
    # reference a valid HTML Node type (e.g. strong for bold HTML nodes)

    regExPatterns = { 
        '^(\\*\\*)([\\s\\S]+?)\\1': 'strong',
        '^\\*(.*?)\\*': 'i',
        '^##(.*)': 'h2',
        '^#(.*)': 'h1'
    }

    buildHTMLNode = (content, nodeType) ->
        # fallback to native browser functions for performance reasons
        # http://stackoverflow.com/questions/327047/what-is-the-most-efficient-way-to-create-html-elements-using-jquery
        element = $(document.createElement(nodeType))

        # set HTML node text
        element.text(content)

        # get the HTML node as pure string
        element.prop('outerHTML')
    

    matchMDtoHTML = (markdownChunk) ->

        console.log markdownChunk
        transpiledHTMLChunk = ''
        for regExpPattern, nodeType of regExPatterns

            regExp = new RegExp(regExpPattern)

            console.log regExp + regExp.test(markdownChunk)

            # skip the rest of the loop if there is no match
            if regExp.test(markdownChunk) == false
                transpiledHTMLChunk = buildHTMLNode(markdownChunk, 'p')
                continue

            matchedTextGroups = regExp.exec(markdownChunk)

            # first value in matchedTextGroups is the entire input (including the markdown identifiers)
            # second value is the pure text

            matchedContent = matchedTextGroups[2]
            matchedContent

            transpiledHTMLChunk = buildHTMLNode(matchedContent, nodeType)
            
            # we have successfully transpiled our HTML
            break
        return transpiledHTMLChunk

    parse = (markdownCode) ->
        # we read the markdownCode and treat a line break as 'stop word'
        # i.e. after a line break there begins a new block

        # a RegExp for detecting line breaks
        linebreakRegExp = new RegExp(/[^\n]+/g)

        # the new HTML code 
        transpiledHTMLOutput = ''

        # split the markdownCode into chunks
        markdownChunks = markdownCode.match(linebreakRegExp)
        
        # iterate through the markdownChunks and transpile them to HTML
        for markdownChunk in markdownChunks
            transpiledHTMLOutput += matchMDtoHTML(markdownChunk) + '\n'

        transpiledHTMLOutput

    {
        parse: parse
    })()
