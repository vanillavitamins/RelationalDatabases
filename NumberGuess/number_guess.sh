#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
TARGET=$((1 + RANDOM % 1000))
TRIES=0

echo -e '\n~~ Number Guessing Game ~~\n'
echo Enter your username:
read USERNAME
GET_USER=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
# Print welcome message if new user
if [[ -z $GET_USER ]]; then
  echo -e "Welcome, $USERNAME! It looks like this is your first time here."
else
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME'")
  PREVIOUS_BEST=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME'")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $PREVIOUS_BEST guesses."
fi
echo Guess the secret number between 1 and 1000:

# Loop for guessing game
while true ;
do
  read GUESS
  while echo "$GUESS" | grep -E -q -i "[a-z]+" ; do
    echo That is not an integer, guess again:
    read GUESS
  done
  ((TRIES+=1))
  if [ "$GUESS" -eq "$TARGET" ]; then
    echo "You guessed it in $TRIES tries. The secret number was $TARGET. Nice job!"
    break
  elif [ "$GUESS" -gt "$TARGET" ]; then
    echo "It's lower than that, guess again:"
  elif [ "$GUESS" -lt "$TARGET" ]; then
    echo "It's higher than that, guess again:"
  #Remember to break out of loop
  fi

done

# Add user and stats to users
# If new user:
if [[ -z $GET_USER ]]; then
  INSERT_NEW=$($PSQL "INSERT INTO users(username, games_played, best_game) VALUES('$USERNAME', 1, $TRIES)")

# If existing user:
# Increment games played, compare TRIES to best game, UPDATE table
else

  ((GAMES_PLAYED+=1))
  NEW_BEST=$PREVIOUS_BEST
  if [ $TRIES -lt $PREVIOUS_BEST ]; then
    NEW_BEST=$TRIES
  fi
  UPDATE_USER=$($PSQL "UPDATE users SET games_played=$GAMES_PLAYED, best_game=$NEW_BEST WHERE username='$USERNAME'")

fi

test=1
