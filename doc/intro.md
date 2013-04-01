Compd-Screens Annotated Source
==============================

HTML
----

The full HTML for the displays is within *src/index.html*. Almost
all the HTML is in the page to begin with, and is shown or hidden
as need be - various minor bits and pieces are done using Handlebar
templates which are also defined within *index.html*.

Literate CoffeeScript
---------------------

The client-side code, which is what is shown in this document, is
written in Literate CoffeeScript. CoffeeScript is a language similar
to JavaScript but generally cleaned up, and compiles down to
JavaScript. Literate CoffeeScript is a dialect of CoffeeScript based
on the Literate Programming principle, where the code is interspersed
into Markdown documentation, from which this document is compiled.

Bacon
-----

The displays make heavy use of Bacon.js. Bacon is a FRP (functional
reactive programming) system, which works extremely well for reacting
to changing data with many moving parts.

WS and Data
-----------

The first part of this document -- and thus, source base -- concerns
the WebSocket that communicates between this client and the server,
and the basic data contained therein. These data are kept in Bacon.js
Properties, in order that anything that relies on them should update
immediately.

Managers
--------

The second part of this document and source base concerns the
*managers*. These are the modules of code that actually manage what
is displayed on the page.

