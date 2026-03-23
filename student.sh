#!/bin/bash

FILE="students.txt"
touch $FILE

SEPARATOR="=============================================="

add_student() {
    echo
    echo "------ Add Student ------"

    # Roll Number - sirf digits, aur already exist na kare
    while true; do
        echo "Enter Roll Number:"
        read roll
        if ! [[ "$roll" =~ ^[0-9]+$ ]]; then
            echo "❌ Roll Number must be digits only! Try again."
            continue
        fi
        if grep -q "^$roll|" $FILE; then
            echo "❌ Roll Number already exists! Try again."
            continue
        fi
        break
    done

    # Name
    while true; do
        echo "Enter Name:"
        read name
        if [[ -z "$name" ]]; then
            echo "❌ Name cannot be empty! Try again."
            continue
        fi
        break
    done

    # Age - sirf digits, 1 se 24 ke beech
    while true; do
        echo "Enter Age (1-24):"
        read age
        if ! [[ "$age" =~ ^[0-9]+$ ]]; then
            echo "❌ Age must be digits only! Try again."
            continue
        fi
        if [ "$age" -lt 1 ] || [ "$age" -gt 24 ]; then
            echo "❌ Age must be between 1 and 24! Try again."
            continue
        fi
        break
    done

    # Class - 1 se 12 ke beech
    while true; do
        echo "Enter Class (1-12):"
        read class
        if ! [[ "$class" =~ ^[0-9]+$ ]]; then
            echo "❌ Class must be digits only! Try again."
            continue
        fi
        if [ "$class" -lt 1 ] || [ "$class" -gt 12 ]; then
            echo "❌ Class must be between 1 and 12! Try again."
            continue
        fi
        break
    done

    echo "$roll|$name|$age|$class" >> $FILE
    echo
    echo "✅ Student added successfully!"
    echo
}

print_table() {
    echo
    printf "%-10s | %-15s | %-5s | %-5s\n" "Roll" "Name" "Age" "Class"
    echo "-------+------------------+-------+-------"
    echo "$1" | awk -F"|" '{printf "%-10s | %-15s | %-5s | %-5s\n",$1,$2,$3,$4}'
    echo
}

search_student() {
    echo
    echo "------ Search Student ------"
    echo "1. Search by Roll Number"
    echo "2. Search by Name"

    while true; do
        read choice
        if [[ "$choice" == "1" ]]; then
            while true; do
                echo "Enter Roll Number:"
                read roll
                if ! [[ "$roll" =~ ^[0-9]+$ ]]; then
                    echo "❌ Roll Number must be digits only! Try again."
                    continue
                fi
                break
            done
            result=$(grep "^$roll|" $FILE)
            if [ -z "$result" ]; then
                echo "❌ No student found with Roll Number: $roll"
            else
                print_table "$result"
            fi
            break

        elif [[ "$choice" == "2" ]]; then
            while true; do
                echo "Enter Name:"
                read name
                if [[ -z "$name" ]]; then
                    echo "❌ Name cannot be empty! Try again."
                    continue
                fi
                break
            done
            result=$(grep -i "|$name|" $FILE)
            if [ -z "$result" ]; then
                echo "❌ No student found with Name: $name"
            else
                print_table "$result"
            fi
            break

        else
            echo "❌ Invalid choice! Enter 1 or 2:"
        fi
    done
    echo
}

view_students() {
    echo
    echo "------ All Students ------"
    if [ ! -s $FILE ]; then
        echo "⚠️  No records found."
        echo
        return
    fi
    all=$(cat $FILE)
    print_table "$all"
}

remove_student() {
    echo
    echo "------ Remove Student ------"

    while true; do
        echo "Enter Roll Number to delete:"
        read roll
        if ! [[ "$roll" =~ ^[0-9]+$ ]]; then
            echo "❌ Roll Number must be digits only! Try again."
            continue
        fi
        break
    done

    if ! grep -q "^$roll|" $FILE; then
        echo "❌ Student not found with Roll Number: $roll"
        echo
        return
    fi

    grep -v "^$roll|" $FILE > temp.txt
    mv temp.txt $FILE
    echo "✅ Student removed successfully!"
    echo
}

# ========== Main Loop ==========
while true; do
    echo "$SEPARATOR"
    echo "     🎓 Student Management System"
    echo "$SEPARATOR"
    echo "  1. Add Student"
    echo "  2. Search Student"
    echo "  3. View All Students"
    echo "  4. Remove Student"
    echo "  5. Exit"
    echo "$SEPARATOR"
    echo "Enter your choice:"

    read choice

    case $choice in
        1) add_student ;;
        2) search_student ;;
        3) view_students ;;
        4) remove_student ;;
        5) echo "👋 Exiting... Goodbye!"; exit ;;
        *) echo "❌ Invalid choice! Please enter 1-5." ; echo ;;
    esac

done
```

---

**Kya changes kiye aur kyon:**

**Roll & Age sirf digits** — `[[ "$var" =~ ^[0-9]+$ ]]` regex use kiya, agar kuch bhi aur likha toh error aata hai aur **loop wahi se restart** hota hai `while true + continue` se.

**Age limit 24** — digit check ke baad `[ "$age" -gt 24 ]` condition lagayi, warna wapas maangta hai.

**Galat input pe loop wahi rukta hai** — pehle `return` se function band ho jaata tha, ab `while true` loop lagayi har field ke liye taaki user sahi value dale tabhi aage jaye.

**Table structure** — `print_table()` function banaya jisme `|` separator ke saath proper aligned columns dikhte hain:
```
Roll       | Name            | Age   | Class
-------+------------------+-------+-------
101        | Rahul           | 18    | 11