#! /bin/bash
source ./characters.sh
source ./view_warriors.sh

function fight_bandits() {
	echo "Available Bandit Groups:"
	echo "1. Group A - Number of Warriors: 2"
	echo "2. Group B - Number of Warriors: 3"
	echo "3. Group C - Number of Warriors: 4"
	read -p "Choose a group to fight (1-3): " ch

	case $ch in
		1) warrior 2 false ;;
		2) warrior 3 false ;;
		3) warrior 4 false ;;
		*) echo "Invalid choice!"; return ;;
	esac

	view_warriors enemy

	read -p "Do you want to forfeit? (yes/no): " forfeit_choice
	if [[ "$forfeit_choice" == "yes" ]]; then
		forfeit
	fi
	#resolve_fight "$enemy_warriors"
}

function forfeit() {
	echo "You chose to forfeit the fight."
}
