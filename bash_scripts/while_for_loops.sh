!/bin/bash


# while loop works when the expression is true
i=0
while [ $i -le 10 ]; do
	echo i: $i
	((i++))
done

# until loop works when the expression is false
j=0
until [ $j -ge 10 ]; do
	echo j: $j
	((j++))
done

emp_num=1
while [ $emp_num -le 1000 ]; do
    cat "$emp_num-dailySales.txt" | egrep'Sales_total' | sed 's/.* ://' > "$emp_num-agg.txt"
	((emp_num++))
done


for i in 1 2 3 4 5
do
	echo $i
done


for j in {1..10..2}
do
	echo $j
done


for (( z=0; z<=10; z++ ))
do
	echo $z
done


arr=("apple" "banana" "cherry")
for x in ${arr[@]}
do 
	echo $x
done


declare -A arrr
arrr["name"]="Bob Habib"
arrr["id"]="1031B"

# ! in ${!arrr[@]} means that $v is the key and not the value
# we put array element inside "" since there may be space in the string
for v in "${!arrr[@]}"
do
	echo $v: ${arrr[$v]}
done


# for loop for all files in a directory
for file in inheritedfolder/*.py
do 
	echo $file
done


for file in robs_file/*.py
do
	if grep -q 'RandomForestClassifer' $file; then
		mv $file to_keep/
done
