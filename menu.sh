#! /bin/bash

source ./init.sh
source ./characters.sh
source ./view_warriors.sh
source ./shops.sh
source ./fight_bandits.sh

#data in init stored hunger,money

days=0

init

hunger=$(get_hunger)
money=$(get_money)

warrior 1 "true"
warrior 2 "false"
while (( money < 500 ))
do
	((day+=1))
	baronTask=false
	
	while true; do
		hunger=$(get_hunger)
		money=$(get_money)

		# Display Options
        	echo -e "\n-----  Starting Day ${day}  -----"
		echo -e "\nMoney: $money | Hunger: $hunger"
        	echo -e "\n1 View Warriors\n2 Fight Bandits\n3 Go to the Shop\n4 Hire Warrior"
        	[[ $baronTask == true ]] && echo -e "5 Complete Baron's Task\n6 Attack Baron\n7 Quit" || echo "5 Quit"
		
		echo
		read -p "Enter your choice: " ch
		case $ch in 
			1)
				echo "View Warriors"
				view_warriors user;;
			2)
				echo "Fight Bandits"
				fight_bandits $money
				echo "$?"
				echo "money: $money"
				break;;
			3)
				echo "Go to Shop"
				shop;;
			4)
				echo "Hire Warrior"
				break;;
			5)
				if [[ $baronTask == false ]]; then
					echo "Quitting"
				else
					echo "Complete Baron Task"
				fi
				break;;
			6)	
				if [[ $baronTask == true ]]; then
					echo "Attack Baron"
					break
				else
					echo "Invalid Option"
				fi;;
			7)
				if [[ $baronTask == true ]]; then
					echo "Quitting"
					break
				else
					echo "Invalid Option"
				fi;;
			*)
				echo "Invalid Option";;
		esac
	done	
done
