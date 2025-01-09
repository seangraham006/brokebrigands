#! /bin/bash

user_warriors=("Warrior1" "Warrior2" "Warrior3")
user_healths=(100 90 80)
user_hunger=50
user_damages=(10 15 20)

function view_warriors() {
    echo "Your Warriors:"
    for i in "${!user_warriors[@]}"; do
        echo "$((i+1)). ${user_warriors[i]} - Health: ${user_healths}, Damage: ${user_damages[i]}"
    done
    echo
}

view_warriors
