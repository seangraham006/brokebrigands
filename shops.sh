#!/bin/bash


function shop() {
    echo "Shop:"
    echo "1. Buy Food (10 coins)"
    echo "2. Buy Bandages (15 coins)"
    read -p "Choose an option: " choice

    if [[ "$choice" == "1" ]]; then
        if [[ "$user_money" -ge 10 ]]; then
            user_hunger=$((user_hunger - 10))
            user_money=$((user_money - 10))
            echo "You bought food."
        else
            echo "Not enough money!"
        fi
    elif [[ "$choice" == "2" ]]; then
        if [[ "$user_money" -ge 15 ]]; then
            echo "Choose warrior to heal (1-${#user_warriors[@]}):"
            read warrior_index
            warrior_index=$((warrior_index - 1))
            if [[ "$warrior_index" -ge 0 && "$warrior_index" -lt "${#user_warriors[@]}" ]]; then
                user_healths[warrior_index]=$((user_healths[warrior_index] + 20))
                user_money=$((user_money - 15))
                echo "${user_warriors[warrior_index]} healed."
            else
                echo "Invalid choice!"
            fi
        else
            echo "Not enough money!"
        fi
    else
        echo "Invalid choice!"
    fi
    echo
}
