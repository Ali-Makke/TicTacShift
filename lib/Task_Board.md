# TO DO Reminders before submission

*** add back main file without api key
*** separately send back configuration file
*** separately send back api key(s)

# {*(important) -(less important)}
# To DO:

    *In the onlineGame file:
        *dispose listner when player exits the game or when player hasWon
        *add timers
        *change the board state to be an array with all match state(to use for player game play history)
    *Learn 'dispose' and use it if applicable
    -Check all firebase connections
    -checkout more firebase features and also learn to use 'firebase auth exeptions'
    -check overall project structure
    -check hosting details
    -don't let user send more then 5 challenge links within an hour unless the link was opened
    -check label in the settings button in the home_page 
    -add sound effects(in game)
    -user can add avatar
    -make last third move a different color or make hover effect
    *design REST sercive api to MySQL database
    *implement REST sercive api to MySQL database into app
    -implement ai match
    -

# In Progress:

    ***
    ---------- FIX MAJOR BUG IN USERMODEL CONSTRUCTION ------------
    ***
    *implement game history
    *create relational database tables
    -what are the edge cases(eg: what happens if the player disconnects mid_game)
    *implement game logic
        *implement invite friend match
    -

# Review/Test:

    -Test loading screens
    -Trace null values throughout the app lifetime
    -Encapsulate variables
    -
    -

# Done:
    *add page to search for players and add friends
    *implement search for player
    *Design and create app/game database
    -Make basic project file structure
    *Configure and connect to FireBase
    *Implement firebase auth service
    *Implement firebase signin and register forms
    -Add flutter_spinkit loading animation
    *Connect and use the realtime cloud firestore database
    *implement local match
    *implement online match
    *plan game code structure and logic
    -Briefly understand how firebase datebase works(It uses a NoSQL database)
    -decide what lets the player climb the leaderboard(find it at the end of this file)
    *make usernames unique
    -fix form validation
    -
    -
    -

Database initial planning:
-a login and sign up, both anonymously and by email and password.
    -i made a special notation to represent the board state.
    -each player has a timer to play for the whole game(eg: 5 min for each player for the whole match).
    -save the user details like their username, id(so players can invite each other).
-make a leader board.
    -players should be able to send a challenge link to other players.
    -Each player can see their statistics.

leaderboard:
iI has score points, the faster you can win a game the higher your score in that game.