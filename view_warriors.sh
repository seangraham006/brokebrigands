#! /bin/bash

function view_warriors() {
	echo -e "Your Warriors:\n"
	count=0
    	while IFS= read -r warrior; do
		((count++))
		name=$(echo $warrior | awk '{print $3}')
		health=$(echo $warrior | awk '{print $1}')
		damage=$(echo $warrior | awk '{print $2}')

		echo -e "$count. $name - Health: $health  Attack Power: $damage"
    	done < user_warriors

    	echo
}
