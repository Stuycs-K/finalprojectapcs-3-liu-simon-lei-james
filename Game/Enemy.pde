import java.util.Random;
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
    Resource movement = getMovement().copy();
    Tile current = null, next;
    while (!path.isEmpty()) {
      next = path.pop();
      if (!movement.consume(next.getMovementPenalty())) break; // No Movement
      current = next;
      index++;
    }
    if (index != -1) moveTo(current);
  }
  public void mainAttack(Player me){
    me.damage(2);
    System.out.println("player health: " + me.getHealth());
  }
  public void secondaryAttack(Player me){
    Random rand = new Random();
    int damage = (rand.nextInt(2) - 2) + 2;
    me.damage(damage);
    System.out.println("player health: " + me.getHealth());
  }
}
