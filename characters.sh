source ./init.sh
source ./view_warriors.sh

warrior() {
	# $1 = number of warriors, $2 = "true" for the user of false for the enemy/baron
	
	warriors=()
    
	for i in $(seq 1 $1); do
		health=$((RANDOM % 50 + 50))
		damage=$((RANDOM % 5 + 5))

		if [[ "$2" == "true" ]]; then
		    read -p "Enter warrior's name: " name
		else
		    name="Unknown Enemy"
		fi

		warriors+=("$health $damage $name")
	done
	
	if [[ "$2" == "true" ]]; then
		
		if [[ -f "user_warriors" ]]; then
			rm "user_warriors"
		fi

		for warrior in "${warriors[@]}"; do
			echo $warrior >> user_warriors
		done
	else
		if [[ -f "enemy_warriors" ]]; then
			rm "enemy_warriors"
		fi

		for warrior in "${warriors[@]}"; do
                        echo $warrior >> enemy_warriors
                done
	fi
}

hire_warrior() {
        # $1 = number of warriors, $2 = "true" for the user of false for the enemy/baron

	warrior_cost="40"
        warriors=()
	user_money=$(get_money)
	qty="$1"
	count=0

	while (( user_money - warrior_cost >= 0 && count < qty)); do
		(( user_money -= warrior_cost))
		(( count++ ))

                health=$((RANDOM % 50 + 50))
                damage=$((RANDOM % 5 + 5))

                read -p "Enter warrior's name: " name

                warriors+=("$health $damage $name")
        done

	if (( count == qty )); then
		echo "$count warriors hired!!"
	else
		echo "Sorry you ran out of money.  $count warriors hired."
	fi

	for warrior in "${warriors[@]}"; do
		echo $warrior >> user_warriors
	done

	set_money "$user_money"

	view_warriors user
}
