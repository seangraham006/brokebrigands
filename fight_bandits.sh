#! /bin/bash
source ./characters.sh
source ./view_warriors.sh
source ./resolve_fight.sh
source ./init.sh

forfeit_money_penalty=30

function fight_bandits() {
	user_money=$1

	echo -e "\nAvailable Bandit Groups:"
	echo
	echo "1. Number of Warriors: 2"
	echo "2. Number of Warriors: 3"
	echo -e "3. Number of Warriors: 4\n "
	read -p "Choose a group to fight (1-3): " ch

	case $ch in
		1) warrior 2 false ;;
		2) warrior 3 false ;;
		3) warrior 4 false ;;
		*) echo "Invalid choice!"; return ;;
	esac
	
	view_warriors user
	echo -e "vs\n"
	view_warriors enemy

	read -p "Do you want to forfeit? (yes/no): " forfeit_choice
	if [[ "$forfeit_choice" == "yes" ]]; then
		echo -e "\nYou chose to forfeit"
		(( user_money - forfeit_money_penalty < 0 )) && user_money=0 || (( user_money -= forfeit_money_penalty ))
		set_money $user_money
	else
		resolve_fight $user_money
	fi
}
