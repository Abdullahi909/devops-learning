## **Creating editing and searching file commands**

File creating and editing commands in Linux

Touch - this command creates and empty file.

Example of this, touch testfile.txt

Echo- this command allows users to print text or variables in a file.

Example of this, Echo "Hello world" >> testfile.txt , using one > overrides text being written in file

Cat- this command lets users see the contents of the file

Example of this, cat testfile.txt

Output "Hello world"

Grep- the command lets users search for specific texts inside files.

Example of this, grep "Hello" testfile.txt

Output "Hello world"

## **Shell programmes and binary**

Bash - Born again shell

A shell is a user interface that allows user to communicate with the operating system. It is between the user and the OS. Which translates user commands to actions.

Echo \$SHELL - This command lets users see what shell they are using

Output: /bin/bash, this is because I am using the bash shell

echo \$PATH shows all the directories Linux searches in order when you run a command. PATH is the variable that stores these directories, and \$PATH expands to show its value. When you type a command like ls, Linux looks through these directories until it finds the executable.

Output: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin

Cat /etc/shells- prints the configured shell file contents on the operating system/prints all the shells installed and available on your system

Output:

/bin/sh

/usr/bin/sh

/bin/bash

/usr/bin/bash

/bin/rbash

/usr/bin/rbash

/usr/bin/dash

/usr/bin/screen

/usr/bin/tmux

Sudo apt-get | this command uses admin rights to manage software packages on ubuntu

## **ZSH**

To install zsh shell, Sudo apt-get install zsh | This installs the shell, to exit just write exit and to get in write zsh.

To change shell the use the command chsh -s zsh | Because of the use of EC2instance use the command Sudo !!, 2 exclamation points tell the terminal I am trying to run the previous commands.

If this does not work then use, sudo chsh -s \$(which zsh) \$(whoami) changes your default shell to Zsh for your current user. sudo runs the command with administrator privileges, chsh means "change shell," -s \$(which zsh) sets the shell to Zsh by finding its installation path, and \$(whoami) applies the change to your user. After running it and logging back in, Zsh will start automatically whenever you open the terminal.

## **Linux file system**

Everything in Linux starts from /, called the root directory. It's the top of the whole file system, and every other folder branches out from it.

/home is where all user folders are stored. Each user has their own space here for personal files and settings.

/etc contains system and software configuration files. This is where most settings for the system are kept.

/bin has the basic system commands like ls, cp, and mv that are needed for the system to work.

/var stores files that change often, like logs, temporary data, and databases.

/usr holds programs and files installed by users, like software and apps that aren't essential for booting.

/tmp is used for temporary files created by programs. It's usually cleared when the system restarts.

/lib has shared libraries that help programs and the system run properly.

/root is the home directory for the root (admin) user.

/dev contains device files that represent hardware like hard drives and USBs.

/boot has the files needed to start the operating system.

Using the command cd ~/. | And pressing Tab allows users to quickly navigate hidden directories (those starting with a dot, like .config or .ssh) inside their home directory.

Command cd ~ | Takes user back to the home directory where user personal and work files are and their own configs are.

Command cd / | Takes users to the root directory, the top of the OS. This is where system config files are.

Command ls - a to show hidden files in a dir

Command cat can be used to combine 2 file contents, example cat test1.txt test2.txt > combine.txt. The contents of test1 and test2 will put together into the new combine file.

Command cat test1.txt >> test2.txt | what this command does it takes whatever is in test1 and then appends it to test2. Using one > means that the whole test 2 will get overdried and will be an exact copy of test1.

Command head multiline.txt| Running this command shows us the first 10 lines of a file

Command tail multiline.txt | Running this command shows us the last 10 lines of a file.

Combining commands using the pipe (|). The command, head -n 5 multiline.txt | tail -n 2 This means Take the first 5 lines of the file and then print the last 2 of those 5.

Command tail -n 5 multiline.txt | head -n 2. Take the last 5 lines of the file and then print the first 2 of those 5.

Command cp. This command can copy files and directories. To copy a file, you would need to have an already existing file, so it would be cp test1.txt test1_copy.txt, and then there would be a new copied text file. For directories you would need one that you have already created, so command cp -r my_directory my_directory_copy.

Command mv test1.txt test2.txt | This command allows us to rename a file

The mv command can also be used to move files into different directories, example of this mv test1.txt my_directory.

The command rm can be used to remove files and directories, to remove a file simply enter rm test1.txt.

The command mkdir -p projects/src/components. This allows us to create nested directories this is made possible by adding in the -p when using the command mkdir. And using ls -R shows all the subfolders in a linear way.

The command rmdir. This only removes an empty directory.

The command rm -r this can remove a directory and its contents.

To solve the conflict of using spacing when creating files or directories names, use speech marks for example mkdir "Home lab", this then gets recognised as one whole name and not just categorised as "home" and "lab" separately making 2 different directories. Or you can use back slash mkdir Home\\ lab.

The vim command can be used to created text files and edit them. When file is created there are different modes you can use. Default mode which is the command mode where you can delete things run commands and copy and paste, insert by pressing I where you can write things and visual mode by pressing V where you can select text.

To delete things in the command mode, you can delete a character by going on it and pressing X, to do a whole word dw, whole line dd.

To paste something, you will need to press the letter P, to copy a word press YW, to copy a whole line press YY.

Navigating the file in VIM. For this you will need to be in the default mode. So, to get to the end of a line press shift and 4. To get to the start press 0.

To get to a specific line in command mode, type : and the line number. Example :3 will take us to line 3.

Using the letter U can undo and pressing shift R re-dos

Finding words in vim. To find a specific word, you go into command mode and you type for example if looking for the word Line, you would write command /Line and it will take you to it, if it is mentioned more than once press n to go the next occurrence of it being used and then capital N to go back or shift.

Vim also allows stytax highlighting which makes it easy to read configuration files, to do this run this command in :syntax on.

To get line numbers in vim use command :set number and to get rid :set nonumber

To go into the root user run the command sudo su , this for when your running multiple admin asks.

To see the log of the sudo commands, run sudo tail /var/log/auth.log , this shows the last 10 lines of logs for the sudo command.

To create a new user in run the command sudo useradd newuser, newuser is the name of the user account. To add a password to the account run sudo passwd newuser.

To switch to the new user run command su - newuser, this means substitute new user

To give the new user sudo privileges run the command sudo usermod -aG newuser

To remove sudo permissions from user run command sudo deluser newuser sudo

Creating a new group run the command sudo groupadd devops this then creates a new group called devops to see it run the command cat /etc/group.

To put a new user in a group run the command sudo usermod -aG devops newuser

To remove user from the group run the command sudo gpasswd -d newuser devops

To delete a group run the command sudo groupdel devops

The command ls -l lists files and directories with details: type, permissions, owner, group, size, and last modified date. Permissions (r=read, w=write, x=execute) show what the owner, group, and others can do. '-' at the start = regular file, 'd' = directory; the number after permissions = link count.

To convert Linux permissions to octal, remember that each permission has a number: read is 4, write is 2, execute is 1, and a dash is 0. Take the permission string and split it into three groups: owner, group, and others. For example, in "rwxr-x-", the owner has rwx, the group has r-x, and others have -. Add the values for each group: rwx = 4+2+1 = 7, r-x = 4+0+1 = 5, and - = 0+0+0 = 0. Put them together to get the octal permission 750.

In Linux, every file and directory has permissions that control who can read, write, or execute it. These permissions are divided into three groups: **user (owner)**, **group**, and **others**. Each group can have **read (r)**, **write (w)**, or **execute (x)** permissions. The permissions appear in a 10-character string such as -rwxrwxrw-, where the first character shows the file type (- for file, d for directory), and the remaining nine characters represent the permissions for user, group, and others in sets of three.

Permissions also have **octal (numeric)** values: read = 4, write = 2, execute = 1, and a dash = 0. To convert permissions into octal, you add the values of each group so that rwx becomes 7, rw- becomes 6, r-x becomes 5, and --- becomes 0. For example, rwxrw-r-- becomes **764**.

The **chmod** command is used to change permissions. You can modify permissions in **symbolic mode** (like chmod u+x,g-x file) or in **octal mode** (like chmod 750 file). Symbolic mode uses letters to represent user (u), group (g), others (o), or all (a), and + adds permissions, - removes them, and = sets exact permissions.

When using numeric mode, each digit represents the permissions for the owner, group, and others in that order. The digit is made by adding values: 4 for read, 2 for write, and 1 for execute. For example, if you want the owner to have full permissions you use 7 (4+2+1), if you want only read and write you use 6 (4+2), and if you want execute only you use 1. Putting the three digits together sets all permissions at once - like 750, 644, or 711.

The chown command changes the owner of a file, and can also change its group at the same time. The syntax is chown owner:group file. For example, sudo chown ubuntu:admin2 a1.txt changes the file a1.txt so that ubuntu is the owner and admin2 is the group. If you only want to change the group, you can use chgrp group file, e.g., sudo chgrp admin2 a1.txt. These commands require sudo if you are changing ownership to a different user or group. You can verify changes using ls -l, which shows the owner and group in the third and fourth columns.

The -R option in chown or chgrp makes the command recursive, meaning it will change the owner or group for the target directory and all files and subdirectories inside it. For example, sudo chown -R newuser:admin2 my-dir/ changes the owner to newuser and the group to admin2 for my-dir and everything inside it.

Linux allows you to redirect input and output of commands. Using > sends standard output to a file, overwriting it. Using &lt; reads input from a file. Standard error messages can be redirected using 2&gt;. For example, ls fake 2> error.txt saves the error message to error.txt. You can redirect both standard output and standard error using &>, e.g., ls fake my-dir &> alloutputs.txt writes both the normal output and errors to the file. This is useful for logging or handling errors in scripts.

You can create temporary environment variables in Linux using export MY_VAR="Hello world" and check its value with echo \$MY_VAR. To make a variable permanent, open your terminal and type vim .zshrc, press i to enter insert mode, then write MY_VAR="Hello world" at the very bottom of the file. Save and exit Vim. To apply the changes immediately exit and come back.

The PATH variable contains directories where the shell searches for commands. You can add a directory to PATH using export PATH=\$PATH:/home/ubuntu. This allows you to run scripts or programs in that directory without typing the full path.

For scripts, create or edit a file (e.g., vim greet.sh), make it executable with chmod +x greet.sh, and run it using ./greet.sh. This workflow is essential for automating tasks and running commands efficiently from the terminal.

An alias is a shortcut for a command or a set of commands, which makes running frequent commands easier. You can create a temporary alias directly in the terminal, for example, alias hello='echo Hello world'. After creating it, typing hello in the terminal will print Hello world.

To make an alias permanent, you need to add it to your .zshrc file. Open the file with vim .zshrc, press i to enter insert mode, and add your alias at the very bottom, for example: alias hello='echo "Hello world"'. Save and exit Vim. To apply the alias immediately without restarting the terminal, run source .zshrc. Using double quotes inside the echo command ensures that the text is treated as a single string, preserving spaces and special characters. Once added, the alias will be available in every new terminal session, making repeated commands faster and easier to type.
