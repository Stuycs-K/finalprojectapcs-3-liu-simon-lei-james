public class Enemy extends Character {
  public Enemy(String name, int maxHealth, int maxMovement, Tile startingPosition) {
    super(name, maxHealth, maxMovement, startingPosition, "Enemy");
  }
  public void target(Player player) {
    ArrayList<Tile> path = getPosition().pathTo(player.getPosition());
    int index = -2;
    Resource movement = getMovement();
    for (Tile tile : path) {
      if (movement.consume(board.movementPenalties.get(tile.getTerrain()))) index++;
    }
    if (index != -1) moveTo(path.get(index));
  }
}
