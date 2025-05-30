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

### 2025-05-28 - implemented stats and conditions
I started implementation of conditions, creating the class as well as making some basic status conditions like poison and sleep. I plan to add other conditions later, like berserk (units become unable to be controlled for 3 turns and will target both player characters and enemies) or silence (units can't use magic, which will be implemented later). Additionally, stats were also implemented to go with the status conditions, and the mainAttack of player character has been altered accordingly.

### 2025-05-29 - implementation of weapon classes
I have begun creating the weapon classes. Sword, Axe, and Bow all have a barebones class, and I intend to add more types to them, along with potentially other weapons like lances. For now, accuracy and hit rates will be left for later, once other more essential features are added.
