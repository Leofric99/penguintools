def menu():
    print()
    print("1. Move files")
    print("2. Copy files")
    print("3. Mirror files")
    print()
    menu_opt = int(input("Please enter your choice: "))
    print()
    submenu(menu_opt)

def submenu(menu_opt):
    if menu_opt == 1:
        print("Move files selected.")
    
    elif menu_opt == 2:
        print("Copy files selected.")

    elif menu_opt == 3:
        print("Mirror files selected.")

    else:
        print("Invalid Option")
        menu()

menu()