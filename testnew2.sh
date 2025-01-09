#!/bin/bash

# Initialize game variables
user_money=50
user_warriors=()
enemy_warriors=()
user_hunger=50

function warrior() {
    warriors=()

    for i in $(seq 1 $1); do
        health=$((RANDOM % 50 + 50))
        damage=$((RANDOM % 5 + 5))

        if [[ "$2" == "true" ]]; then
            read -p "Enter warrior's name: " name
        else
            name="Unknown"
        fi

        warriors+=("$health,$damage,$name")
    done

    echo "${warriors[@]}"
}


# Function to view user warriors
view_warriors() {
    if [[ ${#user_warriors[@]} -eq 0 ]]; then
        echo "You have no warriors!"
    else
        echo "Your Warriors:"
        for warrior in "${user_warriors[@]}"; do
            IFS=',' read -r health damage name <<< "$warrior"
            echo "Name: $name, Health: $health, Damage: $damage"
        done
    fi
    echo
}

# Function to handle battles
resolve_fight() {
    local user_health=0
    local user_damage=0

    for warrior in "${user_warriors[@]}"; do
        IFS=',' read -r health damage name <<< "$warrior"
        user_health=$((user_health + health))
        user_damage=$((user_damage + damage))
    done

    local enemy_health=0
    local enemy_damage=0

    for warrior in "${enemy_warriors[@]}"; do
        IFS=',' read -r health damage name <<< "$warrior"
        enemy_health=$((enemy_health + health))
        enemy_damage=$((enemy_damage + damage))
    done

    local turn=$((RANDOM % 2))
    while [[ "$user_health" -gt 0 && "$enemy_health" -gt 0 ]]; do
        if [[ "$turn" -eq 0 ]]; then
            enemy_health=$((enemy_health - user_damage))
            turn=1
        else
            user_health=$((user_health - enemy_damage))
            turn=0
        fi
    done

    if [[ "$user_health" -gt 0 ]]; then
        local reward=$((RANDOM % 20 + 10))
        user_money=$((user_money + reward))
        echo "Victory! You earned $reward coins."
    else
        echo "Defeat! Your warriors suffered greatly."
        for i in "${!user_warriors[@]}"; do
            IFS=',' read -r health damage name <<< "${user_warriors[i]}"
            local new_health=$((health - 20))
            if [[ "$new_health" -le 0 ]]; then
                echo "${name} has perished in battle."
                user_warriors[i]=""
            else
                user_warriors[i]="$new_health,$damage,$name"
            fi
        done
        user_warriors=("${user_warriors[@]/}")
    fi
    echo
}

function fight_bandits() {
    echo "Available Bandit Groups:"
    echo "1. Group A - Number of Warriors: 2"
    echo "2. Group B - Number of Warriors: 3"
    echo "3. Group C - Number of Warriors: 4"
    read -p "Choose a group to fight (1-3): " group_choice

    case $group_choice in
        1) enemy_warriors=$(warrior 2 false) ;;
        2) enemy_warriors=$(warrior 3 false) ;;
        3) enemy_warriors=$(warrior 4 false) ;;
        *) echo "Invalid choice!"; return ;;
    esac

    echo "Enemy Group Details:"
    for enemy in $enemy_warriors; do
        IFS=',' read -r health damage name <<< "$enemy"
        echo "Name: $name, Health: $health, Damage: $damage"
    done

    read -p "Do you want to forfeit? (yes/no): " forfeit_choice
    if [[ "$forfeit_choice" == "yes" ]]; then
        echo "You chose to forfeit the fight."
        return
    fi

    resolve_fight "$enemy_warriors"
}


shop() {
    echo "Welcome to the Shop!"
    echo "1. Buy Food (10 coins) - Reduce hunger by 20"
    echo "2. Buy Bandages (15 coins) - Heal a warrior by 20 health"
    read -p "Choose an option (1-2): " choice

    case "$choice" in
        1)
            if [[ "$user_money" -ge 10 ]]; then
                user_hunger=$((user_hunger - 20))
                user_money=$((user_money - 10))
                echo "You bought food. Hunger reduced by 20."
                reduce_hunger_this_turn=true
            else
                echo "Not enough money!"
            fi
            ;;
        2)
            if [[ "$user_money" -ge 15 ]]; then
                if [[ ${#user_warriors[@]} -eq 0 ]]; then
                    echo "You have no warriors to heal!"
                else
                    echo "Choose a warrior to heal:"
                    for i in "${!user_warriors[@]}"; do
                        IFS=',' read -r health damage name <<< "${user_warriors[i]}"
                        echo "$((i+1)). Name: $name, Health: $health, Damage: $damage"
                    done
                    read -p "Enter the number of the warrior to heal: " index
                    index=$((index - 1))

                    if [[ "$index" -ge 0 && "$index" -lt "${#user_warriors[@]}" ]]; then
                        IFS=',' read -r health damage name <<< "${user_warriors[index]}"
                        health=$((health + 20))
                        user_warriors[index]="$health,$damage,$name"
                        user_money=$((user_money - 15))
                        echo "$name healed by 20 health."
                    else
                        echo "Invalid choice!"
                    fi
                fi
            else
                echo "Not enough money!"
            fi
            ;;
        *)
            echo "Invalid choice!"
            ;;
    esac
    echo
}

# Function to hire warriors
hire_warrior() {
    if [[ "$user_money" -lt 20 ]]; then
        echo "Not enough money to hire a warrior!"
        return
    fi

    read -p "Enter the name of your new warrior: " name
    local health=$((RANDOM % 50 + 50))
    local damage=$((RANDOM % 5 + 5))
    user_warriors+=("$health,$damage,$name")
    user_money=$((user_money - 20))
    echo "$name has joined your group! Health: $health, Damage: $damage"
    echo
}

# Main menu function
main_menu() {
    while true; do
        reduce_hunger_this_turn=false
        echo "-----  Broke Brigands  -----"
        echo "Money: $user_money | Hunger: $user_hunger"
        echo "1. View Warriors"
        echo "2. Fight Bandits"
        echo "3. Go to the Shop"
        echo "4. Hire Warrior (20 coins)"
        echo "5. Quit"

        read -p "Enter your choice: " choice

        case "$choice" in
            1) view_warriors ;;
            2) fight_bandits ;;
            3) shop ;;
            4) hire_warrior ;;
            5) echo "Thanks for playing!"; break ;;
            *) echo "Invalid choice! Please try again." ;;
        esac

        if [[ "$reduce_hunger_this_turn" == "false" ]]; then
            user_hunger=$((user_hunger + 10))
        fi

        if [[ "$user_hunger" -ge 100 ]]; then
            echo "Your warriors are starving! Health is being reduced."
            for i in "${!user_warriors[@]}"; do
                IFS=',' read -r health damage name <<< "${user_warriors[i]}"
                health=$((health - 10))
                [[ "$health" -le 0 ]] && user_warriors[i]=""
                user_warriors[i]="$health,$damage,$name"
            done
            user_warriors=("${user_warriors[@]/}")
        fi
        echo
    done
}

# Start the game
echo "Welcome to Broke Brigands!"
user_warriors=($(warrior 1 true))
main_menu

