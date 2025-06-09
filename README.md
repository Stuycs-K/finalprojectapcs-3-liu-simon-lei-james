[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/YxXKqIeT)
# Project Description

This project is a turn-based strategy role-playing game taking inspiration from Fire Emblem, particularly the GBA games. Playable characters have a default weapon, and can be 6 different classes. There are 4 classes of enemies. Each class has unique abilities, weapon proficiencies, and stats. Characters can move to attack each other and the game ends when either the lord, all the players, or all the enemies, die. There are different tiles that affect movement and attacks. There are two different types of damage-magic and physical-and characters can apply different conditions. There are 5 different types of weapons, each with their own stats, strengths, and weaknesses. Weapons can also break. Consumables exist to provide temporary bonuses. Both consumables and items can be obtained from chests.

# Link to Final Video

https://drive.google.com/file/d/1fxfGfjH9pBCMHgLYzPUBtuCfTaE3GFDp/view?usp=sharing

# Intended usage:

Click on a character / tile in order to view the acitons you can take. The are buttons labelled 'Character Stats' (displays character stats), 'Attack' (highlights every enemy in the range of your weapon), 'End Turn' (stops the character from taking any more actions), and 'Inventory' (displays their inventory). Please wait for all the animations to end before moving. The GAME_SPEED constant can be adjusted to make the animations slower. (Lower is faster and 1 is the minimum.)

Key Binds:
- SPACE - End turn
- h - Increase health of all characters
- c - Increase chance of applying conditions
- a - Decreases chance of making attacks
- k - Increases chance of critting
- w - Increases the wear rate of weapons
- RIGHT_CLICK - Unhighlight

Maps are toggled by their respective numbers:
1. Only slime enemies
2. Only humanoid enemies
3. Spawn with a lot of chests
4. Characters spawn with special weapons
5. Characters spawn with consumables
6. Showcase weapon triangle
7. Only spawn one enemy

# Specifics

### Tiles
| Tile   | Movement Penalty | Hit Modifier | Dodge Modifier |
| :----- | :--------------- | :----------- | :------------- |
| Hills  | 3                | Bow: 50%     | +30%           |
|        |                  | Lance: 20%   |                |
|        |                  | Other: - 10% |                |
| Forest | 2                | None         | +20%           |
| Plains | 1                | None         | None           |

### Consumables
| Consumable | Uses | Effect                        |
| :--------- | :--- | :---------------------------- |
| Vulnerary  | 3    | Restores 10 HP                |
| Pure Water | 1    | Applies condition Pure Water  |

### Character Stats
| Stat       | Effect                                                      |
| :--------- | :---------------------------------------------------------- |
| Speed      | Increases likelihood of attacking twice and dodging attacks |
| Strength   | Decreases penalty from holding heavy weapons                |
|            | Increases damage dealt with physical weapons                |
| Skill      | Increases crit chance and likelihood of hittiing an enemy   |
|            | Decreases likelihood of getting critted                     |
| Defense    | Decreases damage received from physical weapons             |
| Magic      | Increases damage dealt with magic weapons                   |
| Resistance | Decreases damage received from magic weapons                |

### Character Classes
| Class       | Movement | Weapon Proficiencies | Role                | Additional Notes                     |
| :---------- | :------- | :------------------- | :------------------ | :----------------------------------- |
| Lord        | 5        | Swords               | Melee DPS           | Death ends the game                  |
| Archer      | 6        | Bows                 | Ranged Physical DPS |                                      |
| Barbarian   | 5        | Axes                 | DPS Tank            |                                      |
| Cavalier    | 8        | Swords, Lances, Axes | Mobile Melee DPS    |                                      |
| Mage        | 4        | Tomes                | Ranged Caster DPS   |                                      |
| Thief       | 6        | Swords               | Debuffer            | Higher chance of applying conditions |

### Enemy Classes
| Class     | Movement | Weapon Proficiencies | Role             | Additional Notes                    |
| :-------- | :------- | :------------------- | :--------------- | :---------------------------------- |
| Slime     | 5        | None                 | Debuffer         | Chance to apply poison with attacks |
| Soldier   | 5        | Lances               | Melee DPS        |                                     |
| Bully     | 5        | Axes                 | Tank             |                                     |
| Mercenary | 5        | Swords               | Mobile Melee DPS | Death ends the game                 |

### Weapon Stats
| Stat   | Effects                                      |
| :----- | :------------------------------------------- |
| Hit    | Increases likelihood of hitting an enemy     |
| Weight | Decreases likelihood of attacking twice      |
| Power  | Increases amount of damage dealt             |
| Range  | Distance from which an enemy can be attacked |

### Weapon Types
| Type  | Weak To | Strong Against | Max Range | Special Variants                |
| :---- | :------ | :------------- | :-------- | :------------------------------ |
| Sword | Lance   | Axe            | 1         | Sleep: Chance to apply sleep    |
|       |         |                |           | Brave: Attacks twice            |
| Lance | Axe     | Sword          | 1         | Javelin: Can attack at range    |
| Axe   | Sword   | Lance          | 1         | Killer: Increased crit chance   |
| Bow   | None    | None           | 2         | Sleep: Applies sleep on hit     |
| Tome  | None    | None           | 2         | Fireball: Increased crit chance |
|       |         |                |           | Thunder: Attacks twice          |
|       |         |                |           | Blizzard: Applies sleep on hit  |

### Conditions
| Condition  | Duration | Effect                                             |
| :--------- | :------- | :------------------------------------------------- |
| Sleeping   | 3        | Unit cannot move                                   |
| Bleeding   | 3        | Unit's defense is halved                           |
| Poisoned   | 3        | Unit takes 1/8 of their health as damage each turn |
| Pure Water | 4        | Unit's resistance is increased by 8                |
|            |          | Resistance decreases by 2 each turn                |