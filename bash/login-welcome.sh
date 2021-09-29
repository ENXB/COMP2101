#!/bin/bash
#
# This script produces a dynamic welcome message
# it should look like
#   Welcome to planet hostname, title name!

# Task 1: Use the variable $USER instead of the myname variable to get your name
# Task 2: Dynamically generate the value for your hostname variable using the hostname command - e.g. $(hostname)
# Task 3: Add the time and day of the week to the welcome message using the format shown below
#   Use a format like this:
#   It is weekday at HH:MM AM.
# Task 4: Set the title using the day of the week
#   e.g. On Monday it might be Optimist, Tuesday might be Realist, Wednesday might be Pessimist, etc.
#   You will need multiple tests to set a title
#   Invent your own titles, do not use the ones from this example

###############
# Variables   #
###############
title="Overlord"
myname=$USER
hostname=$HOSTNAME
day=$(date +%A)
hour=$(date +%I)
minutes=$(date +%M)
ampm=$(date +%p)
###############
# Main        #
###############
test $day = "Monday" && daytitle="Mooday"
test $day = "Wednesday" && daytitle="Wooday"
test $day = "Tuesday" && daytitle="Tooday"
test $day = "Thursday" && daytitle="Thooday"
test $day = "Friday" && daytitle="Fooday"
test $day = "Saturday" && daytitle="Satooday"
test $day = "Sunday" && daytitle="Sooday"

message=$(cat <<EOF
$daytitle
Welcome to planet $hostname, "$title $myname!"
It is $day at $hour:$minutes $ampm
EOF
)

echo $message | cowsay -n
