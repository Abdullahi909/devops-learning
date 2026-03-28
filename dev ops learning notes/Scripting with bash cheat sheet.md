**[Scripting with bash cheat sheet]{.underline}**
=================================================

[Shebang]{.underline} 
---------------------

-   Interpreter = bash

-   Use shebang: \#!/bin/bash or better: \#!/usr/bin/env bash

-   This tells Linux to run the script with Bash

-   Script must be executable: chmod +x script.sh

-   Run with: ./script.sh

-   If you skip the shebang, script runs with whatever shell you're currently in (can break things)

[Comments]{.underline} 
----------------------

Single-line comment

-   \# comment → Bash ignores anything after \#

Multi-line style comment

-   Use : \' \... \'

[Running scripts from anywhere]{.underline}
-------------------------------------------

-   \$PATH = directories shell searches for commands

-   View PATH: echo \$PATH

-   Any executable inside a PATH directory can be run from anywhere

-   Commands like ls, mv, cd, pwd work anywhere because they live in PATH directories; scripts only work if you're inside their folder unless you put them in a PATH directory.

-   Common PATH directory for custom scripts: /usr/local/bin

-   Move script into PATH:

    -   sudo mv greet.sh /usr/local/bin/greet

-   Make script executable:

    -   sudo chmod +x /usr/local/bin/greet

-   Run script globally:

    -   greet

-   Works in any directory (no ./ and no full path needed)

[Variables]{.underline} 
-----------------------

-   Variables store data: text, numbers, arrays

-   Create variable: name=value

-   Access variable: \$name

-   String example: greeting=\"Hello, world\" → echo \$greeting

-   Number example: count=42 → echo \$count

-   Array example: fruits= ("apple", "banana", "orange") → echo \$fruits

-   Variable interpolation: name=\"Ahmed" greeting= "hello \$name" → echo greeting output= hello Ahmed

-   Variables must be defined before use

-   Make script executable: chmod +x var.sh

-   Run script: ./var.sh

[Parameters]{.underline} 
------------------------

-   Parameters = values given after the script name when running a script

-   Parameters are separated by spaces

-   \$1 = first parameter

-   \$2 = second parameter

-   \$3 = third parameter

-   \$@ = all parameters

-   Example script:

> \#!/bin/bash
>
> echo \"First: \$1\"
>
> echo \"Second: \$2\"
>
> echo \"Third: \$3\"
>
> echo \"All: \$@\"

Example run: ./script.sh apple banana orange

Output:

First: apple

Second: banana

Third: orange

All: apple banana orange

Missing parameters are empty if not provided. Parameters make scripts dynamic and flexible. Script always reads parameters by position: 1st → \$1, 2nd → \$2, 3rd → \$3

[Arithmetic expansion]{.underline} 
----------------------------------

-   Assign variables: num1=5, num2=6

    -   Store values for calculations; no spaces around =

    -   Case-sensitive: num1 ≠ Num1

-   Arithmetic expansion: \$((expression))

    -   Tells Bash to calculate, not treat as text

    -   Variables inside \$(( )) don't need \$

-   Basic operations:

    -   Addition: +

    -   Subtraction: -

    -   Multiplication: \*

    -   Division: / (integer only; decimals truncated)

-   Order of operations: use parentheses ()

-   Store results: result=\$((num1 + num2))

-   Output results: echo \"\$result\" or echo \"Label: \$result\"

-   Use script parameters: \$1, \$2, \$3

    -   Example: sum=\$(( \$1 + \$2 ))

    -   Run script: ./script.sh 5 6

-   Combine variables and parameters:

    -   total=\$((num1 + \$1))

    -   echo \"Total: \$total\"

[IF statements]{.underline} 
---------------------------

> if \[ condition \]; then
>
> commands
>
> fi

-   Spaces are needed in the condition after each bracket

-gt (Greater than)

-lt (less than)

-ge (Greater or equal)

-le (Less or equal)

eq (equal)

-ne (Not equal)

&& = AND

\|\| = OR

== compares string values if they are equal

!= checks to see if 2 strings are different

Elif

-   Stands for "else if"

-   Checks a new condition only if the previous if or elif was false

-   Used to handle multiple mutually exclusive conditions

Example

if \[ \"\$grade\" -ge 71 \]; then

echo \"First class\"

elif \[ \"\$grade\" -ge 40 \]; then

echo \"Passed\"

fi

Else

-   Runs commands if all previous if and elif conditions are false

-   Optional, used as a "catch-all"

Example:

if \[ \"\$grade\" -ge 40 \]; then

echo \"Passed\"

else

echo \"Failed\"

fi

Nested if

-   An if statement inside another if statement

-   Inner if runs only if the outer if is true

-   Used when second check depends on first

Example:

if \[ \"\$grade\" -ge 40 \]; then

echo \"You passed\"

if \[ \"\$grade\" -ge 71 \]; then

echo \"You got a first\"

fi

else

echo \"You failed\"

fi

[options for if statements]{.underline}

-f checks for files

-d checks for directory

-e does it exist(file or directory)

[While loops]{.underline} 
-------------------------

-   A while loop repeats a block of code as long as a condition is true.

-   It keeps running until the condition becomes false.

-   Useful for iterating over arrays, counting numbers, or doing repeated tasks automatically.

Syntax:

while \[ condition \]

do

\# commands to repeat

done

[Example:]{.underline}

> count=1
>
> while \[ \$count -le 5 \]
>
> do
>
> echo \"Count: \$count\"
>
> ((count++))
>
> done

output:

Count: 1

Count: 2

Count: 3

Count: 4

Count:

Explanation:

-   count=1 → starting number

-   \[ \$count -le 5 \] → run while count ≤ 5

-   echo → print the current count

-   ((count++)) → add 1 to count each loop

-   Stops automatically when count becomes 6

[Example 2: arrays]{.underline}

names=(\"Sara\" \"Ali\" \"Omar\")

index=0

while \[ \$index -lt \${\#names\[@\]} \]

do

echo \"Name: \${names\[\$index\]}\"

((index++))

Done

Output:

Name: Sara

Name: Ali

Name: Omar

-   Create an array: names=(\"Sara\" \"Ali\" \"Omar\") → stores 3 names

-   Start at the first name: index=0

-   Loop while index is less than the total number of names (\${\#names\[@\]})

-   Print the name at the current index: echo \${names\[\$index\]}

-   Increase index by 1: ((index++)) → moves to the next name

-   Stops automatically when all names have been printed

[For loop]{.underline} 
----------------------

A for loop goes through a collection of values (whether it\'s a list, an array, or numbers you create), picks one value at a time, executes the command, then moves to the next until it\'s done.

[Examples of for loops]{.underline}

For names in Ali Mohamed and Abdullahi

Do echo "Name: \$names"

Done

Output:

> Name: Ali
>
> Name: Mohamed
>
> Name: Abdullahi

fruits=(\"Apple\" \"Orange\" \"Banana\")

for food in \"\${fruits\[@\]}\"

do echo \"fruit: \$food\"

done

> output:
>
> fruit: Apple
>
> fruit: Orange
>
> fruit: Banana

for (( i=1; i\<=5; i++))

do echo \"number: \$i\"

done

> output:
>
> number: 1
>
> number: 2
>
> number: 3
>
> number: 4
>
> number: 5

for number in \$(seq 1 3)

do echo \"sequence: \$number\"

done

> output:
>
> sequence: 1
>
> sequence: 2
>
> sequence: 3

[Break and continue]{.underline} 
--------------------------------

Break and continue are used in for and while loops, this is used in a way so that the loops can stop or skip a process/step in a loop. This would be done by using IF statements inside of the loops.

[Examples: of break and continue]{.underline}

car=1

while true

do

echo \"cars: \$car\"

((car++))

if \[ \$car -eq 5 \]

then

break

fi

done

[output:]{.underline}

cars 1

cars 2

cars 3

cars 4

car=1

while \[ \$car -le 5 \]

do

if \[ \$car -eq 3 \]

then

((car++))

continue

fi

echo \"amount of cars: \$car\"

((car++))

done

[output:]{.underline}

amount of cars :1

amount of cars :2

amount of cars :4

amount of cars :5

[Functions]{.underline}
-----------------------

A function is like a call out to a set of commands that was assigned inside the function, you call it out and it runs.

[Example:]{.underline}

hello\_world () {

echo "Hello world"

}

hello\_world

[output:]{.underline}

Hello world

[Example2]{.underline}

greet\_person () {

local name= \$1

echo "Hello, \$1"

}

greet\_person Abdullahi

[output:]{.underline}

Hello, Abdullahi

[Special Parameters]{.underline} 
--------------------------------

Positional parameters when used allow us to input things when we run scripts or create them, this is usually seen as \$1or \$2 these are positional parameters.

Special ones give us special ones give us special abilities when used in scripts, these are seen as:

\$@ - this lets us see all arguments in the script

\$0- this shows us the script name

\$\#- shows us how many arguments

[Example:]{.underline}

arguments\_1(){

echo \"number of arguments: \$\#\"

echo \"script name: \$0\"

echo \"first argument: \$1\"

echo \"second argument: \$2\"

echo \"all arguments: \$@\"

}

arguments\_1 \"Abdullahi\" \"Mohamed\"

[output:]{.underline}

number of arguments: 2

script name: /Users/Abdullahi/Desktop/Dev ops learning docs/bash /functions2.sh

first arguments: Abdullahi

second argument: Mohamed

all arguments: Abdullahi Mohamed

[User inputs]{.underline}

User inputs in bash come from parameters \$1/\$2 and the read command, they both allow users to make inputs.

Using the \[read\] command allows us to take a user input and then store it into a variable.

Example:

greet\_user(){

echo \"what is your name \"

read name

echo \"Hello, \$name\"

}

greet\_user

Terminal:

What is your name

Abdullahi - user inputs name

Hello Abdullahi

[Piping]{.underline} 
--------------------

Piping uses the \| symbol to send the output of one command directly into another command as input.

[Example:]{.underline}

file\_count(){

local dir=\$1

local file

file=\$(ls \$dir \| wc -l)

echo \"number of files in \$dir:\$file\"

}

file\_count \"./\"

[output:]{.underline}

number of files in ./ 21

This function counted the number of files in the current working directory we were in. by using the pipe we were able to do this.

\[wc\] This command counts the number of lines words and characters, add the -l and it will count for amount of lines

\[awk\] Reads a line one line at a time and splits it up, so you can recall something back by adding \[awk { print \$1 } \] and it will give the first word only, goes from \$1,\$2,\$3 and so on.

[Error handling]{.underline} 
----------------------------

Error handling is used to detect problems and make sure that scripts can run smoothly without the whole thing collapsing and not working, so in a script it we will use it throughout, so it works perfectly.

[Example:]{.underline}

num1=10

num2=0

if \[ \$num1 -eq 0 \] \|\| \[ \$num2 -eq 0 \]; then

echo \"This operation can't be done with zero\"

exit 1

fi

results=\$((num1 / num2))

echo \"The answer is \$results\"

[output with error handling]{.underline}

This operation can't be done with zero

[Output without error handling]{.underline}:

line 8: num1 / num2: division by 0 (error token is \"2\")

The answer is

[Exit codes]{.underline}

Exit codes help indicate to us if the script ran successfully or ran into an error. It also helps pinpoint issues within the script as well.

command -v git 2\>/dev/null

if \[ \$? -ne 0 \]; then

echo "git is not installed, please install git"

exit 1

else

echo "git is installed"

fi

[output:]{.underline}

/usr/bin/git

git is installed

\[\$?\] This command shows us the last exit code of the last command

\[Command --v\] checks to see if a command/program exists in your system

[Changing the path permanently]{.underline} 
-------------------------------------------

Changing the path of a script and its directory its stored in allows us to run it from anywhere in the system, this method is best for doing it for multiple scripts.

Step1:

Create directory for the script:

Mkdir script\_store

Step2:

Create your script and its contents and make it executable

Vi script1

\[echo "Hello world"\]

Chmod+x script1

Step3:

Change the path by running this command

Echo "export PATH=\$PATH:\~/scripts\_store" \>\>\~/.bashrc or zshrc

Step4:

Source \~/.bashrc

Setp5:

You can now run the script anywhere

Script1

[Reading environment variables]{.underline} 
-------------------------------------------

When scripting you can print the different environment variables for example:

\$HOME

\$USER

\$PATH

\$OSTYPE

\$PWD

\$LOGNAME

All these variables can also be stored in local variables to make it easier when using them whilst scripting

[Reading files]{.underline} 
---------------------------

To read a file and gets its output while scripting you can use this function to do so

Read\_file(){

Local file\_path=\$1

While IFS= read --r line; do

Echo \$line

done \< file\_path

}

Read\_file "./applog.txt"

Output:

This will then print and show us all the contents of the logs we want

\[IFS= does not trim the spaces of at start or end of the line\]

\[read -r does not get rid of back slashes\]

Both these commands help keep the file being read intact and preserved
