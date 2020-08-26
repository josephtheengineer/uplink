# CatalystOS. Component And Textual-based Advanced Linux YAML System Terminal Operating System

# Dependices
## alpine linux
- git
- blender
- godot
- vulkan drivers / mesa
- ssh
- sshfs
- *more soon*

# Functions
## Commands
### cmd/calendar/calendar.c
cmd_calendar()
### cmd/program_name/program_name
cmd_*inset_program_name_here*

## Systems (Services)
### sys/client.c
sys_client_new()
sys_client_close()
### sys/server.c
sys_server_connect()
### sys/ui.c
sys_ui_new()

# AGPL3
licence.md
header.md

https://www.gnu.org/licenses/gpl-howto.html
https://www.gnu.org/graphics/agplv3-with-text-162x68.png

# Commands & arguments
calendar home -verbose=4 -lol=234 -mc-support=9
[command] [subcommand] -[option]=[value]

## calendar
TaskWarrior alone is a great productivity tool, but during daily use I find
that the user interface is a rather unintuitive and does not allow for looking
at tasks in more calendar-ish way.

### Home page (based of calcurse)

##############################
# Today          #  Calendar #
#                # [][][][][]#
#8  ###########  # [][][][][]#
#9  #  task   #  #############
#10 ###########  #Todo Today #
#11              #1. task    #
#12 Task2        #1. task2   #
#13              #############
#14              # Tomorrow  #
##############################

### calendar start
--------------------
  Add new tasks
--------------------
Task: Finish
      Finish folder script
      Finish sway config

Task: Finish readme
Search: No matches

Time allocation: 1h
Due Date: 5w
Urgency: M
Difficulty: M
Enjoyability: M
Type: writing, creative
dependencies: none
project: taskwarrior-calendar
sub-project: docs
Notes: (open vim)
Recur: no

Timeslot: 2d 10->11
Recommended: 2d 10->11 3w 14-16 4w 17-18

Task created!

# Program Structure
.
├── aux
├── doc
│   ├── header.md
│   ├── help.md
│   ├── license.md
│   ├── notice.md
│   ├── readme.md
│   ├── style.md
│   └── tags
├── inc
│   ├── array.h
│   ├── cmd
│   │   ├── calendar
│   │   │   ├── calendar.h
│   │   │   ├── help.h
│   │   │   └── main.h
│   │   ├── cmd.h
│   │   ├── help.h
│   │   ├── main.h
│   │   ├── opt
│   │   │   └── verbose.h
│   │   └── version.h
│   ├── cmd.h
│   ├── colors.h
│   ├── console.h
│   ├── entity.h
│   ├── err.h
│   ├── file.h
│   ├── main.h
│   ├── msg.h
│   ├── sys
│   │   ├── client.h
│   │   ├── server.h
│   │   ├── task.h
│   │   └── ui.h
│   ├── sys.h
│   └── ui.h
├── out
│   ├── bin
│   └── man
├── run
│   └── makefile
├── src
│   ├── array.c
│   ├── cmd
│   │   ├── calendar
│   │   │   ├── calendar.c
│   │   │   ├── help.c
│   │   │   └── main.c
│   │   ├── cmd.c
│   │   ├── help.c
│   │   ├── main.c
│   │   ├── opt
│   │   │   └── verbose.c
│   │   └── version.c
│   ├── cmd.c
│   ├── colors.c
│   ├── console.c
│   ├── entity.c
│   ├── err.c
│   ├── file.c
│   ├── main.c
│   ├── msg.c
│   ├── sys
│   │   ├── client.c
│   │   ├── server.c
│   │   ├── task.c
│   │   └── ui.c
│   ├── sys.c
│   └── ui.c
└── tst
