
def task():
    task = []
    print("******* Welcome to Todo List *****")
    totalTasks = int(input("How many task you want to add: "))
    for i in range(1, totalTasks+1):
        taskName = input(f"Enter the task {i} to add: ")
        task.append(taskName)
    print(f"Your todays tasks\n{task}")
    
    while True:
        userChoice = int(input("Enter\n 1- Add\n 2-Update\n 3-Delete\n 4-View\n 5-Exit/Stop/"))
        if userChoice == 1:
            addTask = input("Enter the task U want to add:")
            task.append(addTask)
            print(f"{addTask} has been added successfully... ")
            print(f"Total task = {task}")
        elif userChoice == 2:
            updateTask  = input("Enter the task U want to update: ")
            if updateTask in task:
                newTask = input("Enter the new task: ")
                findIndex  = task.index(updateTask)
                task[findIndex] = newTask
                print(f"your new updated task {newTask} has been added successfully....")
                print(f"Total task = {task}")
            else:
                print(f"{updateTask} not found in your list")
                    
        elif userChoice == 3:
            deleteTask = input("Enter the task U want to delete: ")
            if deleteTask in task:
                findIndex = task.index(deleteTask)
                task.pop(findIndex)
                print(f"{deleteTask} has been deleted successfully.....")
                print(f"Total task = {task}")
            else:
                print(f"{deleteTask} not found in your list")
       
        elif userChoice == 4:
            print(f"Total task = {task}")
        elif userChoice == 5:
            print("Thank you for using Todo List. Goodbye!")
            break;
        else:
            print("Invalid input.....")                   
task();                