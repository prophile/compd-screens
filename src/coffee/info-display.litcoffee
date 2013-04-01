Information Display Helper
==========================

The ID helper abstracts away some details of interaction with D3
by exposing a single method, *DisplayInformation*.

It takes, as its arguments:

* A selector for the containing DOM node,
* An array of data to display,
* The DOM node type for the rows (typically 'tr' or 'li'),
* The HTML-generating callback, taking the data as an argument,
* An optional 'post' callback, to add additional D3 actions.

    window.DisplayInformation = (container, data, rowType, genHTML, post) ->
        post = (x) -> x unless post?

First, we construct the actual D3 nodes structure.

        tableNodes = d3.select(container)
                       .selectAll(rowType)
                       .data(data)

We first apply the update to all nodes which are being modified.

        post(tableNodes.html(genHTML))

We then apply the update to incoming nodes.

        post(tableNodes.enter()
                       .append('tr')
                       .html(genHTML))

We finally remove all extraneous nodes.

        tableNodes.exit().remove()

