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
  public void mainAttack(Player me){
    me.damage(2);
    System.out.println("player health: " + me.getHP());
  }
  public void secondaryAttack(Player me){
    int damage = (int)(Math.random() * 2 - 2) + 2;
    me.damage(damage);
    System.out.println("player health: " + me.getHP());
  }
}
