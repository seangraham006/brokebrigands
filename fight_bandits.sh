#! /bin/bash

source ./characters.sh

resolve_fight() {
    user_total_health=0
    user_total_damage=0

    for warrior in "${user_warriors[@]}"; do
        IFS=',' read -r health damage name <<< "$warrior"
        user_total_health=$((user_total_health + health))
        user_total_damage=$((user_total_damage + damage))
    done

    enemy_total_health=0
    enemy_total_damage=0

    for warrior in "${enemy_warriors[@]}"; do
        IFS=',' read -r health damage name <<< "$warrior"
        enemy_total_health=$((enemy_total_health + health))
        enemy_total_damage=$((enemy_total_damage + damage))
    done

    turn=$((RANDOM % 2))

    while [[ "$user_total_health" -gt 0 && "$enemy_total_health" -gt 0 ]]; do
        if [[ "$turn" -eq 0 ]]; then
            enemy_total_health=$((enemy_total_health - user_total_damage))
            turn=1
        else
            user_total_health=$((user_total_health - enemy_total_damage))
            turn=0
        fi
    done

    if [[ "$user_total_health" -gt 0 ]]; then
        reward=$((RANDOM % 20 + 10))
        user_money=$((user_money + reward))
        echo "Victory! You earned $reward coins."
    else
        echo "Defeat! Your warriors lost health."
        for i in "${!user_warriors[@]}"; do
            IFS=',' read -r health damage name <<< "${user_warriors[i]}"
            new_health=$((health - 20))
            user_warriors[i]="$new_health,$damage,$name"
        done
    fi
}


fight_bandits() {
    echo "Available Bandit Groups:"
    echo "1. Group A - Number of Warriors: 2"
    echo "2. Group B - Number of Warriors: 3"
    echo "3. Group C - Number of Warriors: 4"

    read -p "Choose a group to fight (1-3): " choice

    case "$choice" in
        1) enemy_warriors=($(warrior 2 false)) ;;
        2) enemy_warriors=($(warrior 3 false)) ;;
        3) enemy_warriors=($(warrior 4 false)) ;;
        *) echo "Invalid choice!"; return ;;
    esac

    echo "Enemy Group Details:"
    for enemy in "${enemy_warriors[@]}"; do
        IFS=',' read -r health damage name <<< "$enemy"
        echo "Name: $name, Health: $health, Damage: $damage"
    done

    read -p "Do you want to forfeit? (yes/no): " forfeit
    if [[ "$forfeit" == "yes" ]]; then
        echo "You forfeited the fight."
        return
    fi

    resolve_fight
}
