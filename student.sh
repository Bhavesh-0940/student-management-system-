#!/bin/bash

FILE="students.txt"

touch $FILE

add_student() {

echo
echo "------ Add Student ------"

echo "Enter Roll Number:"
read roll

if grep -q "^$roll|" $FILE
then
echo "❌ Error: Roll number already exists!"
return
fi

echo "Enter Name:"
read name

echo "Enter Age:"
read age

echo "Enter Class (1-12):"
read class

if ! [[ "$class" =~ ^[0-9]+$ ]]
then
echo "❌ Class must be a number"
return
fi

if [ $class -lt 1 ] || [ $class -gt 12 ]
then
echo "❌ Class must be between 1 and 12"
return
fi

echo "$roll|$name|$age|$class" >> $FILE

echo
echo "✅ Student added successfully!"
echo
}

search_student() {

echo
echo "------ Search Student ------"
echo "1. Search by Roll Number"
echo "2. Search by Name"

read choice

if [ $choice -eq 1 ]
then
echo "Enter Roll Number:"
read roll

result=$(grep "^$roll|" $FILE)

if [ -z "$result" ]
then
echo "❌ No student found"
else
echo
printf "%-10s %-15s %-5s %-5s\n" "Roll" "Name" "Age" "Class"
echo "-------------------------------------------"
echo "$result" | awk -F"|" '{printf "%-10s %-15s %-5s %-5s\n",$1,$2,$3,$4}'
fi

elif [ $choice -eq 2 ]
then
echo "Enter Name:"
read name

result=$(grep "|$name|" $FILE)

if [ -z "$result" ]
then
echo "❌ No student found"
else
echo
printf "%-10s %-15s %-5s %-5s\n" "Roll" "Name" "Age" "Class"
echo "-------------------------------------------"
echo "$result" | awk -F"|" '{printf "%-10s %-15s %-5s %-5s\n",$1,$2,$3,$4}'
fi
fi

echo
}

view_students() {

echo
echo "------ All Students ------"

if [ ! -s $FILE ]
then
echo "No records found"
return
fi

printf "%-10s %-15s %-5s %-5s\n" "Roll" "Name" "Age" "Class"
echo "-------------------------------------------"

awk -F"|" '{printf "%-10s %-15s %-5s %-5s\n",$1,$2,$3,$4}' $FILE

echo
}

remove_student() {

echo
echo "------ Remove Student ------"

echo "Enter Roll Number to delete:"
read roll

if ! grep -q "^$roll|" $FILE
then
echo "❌ Student not found"
return
fi

grep -v "^$roll|" $FILE > temp.txt
mv temp.txt $FILE

echo "✅ Student removed successfully"

echo
}

while true
do

echo "====== Student Management System =========="
echo "1. Add Student"
echo "2. Search Student"
echo "3. View All Students"
echo "4. Remove Student"
echo "5. Exit"

read choice

case $choice in

1) add_student ;;

2) search_student ;;

3) view_students ;;

4) remove_student ;;

5) echo "Exiting program..."; exit ;;

*) echo "Invalid choice" ;;

esac

done
