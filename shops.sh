#!/bin/bash
source ./view_warriors.sh

food_cost=10
bandage_cost=15
hunger_decrease=10
health_boost=20

function newshop() {
	user_money="$1"
	user_hunger="$2"
        echo -e "\n----  Shop ----"
        while true; do
		echo "Money: $user_money | Hunger: $user_hunger"
                echo -e "\n1. Buy Food (10 coins)\n2. Buy Bandages (15 coins)\n3. Leave"
                read -p "Choose an option: " ch
                case $ch in
                        1)
				if (( user_hunger == 0 )); then
					echo -e "\nYour hunger is already at minimum.  Come back tomorrow."
				else
					while true; do
						echo -e "\nMoney: $user_money | Hunger: $user_hunger\n"
						read -p "How much food do you want or press 'q' to quit: " qty
						
						if [[ "$qty" == "q" ]]; then
                                                	echo "Exiting the shop"
                                                	break
                                        	fi

						if (( qty * food_cost > user_money )); then
							echo "You do not have enough money for $qty food"
							break
						fi
						
						count=0
						while (( user_money >= food_cost && user_hunger > 0 && count < qty )); do
							(( count++ ))
							(( user_money -= food_cost ))
						       	if ((user_hunger - hunger_decrease <= 0)); then
								user_hunger=0
								echo "Minimum hunger reached after purchasing $count food"
								count="$qty"
							else
								((user_hunger-=hunger_decrease))
							fi
						done

						(( userhunger == 0 )) && break

						((count != qty)) && ((count == 0)) && echo "You do not have enough money for any food" || echo "You only had enough for $count items of food"
						break

					done
				fi;;
                        2)
                                if [[ "$user_money" -ge 15 ]]; then
                                        view_warriors
                                        read -p "Choose warrior to heal or press 'q' to quit: " warrior_index

                                        if [[ "$warrior_index" == "q" ]]; then
                                                echo "Exiting the shop"
                                                break
                                        fi

					warrior_line=$(sed -n "${warrior_index}p" user_warriors)

                                        if [[ -n "$warrior_line" ]]; then
                                                health=$(echo "$warrior_line" | awk '{ print $1 }')
                                                name=$(echo "$warrior_line" | awk '{ print $3 }')
                                                
                                                if ((health == 100)); then
                                                        echo "$name is already at max health. Please select someone else."
                                                else
                                                        if ((health + health_boost > 100)); then
                                                                new_health=100
                                                        else
                                                                new_health=$((health + health_boost))
                                                        fi
							awk -v line="$warrior_index" -v new_health="$new_health" 'NR == line {$1 = new_health} {print $0}' user_warriors > temp_file && mv temp_file user_warriors
							user_money=$((user_money - 15))
                                                        echo "$name healed."
                                                fi
                                        else
                                                echo "Invalid choice!"
                                        fi
                                else
                                        echo "Not enough money!"
                        fi;;
                        3)
                                echo "Leaving the shop..."
                                break;;
                        *)
                                echo "Invalid Option"
                esac
        done

        echo "$user_money $user_hunger"
}
