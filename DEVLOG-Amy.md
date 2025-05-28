# Dev Log:

This document must be updated daily every time you finish a work session.

## Simon Liu

### 2025-05-22 - Began work on coding the Game class
Around half of the class period was spent on writing the Game class. Some of the fields and the functions require the presence of the other classes, namely Tile and Character, so those had to be commented out for the time being.

### 2025-05-23 - Implementing attacks, healing, and a turn cycle
Much of class time was spent on implementing a way to determine what turn it was, as well as how it would switch to the other team. At present, the idea is to switch once all units on the player team have moved or once the player has decided to finish the turn if it's the player's turn, and for it to automatically end once every enemy has moved on the enemy turn. Basic implementation on attacks and heals was also created.

### 2025-05-27 - expanded attacks, implementation of the Weapon class, and killing
The Game processing folder was pulled, to gain a more accurate understanding of how the game would run to better implement functions. Placeholder attack functions will be used until the Weapon class is fully added, which will be how the game actually determines damage.
At home, significant progress was made to developing the attack functions, with certain functions in other files being slightly altered to allow checking for a character's Health easier. A mainattack function was added for each class that had it, and a secondaryAttack function was also implemented, however what it does will change based on the weapon. Additionally, a turn cycle was fully established, as well as a way to kill units by removing them from the board and the ArrayList after their health reaches zero.
