!/bin/bash


a="cat"

case $a in
	cat) echo "it's a cat !";;
	dog|puppy) echo "it's a dog";;   # it will accept either dog or puppy
	*) echo "no match";;
esac


# create a case statement matching first  ARGV element
case $1 in
	Monday|Tuesday|Wedensday|Friday)
	echo "it is weekday";;
	Saturday|Sunday)
	echo "its weekend";;
	# everything else
	*)
	echo "not a week day";;
esac


for file in model_out/*
do
	case $(cat $file) in
		RandomForest|GBM|XGBoost|KNN)
		rm $file;;
		*)
		echo "unknown model in $file";;
	esac
done