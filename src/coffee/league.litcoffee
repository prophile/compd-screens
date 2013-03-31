League Status
=============

The league status is a function of the completed matches. Completed
matches are themselves a function of a match schedule -- specifically,
a filter on those with defined outcomes (scores).

    completedMatches =
        Data.matchSchedule.map (matches) ->
            _.filter matches, (match) ->
                match.scores?

    completedMatches = completedMatches.toProperty []

It is also useful to have a common source combining the completed
matches and the team roster.

    dataSource =
        Bacon.combineTemplate
            matches: completedMatches
            teams: Data.teams

We publicise two properties under the *League* object - the
*leaderboard* and the *scores*.

Scores
------

The scores are a map from team IDs to their current league scores
- naturally, a map over the common data source.

First, we define the *teamScore* function, taking the list of
completed matches and a team as arguments.

    teamScore = (matches, team) ->

We first match scores to the score gained by this team from each
match.

        scores = (for match in matches
            if team not in match.teams
                0
            else
                match.scores[_.indexOf(match.teams, team)])

The total score is then simply a summation reduction over the
individual match scores.

        _.reduce scores, ( (a, b) -> a + b ), 0

The actual scores property makes use of the *teamScore* function,
looping over it for each present team.

    scores = dataSource.map (data) ->
        teams = (team for team, settings of data.teams when settings.present)
        _.object ([team, teamScore(data.matches, team)] for team in teams)

Finally the scores property is changed to avoid duplicates.

    scores = scores.skipDuplicates()

Leaderboard
-----------

The *leaderboard* is a list of entries, each of which contains:

* A team TLA,
* Its position on the leaderboard,
* Its score.

It is defined as a map over the scores.

    leaderboard = scores.map (teamScores) ->

We first take the team scores as [team, score] pairs, grouped by
score.

        _.chain(teamScores)
         .pairs()
         .groupBy( (x) -> x[1] )
         .pairs()

We then sort by score high to low and run a second simple grouping
pass -- yielding a list of [score, [team]] entries.

         .sortBy( (x) -> -x[0] )
         .map( (x) -> [x[0], _.map(x[1], (x) -> x[0])] )

We then run a reduction to assign leaderboard numbers.

         .reduce( ( (a, b) ->
             a.concat([1 + a.length, x, b[0]] for x in b[1]) ), [] )

Finally, a map pass converts to the desired output format.

         .map( (x) ->
            [position, team, score] = x
            {position: position, team: team, score: score} )
         .value()

The leaderboard is then filtered to remove duplicates.

    leaderboard = leaderboard.skipDuplicates()

Public Properties
-----------------

We publicise both the score table and the leaderboard.

    window.League =
        scores: scores
        leaderboard: leaderboard

