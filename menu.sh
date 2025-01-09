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

warrior 3 "true"

quit="false"

while (( money < 500 ))
do
	((day+=1))
	baronTask=false
	
	num_warriors=$(wc -l < "user_warriors")
	
	new_hunger=$((hunger + (num_warriors * 3)))
	
	

	hunger=$(set_hunger "$new_hunger")	
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
		echo
		case $ch in 
			1)
				echo "View Warriors"
				view_warriors user;;
			2)
				echo "Fight Bandits"
				fight_bandits
				break;;
			3)
				echo "Go to Shop"
				shop;;
			4)
				echo "Hire Warrior"
				echo -e "\n1 warrior costs 40 coins"
				if (( money < 40 )); then
					echo "Sorry you don't have enough for a warrior"
				else
					read -p "How many warriors do you want: " qty
					hire_warrior "$qty"
				fi;;
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
