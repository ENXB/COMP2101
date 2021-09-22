
#!/bin/bash
#
# this script demonstrates doing arithmetic

# Task 1: Remove the assignments of numbers to the first and second number variables. Use one or more read commands to get 3 numbers from the user.
# Task 2: Change the output to only show:
#    the sum of the 3 numbers with a label
#    the product of the 3 numbers with a label

echo "Please enter three numbers seperated by a space"
read firstnum secondnum thirdnum 
sum=$((firstnum + secondnum + thirdnum))
product=$((firstnum * secondnum * thirdnum))
fpdividend=$(awk "BEGIN{printf \"%.2f\", $firstnum/$secondnum}")

cat <<EOF
Sum: $sum
Product: $product
EOF
