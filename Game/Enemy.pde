public class Enemy extends Character {
  public Enemy(String name, int maxHealth, int maxMovement, Tile startingPosition) {
    super(name, maxHealth, maxMovement, startingPosition, "Enemy");
  }
  public void target(Player player) {
    ArrayList<Tile> path = getPosition().pathTo(player.getPosition());
    int index = 0;
    while (index < path.size() && moveTo(path.get(index))) {
      index++;
      System.out.println(getMovement());
    }
  }
}
