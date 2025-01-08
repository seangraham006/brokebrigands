#! /bin/bash
source ./characters.sh

money=0
hunger=50
readarray -t warriors < <(warrior 3 true)
#warriors holds all of the user's warriors
while (( money < 500 ))
do
	(( money += 50 ))
	echo $money
done
