Pacman
======

This is the original UNIX version of the Pac-Man game.  Posted to the
net.sources newsgroup as public domain in 1982 by Mark Horton.

The games was originally written by Dave Nixon while at AGS Computers
Inc., in July 1981.  It was converted to curses in Feb 1982 by Mark
Horton.


Screenshots
-----------

```
#######################################      SCORE:      0       GAME: EASY
# . . . . . . . . ### . . . . . . . . #
# O ### . ##### . ### . ##### . ### O #
# . . . . . . . . . . . . . . . . . . #
# . ### . # . ########### . # . ### . #
# . . . . # . . . ### . . . # . . . . #
####### . ##### . ### . ##### . #######
      # . # . . . . . . . . # . #
      # . # . ### - - ### . # . #
####### . # . #         # . # . #######
        . . . # B I P C # . . .
####### . # . #         # . # . #######
      # . # . ########### . # . #
      # . # . . . . . . . . # . #
####### . # . ########### . # . #######
# . . . . . . . . ### . . . . . . . . #
# O ### . ##### . ### . ##### . ### O #
# . . # . . . . . @ . . . . . . # . . #
### . # . # . ########### . # . # . ###
# . . . . # . . . ### . . . # . . . . #
# . ########### . ### . ########### . #
# . . . . . . . . . . . . . . . . . . #      gold left =    185
#######################################      delay = 500, refresh =   1
@  @

```


Instructions
------------

Attention: you are in a maze, being chased by monsters!

There is food scattered uniformly in the maze, marked by ".".
One magic potion is available at each spot marked "O". Each potion will
enable you to eat monsters for a limited duration. It will also
scare them away. When you eat a monster it is regenerated, but this takes
time. You can also regenerate yourself 3 times. Eating all the monsters
results in further treasure appearing magically somewhere in the dungeon,
marked by "$". There is a magic tunnel connecting the center left and
center right parts of the dungeon. The monsters know about it!

        Type:   h or s  to move left
                l or f  to move right
                k or e  to move up
                j or c  to move down
                <space> to halt
                q       to quit

        Type:   1       easy game
                2       intelligent monsters
                3       very intelligent monsters


Download & Build
----------------

The [latest sources][master] are avilable on GitHub.  Download and
unpack in the usual manner.

To build you need ncurses, a C compiler, and make.  On Ubuntu or other
Debian GNU/Linux based systems you can get this using:

    sudo apt install build-essential libncurses5-dev

Other Linux systems have similar packages.  On FreeBSD you don't need
anything in particular as long as you can fetch the tarball and have
a working `cc` and `make`.

FreeBSD users can also download the true original from this mailing
list entry https://marc.info/?l=freebsd-hackers&m=94345990014968&w=2

[master]: https://github.com/troglobit/pacman/archive/master.tar.gz
