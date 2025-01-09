warrior() {
    # $1 = number of warriors, $2 = "true" if you want to enter names, "false" otherwise
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

    if [[ -f "user_warriors" ]]; then
	    rm "user_warriors"
    fi

    for warrior in "${warriors[@]}"; do
	    echo $warrior >> user_warriors
	done
}
