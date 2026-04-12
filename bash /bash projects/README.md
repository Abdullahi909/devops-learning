# Bash Automation Scripts

A collection of Bash scripts for common Linux system administration tasks.

## Scripts

### `file-organiser.sh`
Sorts files in a messy directory into subfolders by file extension.

```bash
./file-organiser.sh ~/Downloads
# Creates: pdf-files/, jpg-files/, txt-files/ etc.
```

### `system-info.sh`
Displays system information: OS, kernel, CPU, memory, disk, and network.

```bash
./system-info.sh
```

### `user-setup.sh`
Creates a new Linux user with a group, home directory, and default folders.

```bash
sudo ./user-setup.sh
```

### `backup.sh`
Creates a timestamped compressed backup of any folder.

```bash
./backup.sh /home/abz/projects /home/abz/backups
# Creates: projects_backup_2026-04-12_143000.tar.gz
```

## How to Use

```bash
git clone https://github.com/Abdullahi909/bash-scripts.git
cd bash-scripts
chmod +x *.sh
./system-info.sh
```

## What These Scripts Cover

- Variables and user input (`read`, `$1`, `$2`)
- Conditionals (`if/else`, `-z`, `-d`, `-f`)
- Loops (`for`)
- Functions and command substitution
- File and directory operations (`mkdir`, `mv`, `tar`, `chmod`, `chown`)
- Text processing (`grep`, `awk`, `cut`, `tr`)
- Exit codes and error handling

## Author

Abdullahi Mohamed — [abdullahimohamed.uk](https://abdullahimohamed.uk)
