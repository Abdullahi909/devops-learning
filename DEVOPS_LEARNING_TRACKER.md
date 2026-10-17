# DevOps Learning Tracker

## Purpose

This is the running reference for Abdullahi's DevOps learning. We will update it after each study session so the next session starts with clear context: what is understood, what needs practice, what was completed, and what comes next.

## Goals

- Progress through the CoderCo DevOps Academy while building durable, practical skills.
- Become confident troubleshooting Linux systems rather than only recalling commands.
- Turn completed learning into small, documented portfolio projects.
- Continue AWS in parallel so course progress does not stall.

## Current position — 19 July 2026

### Course progress

- Linux Fundamentals — completed previously; revision now active.
- Bash scripting — completed previously; needs confidence-building through practical scripting.
- Git — completed previously; some concepts need refreshing.
- Networking — completed previously; conceptual revision needed.
- Docker — effectively complete; course progress was not fully marked, and it felt challenging.
- AWS — current main course module.
- Terraform, CI/CD, Kubernetes — upcoming.

### Linux baseline

- Has working notes and has completed Bandit through level 10.
- Knows common file, navigation, permission, user/group, redirection, search, and text-processing commands.
- Needs to reconnect concepts through hands-on troubleshooting.
- Tried SadServers but felt blocked by knowledge gaps; this is the practical benchmark to return to after foundations are reinforced.

### Bash baseline

- Has written and run Bash scripts in VS Code.
- Has covered shebangs, variables, arguments, arithmetic, conditionals, loops, functions, user input, pipes, `awk`, and basic error handling.
- Current focus: turning familiar syntax into confident task-solving, with safe scripting habits and debugging.

## Learning method

For each topic:

1. Recall the concept without notes.
2. Practise it in a small command-line lab.
3. Explain what happened and why.
4. Save a short solution or script in this repository when useful.
5. Revisit it after a gap using a practical scenario.

### Learning agreement

- Saying **skip** means the topic is currently understood well enough to move past.
- A skipped topic is only revisited if it creates a clear blocker in a later lab or troubleshooting scenario.
- Progress is based on demonstrated understanding and practical use, not on spending time re-reading familiar material.

## Complete Linux roadmap

### DevOps core — required

- [x] 1. Linux mental model — terminal, shell, command lookup, environment variables, filesystem hierarchy, help, and man pages.
  - [x] Current working directory, home directory, root directory, and absolute versus relative paths.
  - [x] Difference between a command, a file, and a directory; choosing `cd` versus a file-reading command.
  - [x] Basic `PATH` lookup and using `command -v` to identify an executable.
  - [x] Shell, environment variables, command options, arguments, help, and man pages.
- [ ] 2. Files and text streams — navigation, files/directories, globbing, `find`, `grep`, `less`, pipes, redirects, `sed`, `awk`, `sort`, and `uniq`.
- [ ] 3. Users, groups, and permissions — ownership, `sudo`, `chmod`, `chown`, ACL awareness, and the difference between file and directory permissions.
- [ ] 4. Processes and job control — `ps`, `top`/`htop`, signals, `kill`, foreground/background jobs, and process trees.
- [ ] 5. Services, systemd, and logs — `systemctl`, units, service states, boot-time services, `journalctl`, and application/system logs.
- [ ] 6. Storage and resources — `df`, `du`, inodes, mounts, `lsblk`, memory, CPU, load, swap, and finding resource pressure.
- [ ] 7. Software and configuration management — packages, repositories, updates, configuration files, cron/systemd timers, and change verification.
- [ ] 8. Networking on Linux — IP addresses, routes, DNS, ports, sockets, HTTP, `ip`, `ss`, `curl`, `dig`, `ping`, and traceroute.
- [ ] 9. Remote administration — SSH, SSH keys, secure file transfer, `rsync`, remote commands, and `.ssh` permissions.
- [ ] 10. Bash automation — safe scripts, arguments, quoting, validation, conditions, loops, functions, exit codes, logs, and debugging.
- [ ] 11. Linux security basics — least privilege, updates, secrets, SSH hardening, firewall basics, file permissions, and log review.
- [ ] 12. Troubleshooting workflow — establish symptoms, collect evidence, form a hypothesis, fix safely, verify, and record the lesson.
- [ ] 13. Real-world Linux practice — short labs, incident scenarios, and selected SadServers problems using a written diagnostic process.

### Advanced Linux — mastery track

- [ ] 14. Boot and operating-system internals — kernel, boot process, initramfs, system calls, modules, and `dmesg`.
- [ ] 15. Advanced storage — partitioning, filesystems, LVM, RAID concepts, backups, restore testing, NFS, and storage troubleshooting.
- [ ] 16. Advanced networking — `nftables`/firewall rules, network namespaces, bridges, NAT, TLS basics, and load-balancer concepts.
- [ ] 17. Isolation and containers — processes versus containers, namespaces, cgroups, capabilities, volumes, and container networking.
- [ ] 18. Security hardening and observability — AppArmor/SELinux awareness, auditing, monitoring, alerting, performance analysis, and capacity planning.
- [ ] 19. Reliability and recovery — incident response, backups, disaster recovery, high availability concepts, and post-incident reviews.

### Definition of done

The DevOps core is complete when you can connect to an unfamiliar Linux server, identify its role and current state, safely investigate common failures, make a justified fix, verify the result, and automate repetitive tasks.

The advanced track is ongoing. It is where strong administrators become deeply experienced Linux engineers through repeated work on real systems and incidents.

## Active focus

**Linux revision in parallel with AWS.**

Start with a practical Linux baseline session: navigate the filesystem, inspect files and permissions, filter command output, and explain the result of each command. This will identify exactly what needs review before moving into services, logs, and networking.

## Session log

| Date | Focus | What we covered | Result | Next step |
| --- | --- | --- | --- | --- |
| 2026-07-19 | Baseline and planning | Reviewed Linux and Bash study notes; identified that the key need is practical fluency and troubleshooting, not restarting from zero. Expanded the roadmap into DevOps core and advanced mastery tracks. | Linux revision plan started; AWS remains active in parallel. | Run Linux baseline lab: navigation, files, permissions, pipes, and explanation. |

## Evidence to build

- Small Bash utilities with clear README instructions.
- Linux troubleshooting write-ups: symptom, investigation, fix, verification, lesson.
- AWS labs and infrastructure projects.
- Later: Terraform, CI/CD, and Kubernetes projects that build on the same application or environment.

## Update rule

At the end of every study session, update:

- completed roadmap items;
- what felt easy, uncertain, or difficult;
- practical evidence created;
- one specific next step.
