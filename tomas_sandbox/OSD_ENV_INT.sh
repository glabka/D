#!/bin/bash
# Potřeba spustit jako "source ./OSD_ENV_INT.sh"
# (shodné jako ". ./OSD_ENV_INT.sh"), aby se vytvořené proměnné OSD_DB a další
# "zachoavly" i po skončení skriptu
# source == Read and execute commands from filename in the current shell environment and return the exit status of the last command executed from  filename. Více viz man bash
read -p "Zadejte jméno databáze: " OSD_DB #-p == Display  prompt  on standard error, without a trailing newline, before attempting to read any input.
export OSD_DB #aby se to stalo součástí environmentu, tudíž to bude děděno dceřinými processy.
read -p "Zadejte uživatelské jméno: " OSD_USERNAME
export OSD_USERNAME
read -s -p "Zadejte heslo: " export OSD_PASSWORD #-s == Silent mode.  If input is coming from a terminal, characters are not echoed. 
echo ""
