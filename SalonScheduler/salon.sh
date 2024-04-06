#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~ Salon Appointment Booker ~~"

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\nHere are the services we offer:"
  echo -e "\n1) cut\n2) colour\n3) style"

  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) MAKE_APPOINTMENT "$SERVICE_ID_SELECTED" ;;
    2) MAKE_APPOINTMENT "$SERVICE_ID_SELECTED" ;;
    3) MAKE_APPOINTMENT "$SERVICE_ID_SELECTED" ;;
    *) MAIN_MENU "Please select a valid option."
  esac
}

MAKE_APPOINTMENT(){
  echo -e "\nPlease enter your phone number:"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  # If number not in db ask for name, insert both
  if [[ -z $CUSTOMER_NAME ]]
  then  
    echo -e "\nPlease enter your name:"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi

  #Ask for time
  echo -e "\nPlease enter a time for your appointment:"
  read SERVICE_TIME

  # Insert into appointments
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")

  # Print confirmation message
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

}

MAIN_MENU
