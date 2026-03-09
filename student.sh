#!/bin/bash

FILE="students.txt"

touch $FILE

add_student() {

echo "Enter Name:"
read name

echo "Enter Roll Number:"
read roll

# check roll already exists
if grep -q "^$roll|" $FILE
then
echo "Roll number already exists!"
return
fi

echo "Enter Age:"
read age

echo "Enter Class:"
read class

echo "$roll|$name|$age|$class" >> $FILE
echo "Student added successfully!"
}

search_student() {

echo "Search By:"
echo "1. Roll Number"
echo "2. Name"
echo "3. Class"
read choice

case $choice in

1)
echo "Enter Roll Number:"
read roll
grep "^$roll|" $FILE
;;

2)
echo "Enter Name:"
read name
grep "$name" $FILE
;;

3)
echo "Enter Class:"
read class
grep "|$class$" $FILE
;;

*)
echo "Invalid option"
;;

esac
}

view_students() {

if [ ! -s $FILE ]
then
echo "No records found"
else
echo "Student Records:"
cat $FILE
fi
}

remove_student() {

echo "Enter Roll Number to delete:"
read roll

if grep -q "^$roll|" $FILE
then
grep -v "^$roll|" $FILE > temp.txt
mv temp.txt $FILE
echo "Student removed successfully"
else
echo "Roll number not found"
fi
}

while true
do

echo "------ Student Management System ------"
echo "1. Add Student"
echo "2. Search Student"
echo "3. View All Students"
echo "4. Remove Student"
echo "5. Exit"

read option

case $option in

1) add_student ;;
2) search_student ;;
3) view_students ;;
4) remove_student ;;
5) echo "Exiting..."; exit ;;
*) echo "Invalid choice" ;;

esac

done
