#!/bin/bash
touch addtask_data.txt
form_data=addtask_data.txt
t_num=0
#functions
main_list()
{
listvalue=$(zenity --list --title="Options" --column="Choose from the following options" "Add Tasks" "View Tasks" "Exit")

case $listvalue in

"Add Tasks")
addtask
;;

"View Tasks")
view_task
;;

"Exit")
zenity --info --title="Exit" --text="Thank you for using Task Manager"
;;

esac

}

addtask()
{

while true;do

#get the data from the user
add=$(zenity --forms --title="Add a new task" --text="Insert task information" --add-entry="Title" --add-entry="Description"      --add-entry="Date" --add-entry="Time")

#store the data
nline=$(wc -l < "$form_data")
t_num=$((nline+1))
IFS=$'\n' read -r t_title t_des  t_date t_time <<< "$add"
echo "$t_num|$t_title|$t_des|$t_date|$t_time" >> "$form_data"
zenity --question --text="Another Task ?" --ok-label="Yes" --cancel-label="Return to menu list"
if [ $? -eq 1 ]; then
break;
fi
done
main_list

}

view_task()
{
#task view
awk -F '|' '{printf("Task %s\nTitle : %s\nDescription : %s\nDate : %s\nTime : %s\n\n",$1,$2,$3,$4,$5)}' "$form_data"|zenity --text-info --title="Task View" --width=400 --height=400

#task selector
t_numarray=($(awk -F '|' '{print $1}' "$form_data"))

if [ ${#t_numarray[@]} -gt 0 ]; then
    checktask=$(zenity --list --title="Tasks" --text="Select a task from the list below : " --column="Tasks" "${t_numarray[@]}")
elif [ ${#t_numarray[@]} -eq 0 ]; then
zenity --info --text="You've Finished All your Tasks"
if [ $? -eq 0 ]; then
main_list
fi
fi

#task status pop-up box
if [ $? -eq 0 ]; then
status=$(zenity --entry --title="Task $checktask" --text="Enter Task status ")
fi

case $status in 
"done")
zenity --info --text="Congrats \!! you've finished your task " --ok-label="   Remove from task list   "
if [ $? -eq 0 ]; then
sed -i "${checktask}d" "$form_data"
zenity --info --text="Your Task Has Been Removed Successfully"
main_list
fi
;;

"on it")
zenity --info --text="Keep up the hard work " 
main_list
;;
esac
}

zenity --info --title="Task Manager" --text="   Welcome to Task Manager \n\n\n\n Your Way to Get your life back together " --width=200 --height=200 --ok-label=" Continue "
main_list



