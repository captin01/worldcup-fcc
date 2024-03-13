#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE games, teams")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # populating the teams table
  if [[ $WINNER != winner && $OPPONENT != opponent ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    if [[ -z $WINNER_ID ]]
    then
      TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
      if [[ $TEAM_NAME == "INSERT 0 1" ]]
      then
        echo Inserting to teams table, $WINNER
      fi
    fi
    
    if [[ -z $OPPONENT_ID ]]
    then
      TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
      if [[ $TEAM_NAME == "INSERT 0 1" ]]
      then
        echo Inserting to teams table, $OPPONENT
      fi
    fi
  fi

  # populating the games table
  if [[ $YEAR != year ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    
    # inserting data into games table
    GAME_RESULT=$($PSQL "INSERT INTO games(year, winner_id, opponent_id, winner_goals, opponent_goals, round) VALUES ($YEAR, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS, '$ROUND')")
    if [[ $GAME_RESULT == "INSERT 0 1" ]]
    then
      echo Inserting data into games table, $WINNER vs $OPPONENT
    fi
  fi
done
