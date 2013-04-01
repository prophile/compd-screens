Identity
========

Each screen has an *identifier*, a short string indicating its identity.

The following identities are examples that could be used:
* arena-door
* arena-zone-0
* arena-zone-1
* arena-zone-2
* arena-zone-3
* judge-1
* judge-2
* overheads
* staff-1
* staff-2

Property
--------

The screen's identity is published in the *Identity* property. This
is moderated with the *identityBus* bus.

    identityBus = new Bacon.Bus()
    window.Identity = identityBus.toProperty undefined

Identity Announcement
---------------------

When the screen's identity is set, it must announce this over WS
to the server.

    Identity.changes()
            .filter( (x) -> x? )
            .onValue (identity) ->
                WS.send 'iam', screen: identity

Identity Prompt
---------------

If necessary, the system will prompt the user to enter a screen
identity. This is triggered by sending a message to the *IdentityPropmt*
bus.

    window.IdentityPrompt = new Bacon.Bus()

For simplicity, we simply use a synchronous prompt() call for the prompt.

    window.IdentityPrompt.onValue ->
        selectedIdentity = prompt "Please enter the screen's identity."
        identityBus.push selectedIdentity

Identity Storage and Recovery
-----------------------------

The screen's identity is stored in client-local storage, and can
be automatically recovered upon reopening.

First, we set up storage.

    Identity.changes()
            .filter( (x) -> x? )
            .onValue (identity) ->
                localStorage.screenIdentity = identity

Then, after the DOM loading, we recover the identity if we can.
Otherwise, we prompt for the identity to be entered.

    $ ->
        recoveredIdentity = localStorage.screenIdentity
        if recoveredIdentity?
            identityBus.push recoveredIdentity if recoveredIdentity?
        else
            do IdentityPrompt.push



