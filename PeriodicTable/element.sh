#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t -q --no-align -c"

ELEMENT_INFO(){
  # If no args, return out of function.
  if [[ -z "$1" ]]
  then
    echo -e 'Please provide an element as an argument.'
    return
  fi

  # Try to find match for input with SQL WHERE/OR
  # If input is integer search by number
  if echo "$1" | grep -E -q "[1-9]" 
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1;")
  #If input is string search by name or symbol
  elif echo "$1" | grep -E -q "[A-Z]*+"
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")
  fi
  
  # If all not found return error message and finish
  if [[ -z $ATOMIC_NUMBER ]]
  then 
    echo -e 'I could not find that element in the database.'
    return
  fi

  # If found, fetch and print element info
  ATOMIC_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number='$ATOMIC_NUMBER'")
  ATOMIC_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number='$ATOMIC_NUMBER'")
  ATOMIC_TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types USING(type_id) WHERE atomic_number='$ATOMIC_NUMBER'")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")

  echo -e "The element with atomic number $ATOMIC_NUMBER is $ATOMIC_NAME ($ATOMIC_SYMBOL). It's a $ATOMIC_TYPE, with a mass of $ATOMIC_MASS amu. $ATOMIC_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  
}

ELEMENT_INFO $1
