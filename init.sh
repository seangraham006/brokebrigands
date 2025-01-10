#! /bin/bash
init() {

	if [[ -f "user_data" ]]; then
		rm "user_data"
	fi

	hunger=50
	money=100

	echo "$hunger,$money" > user_data
}

get_hunger() {
	hunger=$(awk -F, 'NR==1 {print $1}' user_data)
	echo "$hunger"
}

get_money() {
	money=$(awk -F, 'NR==1 {print $2}' user_data)
	echo "$money"
}

set_money() {
    local new_money=$1
    local hunger=$(get_hunger)
    echo "$hunger,$new_money" > user_data
}

set_hunger() {
    local new_hunger=$1
    local money=$(get_money)
    echo "$new_hunger,$money" > user_data
}
