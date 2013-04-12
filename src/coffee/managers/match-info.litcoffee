Match Info Manager
==================

We first set everything in a callback, so that it is invoked only after the
loading of the DOM.

    $ ->

Input
-----

We build the match info from the team DB, the scores, and the
current match.

        inputStream = Bacon.combineTemplate
            match: CurrentMatch
            scores: League.scores
            teams: Data.teams

Display Management
------------------

First, we bind up the current match ID display.

        inputStream.filter( (x) -> x.match? )
                   .map( (x) -> x.match.key )
                   .assign $('.match-id'), 'text'

For each zone, we bind up the relevant information points.

        for n in [0..3]
            do (n) ->
                ifTeams = inputStream.filter( (x) -> x.match? )
                                     .filter( (x) -> x.match.teams? )
                team = ifTeams.map( (x) -> x.teams[x.match.teams[n]] ?
                                           {name: x.match.teams[n]} )
                score = ifTeams.map( (x) -> x.scores[x.match.teams[n]] ? 0 )

The team name, college, points, and notes.

                team.map( (x) -> x.name  )
                    .assign $(".zone-#{n}-name"), 'text'
                team.map( (x) -> x.college ? x.name )
                    .assign $(".zone-#{n}-college"), 'text'
                team.map( (x) -> x.notes ? '' )
                    .assign $(".zone-#{n}-notes"), 'text'
                score.assign $(".zone-#{n}-points"), 'text'

