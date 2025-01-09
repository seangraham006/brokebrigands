#! /bin/bash

resolve_fight() {
    # Initialize user money from the argument
    local user_money=$(get_money)
    local user_health=0
    local user_damage=0
    local enemy_health=0
    local enemy_damage=0

    # Read user warriors from the file
    while IFS=' ' read -r health damage name; do
        echo "$health,$damage,$name"
        user_health=$((user_health + health))
        user_damage=$((user_damage + damage))
    done < user_warriors

    # Read enemy warriors from the file
    while IFS=' ' read -r health damage name; do
        enemy_health=$((enemy_health + health))
        enemy_damage=$((enemy_damage + damage))
    done < enemy_warriors

    # Randomly decide who attacks first
    local turn=$((RANDOM % 2))
    local first_strike_done=0  # Track if first strike advantage is applied

    # Battle loop
    while [[ "$user_health" -gt 0 && "$enemy_health" -gt 0 ]]; do
        if [[ "$turn" -eq 0 ]]; then
            if [[ "$first_strike_done" -eq 0 ]]; then
                # Apply *4 damage on the first strike
                enemy_health=$((enemy_health - user_damage * 4))
                first_strike_done=1
                echo "First strike! You dealt $(($user_damage * 4)) damage."
            else
                enemy_health=$((enemy_health - user_damage))
            fi
            turn=1
        else
            user_health=$((user_health - enemy_damage))
            turn=0
        fi
    done

    if [[ "$user_health" -gt 0 ]]; then
        # Reward the user with coins if they win
        local reward=$((RANDOM % 20 + 10))
        user_money=$((user_money + reward))
        set_money "$user_money"
        echo "Victory! You earned $reward coins. Current money: $(get_money)"
    else
        echo "Defeat! Your warriors suffered greatly."
        # Update user warriors after defeat (subtract health from each)
        while IFS=' ' read -r health damage name; do
            local new_health=$((health - 20))
            if [[ "$new_health" -le 0 ]]; then
                echo "${name} has perished in battle."
            else
                echo "$new_health $damage $name" >> updated_user_warriors
            fi
        done < user_warriors
        mv updated_user_warriors user_warriors  # Update the file with the new warrior states
    fi
    echo
}

