#! /bin/bash

function view_warriors() {
	echo -e "Your Warriors:\n"
	count=0
    	for warrior in "$@"; do
		((count++))
		warrior_no_quotes=$(echo "$warrior" | sed 's/"//g')
		name=$(echo $warrior_no_quotes | awk -F, '{print $3}')
		health=$(echo $warrior_no_quotes | awk -F, '{print $1}')
		damage=$(echo $warrior_no_quotes | awk -F, '{print $2}')

		echo -e "$count. $name - Health: $health  Attack Power: $damage"
    	done
    	echo
}
