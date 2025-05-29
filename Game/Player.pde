import java.util.Random;
public class Player extends Character {
  private Weapon weapon;

  public Player(String name, int maxHealth, int maxMovement, Tile startingPosition) {
    super(name, maxHealth, maxMovement, startingPosition, "Player");
  }

  public void giveWeapon(Weapon weapon){
    this.weapon = weapon;
  }

  public void mainAttack(Enemy other) {
    if (weapon == null){
      other.damage(5); //replace with damage formula once weapons are implemented
    }
    else{
     int damage = weapon.mainAttack(this);
     other.damage(damage);
     consumeActions(2);
    }
  }
  public void secondaryAttack(Enemy other) {
    Random rand = new Random();
    int damage = rand.nextInt(5) + 2;
    other.damage(damage);
  }
}
