
# Modes

* Arena Entrance
* Arena Zone
* Blank
* Emergency
* Default
* General Info
* Judge
* Override

## Arena Entrance

* 'Arena' sign
* Layout of upcoming match (between matches) TODO
* No entry (during matches)
* Blank during awards

## Arena Zone

* Default (non-match)
* Colour, match timer & team name TODO

## Blank

* White page

## Emergency

* No entry sign (overlay onto others, doesn't apply to Judge's desk)
* TODO: make this mode work

## Default

* SR logo
* Clock (BST)

## General Info

* Rotates 12s intevals:
 * Match schedule
  * Match Number (TODO)
  * Time of match (BST)
  * Entrants (team name imported from Team Status)
 * Day schedule
  * Times (BST)
  * Event
 * Knockout tree (only during knockout) TODO
 * League status (only during league)
* Blank (during awards)

## Judge

* Six selections, selected via key press (1-6):
 1. Match Status:
  * Match time (offset from start time, up to 3:00)
  * Match number
  * Teams in the match: TODO (all of this bit)
   * Name (from Team Status)
   * College
   * Notes
   * League position & points (TODO)
 2. Match Schedule (as for the General Info screen)
 3. League Status (as for the General Info screen)
 4. Knockout Tree (as for the General Info screen) TODO
 5. Day Schedule (as for the General Info screen)
 6. Next match: FIXME
  * Team names
  * Start time (BST)

## Override

* Free form HTML
* Set via compd `screen-override` & `screen-clear-override`

# Control

When a screen is first started, it asks for an identity.
This is stored in HTML5 local storage, and can be an arbitrary string,
 eg: _arena-south_

The mode that a screen has is then set via compd `screen-set-mode`, such
that any screen can be made to show anything.
