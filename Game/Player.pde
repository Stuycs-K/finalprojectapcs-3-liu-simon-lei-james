public class Player extends Character {
  public Player(String name, int maxHealth, int maxMovement, Tile startingPosition) {
    super(name, maxHealth, maxMovement, startingPosition, "Player");
  }
  public void mainAttack(Enemy other) {
    other.damage(5); //replace with damage formula once weapons are implemented
    System.out.println("Enemy health: " + other.getHealth());
  }
  public void secondaryAttack(Enemy other) {
    int damage = (int)(Math.random() * 5) + 2;
    other.damage(damage);
    System.out.println("Enemy health: " + other.getHealth());
  }
}
