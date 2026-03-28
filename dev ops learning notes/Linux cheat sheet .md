**Linux & DevOps Cheat Sheet**

**File Commands**

-   touch → create empty file

-   echo → print/write text to file (\> overwrite, \>\> append)

-   cat → view file contents / combine files

-   grep → search for text in files

-   head → view first 10 lines (or -n for specific lines)

-   tail → view last 10 lines (or -n)

-   Pipes \| → combine commands (head -n 5 file \| tail -n 2)

-   Grep -n shows the line number as well of the text

-   nl file.txt will show line numbers of a file

**File Operations**

-   cp → copy files/directories (-r for directories) (/\*.txt for all them files)

-   mv → move/rename files or directories

-   rm → remove files

-   rm -r → remove directories with contents

-   mkdir → create directories (-p for nested)

-   rmdir → remove empty directories

-   Handle spaces in names → quotes \" \" or backslash \\

**Vim Basics**

-   Modes: **Command**, **Insert (I)**, **Visual (V)**

-   Delete: x (char), dw (word), dd (line)

-   Copy/Paste: yw (word), yy (line), p (paste)

-   Navigation: 0 (start line), \$ (end line), :number (go to line)

-   Undo/Redo: u / Shift+R

-   Find: /word → next n, previous N

-   Syntax highlighting: :syntax on

-   Line numbers: :set number / :set nonumber

**Shell & Environment**

-   bash → default shell

-   echo \$SHELL → check shell

-   echo \$PATH → directories Linux searches for commands

-   cat /etc/shells → list installed shells

-   sudo apt-get → manage software packages

-   zsh → alternative shell, change with chsh -s \$(which zsh) \$(whoami)

**Linux File System**

-   / → root directory

-   /home → user folders

-   /etc → system/config files

-   /bin → essential commands

-   /var → changing data (logs, temp)

-   /usr → user-installed programs

-   /tmp → temporary files

-   /lib → shared libraries

-   /root → root home

-   /dev → device files

-   /boot → boot files

-   cd \~ → go to home

-   cd / → go to root

-   cd \~/. + Tab → navigate hidden dirs

**Users & Groups**

-   sudo useradd → create user

-   sudo passwd → set user password

-   su - → switch user

-   sudo usermod -aG group user → add user to group

-   sudo deluser user sudo → remove sudo

-   sudo groupadd → create group

-   sudo gpasswd -d user group → remove user from group

-   sudo groupdel → delete group

**Permissions & Sudo**

-   ls -l → show type, permissions, owner, group, size, date

-   ls -a to show hidden files

-   Permissions: r=read, w=write, x=execute (owner/group/others)

-   \- = file, d = directory

-   Number after permissions = link count

-   sudo → run command with admin privileges

-   sudo su → switch to root

**Linux Permission**

-   **Permission values:**

    -   r = 4

    -   w = 2

    -   x = 1

    -   -- = 0

-   **Common permission sets:**

    -   rwx = 7

    -   rw- = 6

    -   r-x = 5

    -   r-- = 4

    -   -wx = 3

    -   -w- = 2

    -   --x = 1

    -   --- = 0

-   **How to convert to octal:**

    -   Split permissions into **3 groups**: owner \| group \| others

    -   Add the values within each group

    -   Combine the three results into one number (e.g., 7 5 0 → **750**)

-   **Example:**

    -   rwxr-x\-\-- → owner = 7, group = 5, others = 0 → **750**

**chmod (Symbolic)**

-   **Example file:**

> ls -l file.txt → -rw-r\--r\--

-   **Add permission (user execute):**

> chmod u+x file.txt
>
> → becomes -rwxr\--r\--

-   **Remove permission (group write):**

> chmod g-w file.txt

-   **Add multiple permissions:**

> chmod u+x,g+r,o-w file.txt

**Permission Values**

-   **Read = 4**

-   **Write = 2**

-   **Execute = 1**

**How to Build a Permission Number**

-   Add the numbers:

    -   **7 = 4+2+1 (rwx)**

    -   **6 = 4+2 (rw-)**

    -   **5 = 4+1 (r-x)**

    -   **4 = 4 (r--)**

    -   **2 = 2 (-w-)**

    -   **1 = 1 (--x)**

    -   **0 = 0 (---)**

**Order of Digits**

-   **1st = Owner**

-   **2nd = Group**

-   **3rd = Others**

**Running the Command**

-   chmod 750 file.txt

    -   Owner: 7 → rwx

    -   Group: 5 → r-x

    -   Others: 0 → ---

**Common Examples**

-   chmod 755 file → Owner rwx, Group r-x, Others r-x

-   chmod 644 file → Owner rw-, Group r--, Others r--

-   chmod 700 file → Owner rwx only

-   chmod 600 file → Owner rw only

-   can also do it as chmod ug=rw,o=x file.txt.

**Change Owner**

-   sudo chown username file → change owner only

-   sudo chown username:group file → change owner AND group

-   -R recursive, apply owner/group changes to **all files and subdirectories** Example: sudo chown -R newuser:admin2 my-dir/

**Change Group**

-   sudo chgrp group file → change group only

**Check Owner & Group**

-   ls -l → shows permissions, owner, and group

    -   Format: -rwxrwxrwx owner group size date file

**Output/Input Redirection**

-   \> → send output to a file (overwrite)

-   \>\> → send output to a file (add to end)

-   \< → read input from a file

-   2\> → send error messages to a file

-   &\> → send output **and** errors to a file /dev/null

**Examples:**

-   echo \"text\" \> file.txt → put text in file

-   cat \< file.txt → show file contents

-   ls fake 2\> error.txt → save error message

-   ls fake my-dir &\> alloutputs.txt → save output and errors

**Linux Scripting & Environment Variables**

-   **Temporary variable**: export MY\_VAR=\"Hello world\"

-   **Show variable value**: echo \$MY\_VAR

-   **Permanent variable**:

    1.  vim .zshrc

    2.  Press i (insert mode)

    3.  Write MY\_VAR=\"Hello world\" at the bottom

    4.  Save and exit Vim

    5.  Apply immediately: source .zshrc

-   **PATH variable**: \$PATH → directories shell searches for commands

-   **Add directory to PATH**: export PATH=\$PATH:/home/ubuntu

-   **Scripts**:

    -   Edit script: vim greet.sh

    -   Make executable: chmod +x greet.sh

    -   Run script: ./greet.sh

**Aliases**

-   Temporary alias: alias name=\'command\'

-   Example: alias hello=\'echo Hello world\'

-   Permanent alias:

    1.  Open .zshrc: vim .zshrc

    2.  Press i (insert mode) and add: alias hello=\'echo \"Hello world\"\' at the bottom

    3.  Save and exit Vim :wq!

    4.  Apply immediately: source .zshrc

-   Run alias: type its name (e.g., hello)

**File search**

-   **Search by name:**

> find . -name \"file.txt\"

-   **Search by type:**

> find . -type f (files)
>
> find . -type d (directories)

-   **Search by size:**

> find . -size +10M (bigger than 10MB)
>
> find . -size -500k (smaller than 500KB)
>
> find . -size 1033c (exactly 1033 bytes)

-   **Search by last modified:**

> find . -mtime -1

-   **Search by permissions:**

> find . -perm 644

-   **Delete matching files:**

> find . -name \"\*.tmp\" -delete

-   **By user**

> Find -user (lets you find by username)

**SED **

**Print lines**

-   **Print a specific line:**

> sed -n \'5p\' file.txt
>
> → shows only line 5

-   **Print a range of lines:**

> sed -n \'3,7p\' file.txt
>
> → shows lines 3 to 7

**Search & Replace**

-   **Replace first match on each line:**

> sed \'s/old/new/\' file.txt
>
> → only replaces the *first* "old" on each line

-   **Replace all matches on each line:**

> sed \'s/old/new/g\' file.txt
>
> → replaces *every* "old" on each line

-   **Replace inside the file (permanent):**

> sed -i \'s/old/new/g\' file.txt
>
> → saves the changes to the file

**Delete lines**

-   **Delete a specific line:**

> sed \'5d\' file.txt
>
> → removes line 5 from output

-   **Delete a range of lines:**

> sed \'3,7d\' file.txt
>
> → removes lines 3 through 7 from output

**Pattern-based print/delete**

-   **Print lines containing a word:**

> sed -n \'/pattern/p\' file.txt
>
> → only shows lines that match

-   **Delete lines containing a word:**

> sed \'/pattern/d\' file.txt
>
> → hides all matching lines

**Useful flags**

-   **-n** → don't print everything (only what you explicitly print)

-   **-i** → change the file permanently

**SORT**

**Basic**

-   **Sort file alphabetically (A--Z):**

> sort file.txt

-   **Reverse order (Z--A):**

> sort -r file.txt

**Numbers**

-   **Sort by number instead of text:**

> sort -n file.txt

-   **Sort numbers reverse:**

> sort -nr file.txt

**Ignore case (A=a):**

sort -f file.txt

**Sort by a specific column (space/tab separated):**

sort -k 2 file.txt

(Sort using column 2)

**Unique sort (remove duplicates automatically):**

sort -u file.txt

**Sort by delimiter (e.g., comma):**

sort -t \',\' -k 2 file.csv

**UNIQ**

*(Remember: uniq only works properly on **sorted** input.)*

**Basic**

-   **Remove consecutive duplicate lines:**

> uniq file.txt

**Show only duplicate lines:**

uniq -d file.txt

**Show only unique (non-duplicate) lines:**

uniq -u file.txt

**Count occurrences:**

uniq -c file.txt

Output example:

3 apple → "apple appeared 3 times"

**Case-insensitive:**

uniq -i file.txt

**Full Dedup Pipeline (common use):**

-   **Sort + remove all duplicates:**

> sort file.txt \| uniq

-   **Sort + show only lines that appear once:**

> sort file.txt \| uniq -u

-   **Sort + show only lines that appear more than once:**

> sort file.txt \| uniq -d

**Strings**

-   **Show readable text in a file:**

> strings file

-   **Only show text with at least X characters:**

> strings -n X file

-   **Look for specific words in the text:**

> strings file \| grep word

-   **Check all parts of a file:**

> strings -a file

-   **Check only data parts of a file:**

> strings -d file

-   **Find passwords or hints in a program/file:**

> strings file \| grep pass

**base64**

-   **Encode a file to base64:**

> base64 file

-   **Decode a base64 file:**

> base64 -d file

-   **Encode text directly:**

> echo \"text\" \| base64

-   **Decode text directly:**

> echo \"base64text\" \| base64 -d

-   **Purpose:**

    -   Convert binary to text

    -   Safely send or store data in text form

    -   Extract hidden info from files

-   **Important:**

    -   Base64 is **encoding, not encryption**

    -   Anyone can decode it

ZjLjTmM6FvvyRnrb2rfNWOZOTa6ip5If

263JGJPfgU6LtdEvgfWU1XP5yac29mFx

MNk8KNH3Usiio41PRUEoDFPqfxLPlSmx

2WmrDFRmJIq3IPxneAaMGhap0pFhF3NJ

4oQYVPkxZOOEOO5pTW81FB8j8lxXGUQw

HWasnPhtq9AVKe0dmk45nxy20cvUa6EG

morbNTDkSW6jIlUc0ymOdMaLnOlFVAaj

dfwvzFQi4mU0wfNbFOe9RoWskMLg7eEc

4CKMh1JI91bUIZZPXDqGanal4xvAg0JM

FGUW5ilLVJrxX9kMYMmlN4MgbpfMiqey

dtR173fZKb0RRsDFSGsg2RWnpNVj3qRr
