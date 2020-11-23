#!/bin/bash
RESTORE='\033[0m'
RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\e[0;33m'
PROJECT='parking-management-api'

function devhelp {
    echo -e "${RED}DEVELOPMENT ENVIRONMENT SETUP INSTRUCTIONS AND HELPERS${RESTORE}"
    echo -e ""
    echo -e "${GREEN}devhelp${RESTORE}                Print this ${RED}helper${RESTORE}"
    echo -e ""
    echo -e "${GREEN}dksetup${RESTORE}                ${RED}INSTALL DOCKER PROJECT${RESTORE} and create databases"
    echo -e ""
    echo -e "${GREEN}dkbuild${RESTORE}                ${RED}Create docker image${RESTORE} from project"
    echo -e ""
    echo -e "${GREEN}dbsetup${RESTORE}                ${RED}Create databases${RESTORE} and run migrations"
    echo -e ""
    echo -e "${GREEN}dkupa${RESTORE}                  ${RED}Start docker containers${RESTORE}"
    echo -e ""
    echo -e "${GREEN}dkupd${RESTORE}                  ${RED}Start docker containers${RESTORE} with detached mode"
    echo -e ""
    echo -e "${GREEN}dka${RESTORE}                    ${RED}Attach${RESTORE} your terminal to application container"
    echo -e ""
    echo -e "${GREEN}dkc${RESTORE}                    ${RED}Open rails console${RESTORE} on application container"
    echo -e ""
    echo -e "${GREEN}dkexec <command>${RESTORE}       ${RED}Run a <command>${RESTORE} on application container"
    echo -e ""
    echo -e "${GREEN}dkexec bash${RESTORE}            ${RED}Open a bash${RESTORE} on application container"
    echo -e ""
    echo -e "${GREEN}dkexec rspec${RESTORE}           ${RED}Run tests${RESTORE} on application container"
    echo -e ""
    echo -e "${GREEN}dkdown${RESTORE}                 ${RED}Stop${RESTORE} all project containers"
    echo -e ""
}

function dksetup {
  dkbuild
  dbsetup
  exitcode=$?
  return $exitcode
}

function dkbuild {
  docker-compose build
  exitcode=$?
  return $exitcode
}

function dkupd {
  rm_server_pid
  docker-compose up -d
  exitcode=$?
  return $exitcode
}

function dkupa {
  rm_server_pid
  docker-compose up
  exitcode=$?
  return $exitcode
}

function dkdown {
  docker-compose down
  exitcode=$?
  return $exitcode
}

function dkexec {
  docker exec -it parking_management_app $1
  exitcode=$?
  return $exitcode
}

function dkc {
  docker exec -it parking_management_app bundle exec rails c
  exitcode=$?
  return $exitcode
}

function dka {
  docker attach parking_management_app
  exitcode=$?
  return $exitcode
}

function dbsetup {
  rm_server_pid
  docker-compose up
  docker exec -it parking_management_app bundle exec rails db:create
  docker exec -it parking_management_app bundle exec rails db:migrate
  exitcode=$?
  return $exitcode
}

function rm_server_pid {
  sudo rm -rf tmp/pids/server.pid
}

# Helper color functions

function echo_red {
  echo -e "${RED}$1${RESTORE}";
}

function echo_green {
  echo -e "${GREEN}$1${RESTORE}";
}

function echo_yellow {
  echo -e "${YELLOW}$1${RESTORE}";
}

echo_green "Welcome to ${PROJECT} setup"
echo_red   "-------------------------------------------------"
devhelp
