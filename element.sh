#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument is provided
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# Query the database
RESULT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, 
       p.melting_point_celsius, p.boiling_point_celsius 
FROM elements e
INNER JOIN properties p ON e.atomic_number = p.atomic_number
INNER JOIN types t ON p.type_id = t.type_id
WHERE e.atomic_number::TEXT = '$1' OR e.symbol = '$1' OR e.name = '$1';")

# Check if the result is empty
if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
else
  # Read result into variables
  echo "$RESULT" | while IFS='|' read -r ATOMIC_NUM NAME SYMBOL TYPE MASS MELTING BOILING; do
    echo "The element with atomic number $ATOMIC_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
fi
