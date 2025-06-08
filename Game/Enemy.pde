abstract class Enemy extends Character {
  public Enemy(int maxHealth, int maxMovement, Tile startingPosition, String enemyClass, HashMap<String, Integer> stats, ArrayList<String> weaponProficiencies, Weapon weapon, boolean human) {
    super(maxHealth, maxMovement, startingPosition, enemyClass, stats, weaponProficiencies, weapon, human);
  }

  public void takeTurn() {
    if (!hasCondition("Sleeping")){
      int minDistance = -2;
      Player closestPlayer = null;
      for (int i = 0; i < players.size(); i++) {
        Player player = players.get(i);
        int distance = getPosition().distanceTo(player.getPosition());
        if (minDistance == -2 || minDistance > distance) {
          minDistance = distance;
          closestPlayer = player;
        }
      }
      if (closestPlayer == null) return;
  
      LinkedList<Tile> path = getPosition().pathTo(closestPlayer.getPosition());
      if (path == null) return;
  
      int index = -1;
      Resource movement = getMovement().copy();
      Tile current = null, next;
      while (!path.isEmpty()) {
        next = path.pop();
        if (!movement.consume(next.getMovementPenalty())) break; // No Movement
        current = next;
        index++;
      }
      if (index != -1) {
        moveTo(current);
      }
    }
  }
}
