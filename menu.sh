#! /bin/bash
source ./characters.sh
days=0
money=0
hunger=50
readarray -t userwarriors < <(warrior 1 true)
#userwarriors holds all of the user's warriors
while (( money < 500 ))
do
	((day+=1))
	baronTask=false
	
	# Display Options
	echo -e "\n-----  Starting Day ${day}  -----"
	echo -e "\n1 View Warriors\n2 Fight Bandits\n3 Go to the Shop\n4 Hire Warrior"
	[[ $baronTask == true ]] && echo -e "5 Complete Baron's Task\n6 Attack Baron\n7 Quit" || echo "5 Quit"
	
	while true; do
		read -p "Enter your choice: " ch
		case $ch in 
			1)
				echo "View Warriors";;
			2)
				echo "Fight Bandits"
				break;;
			3)
				echo "Go to Shop";;
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
	(( money += 250 ))
	

done
