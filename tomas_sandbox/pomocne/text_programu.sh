#!/bin/bash
# Potřeba zpouštět z adresáře, kde je food_manager.sh
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "./food_manager.sh --empty_database"
./food_manager.sh --empty_database
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "./food_manager.sh --show a"
./food_manager.sh --show a
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "./food_manager.sh --insert fridge vstupni_soubory/foods.txt"
./food_manager.sh --insert fridge vstupni_soubory/foods.txt
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "./food_manager.sh --show a"
./food_manager.sh --show a
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "./food_manager.sh --insert recipes vstupni_soubory/recipe.txt"
./food_manager.sh --insert recipes vstupni_soubory/recipe.txt
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "./food_manager.sh --show a"
./food_manager.sh --show a
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "./food_manager.sh --query recipes Conan,Kendrick"
./food_manager.sh --query recipes Conan,Kendrick
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "./food_manager.sh --debug --query shortest 2015-07-12"
./food_manager.sh --debug --query shortest 2015-07-12
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "./food_manager.sh --debug --query buy \"ham and eggs, Kenneth, McAvoy\""
./food_manager.sh --debug --query buy "ham and eggs, Kenneth, McAvoy"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
echo "./food_manager.sh --debug --query buy \"steak,,\""
./food_manager.sh --debug --query buy "steak,,"
echo "|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
