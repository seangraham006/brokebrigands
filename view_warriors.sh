#! /bin/bash

function view_warriors() {
	case $1 in
		user) message="Your Warriors:"; filename=user_warriors;;
		enemy) message="Enemy Warriors:"; filename=enemy_warriors;;
		*) echo "view_warriors() must accept user or enemy"; break;;
	esac
	echo "$message $filename"
	echo -e "$message\n"
	count=0
    	while IFS= read -r warrior; do
		((count++))
		name=$(echo $warrior | awk '{print $3}')
		health=$(echo $warrior | awk '{print $1}')
		damage=$(echo $warrior | awk '{print $2}')

		echo -e "$count. $name - Health: $health  Attack Power: $damage"
    	done < "$filename"

    	echo
}
