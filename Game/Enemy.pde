public class Enemy extends Character {
  public Enemy(String name, int maxHealth, int maxMovement, Tile startingPosition) {
    super(name, maxHealth, maxMovement, startingPosition, "Enemy");
  }
  public void takeTurn() {
    int minDistance = -2;
    Player closestPlayer = null;
    for (Player player : players) {
      int distance = getPosition().distanceTo(player.getPosition());
      if (minDistance == -2 || minDistance > distance) {
        minDistance = distance;
        closestPlayer = player;
      }
    }
    
    LinkedList<Tile> path = getPosition().pathTo(closestPlayer.getPosition());
    
    int index = -1;
    Resource movement = getMovement();
    Tile current = null, next;
    while (!path.isEmpty()) {
      next = path.pop();
      if (!movement.consume(board.movementPenalties.get(next.getTerrain()))) break; // No Movement
      current = next;
      index++;
    }
    if (index != -1) moveTo(current);
  }
}
