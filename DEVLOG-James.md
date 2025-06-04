# Dev Log:

This document must be updated daily every time you finish a work session.

## James Lei

### 2025-05-22 - Board Theory
- Completed work on the Tile class
- Created basic functionality for character
- Implemented the helper classes of resource and Coordinate
- Allowed Tiles to find other tiles within range

### 2025-05-23 - Displaying Board
- Moved code to Processing
- Stole pixel art from Fire Emblem
- Allowed board to be displayed
- Implemented pathfinding system for enemies
- Created functions to find movement range of characters
- Allowed characters to move via clicks
- Added different types of terrain

### 2025-05-27 - Beginning UI Work
- Created a basic UI setup to display health and movement
- Fixed rendering issue with enemies staying at their previous locations
- Stole a font for use in the UI

### 2025-05-28 - Creating Items
- Changed enemies to target the closest player
- Implemented the Consumable and HealthPotion classes
- Changed the way Resources are obtained from Character

### 2025-05-29 - Cleaning Up Development
- Created an ending message when everyone dies
- Fixed the implementation of various status effects
- Sorted out the way damage is dealt
- Reworked structure to allow for multiple character classes

### 2025-05-30 - More UI Work / Items
- Implemented chests that can store items for players
- Changed Enemy to abstract and prepared templates for character subclasses
- Added random spawning system for testing
- Added additional messages for turns and deaths

### 2025-05-02 - Even More UI Work
- Adapted game to be able to handle additional enemies
- Added buttons to view character inventories and stats

### 2025-05-03 - Additional Implementations
- Added functionality for ranged attacks
- Added button to attack nearby enemies
- Moved getTilesInRange and getTilesInRadius to Tile class
- Scaled up the game by a factor of 2