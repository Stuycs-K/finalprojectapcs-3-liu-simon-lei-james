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
      if (current.getEntity().equals("Player")) {
        mainAttack(board.getPlayer(current));
        Tile copy = current;
        int indexCopy = index;
        Thread thread = new Thread(() -> {
          for (int i = 0; i <= indexCopy; i++) {
            int start = TICK;
            while (TICK == start) sleep(1);
          }
          copy.transform("Red");
          int start = TICK;
          while (TICK == start) sleep(1);
          copy.transform("None");
        });
        thread.start();
      }
    }
  }
  public void mainAttack(Player other){
    other.damage(2);
  }
  public void secondaryAttack(Player other){
    int damage = (RANDOM.nextInt(2) - 2) + 2;
    other.damage(damage);
  }
}
