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

### 2025-05-30 - beginning implementation of character subclasses and magic
Character subclasses are now being created, Lord being the first. My intended implementation is for the program to pass a HashMap of generated stats into the function, then adding a base stat to each stat. Along with minor tweaks to other areas in the code, I am also starting to add magic to the game. Magic will act similarly to weapons, however damage will be calculated through the wielder's magic stat and the target's resistance stat rather than strength and defense. This will inevitably make magic hit harder than regular attacks since resistance will be lower than defense on all units except Mages, so measures will be taken to make sure Mages are properly balanced, like giving them worse movement or much worse physical bulk.

### 2025-05-31 - finished implementation of character subclasses and sprites
I have completed the subclasses for every character class, having given each unique stats, and made minor adjustments to some files to match proper syntax and the updated uml diagram. Additionally, i have added a sprite for each of the new classes.

### 2025-06-01 - minor bug fixes, finished basic weapon implementation, small balance changes
Every character now starts with a weapon. Weapons have been tested to ensure they all work as intended, and stats have been minorly tweaked, particularly for slimes to make them bulkier. Attacks are now rounded up to do zero damage if the calculation shows they will do less than or equal to zero damage. Lastly, the number of slimes on the field has increased, and they have been given an actual attack.

### 2025-06-02 - edited sprites and started working on weapon constructors that use hashmaps
Not much was done due to problems with the font file and thus a lack of sufficient testing. I have created better sprites for the characters, though I have kept the original files still in the game folder if we need them. Additionally, I've begun implementing constructors for the weapons that take a hashmap as a parameter.

### 2025-06-03 - started implementation of human enemies
I have begun implementing human enemies that can use weapons, starting with Soldier. Along with soldiers, I have also added lances to the game, and I am also going to implement the weapon triangle into the game. This is a mechanic in Fire Emblem where swords hit harder and are more accurate against axes, axes hit harder and are more accurate against lances, and lances have the same effect on swords. I plan to implement accuracy soon as well.

### 2025-06-04 - balancing
I tweaked some code and balanced the unit stats. I also wrote up the README. I was unable to work at home due to junior prom.

### 2025-06-05 - moved Weapon to character, implemented weapon triangle and hit chances
To help with implementing the weapon triangle, I've moved over the weapon methods to the Character class. The weapon triangle is a mechanic in Fire Emblem where swords, axes, and lances are all more effective against the next weapon but less effective against the previous. This is due to both an increase in weapon might and hit rate during combat. Speaking of hit rate, I have implemented that as well. The formula is copied over from Fire Emblem, calculated mainly through the attacker's skill, their weapon's hit, and their enemy's avoid. I may add a luck stat to add to avoid, if I do then I may implement a critical hit rate formula.

### 2025-06-06 - cavalier, minor code alterations
I started the implementation on the Cavalier class, and made slight changes to some of the code, including an alteration to the hit formula that accounts for units that don't use weapons. A few bug fixes were also made.

### 2025-06-07 finishing touches, new boards, finished cavalier and two enemy humanoid classes, added tiles to the hit formula
I made boards to showcase unique weapons, characters starting with consumables, and the weapon triangle. The cavalier class was finished and I decided to make two new enemy subclasses, those being the bully and the mercenary. These are meant to fulfill the weapon triangle, and makes displaying it in the weapon triangle board easier. Lastly, I've added the tiles into the hit formula. The formula now checks the target's tile and adds to their avoid depending on it, and may even add to the wielder's hit.
