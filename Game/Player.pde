import java.util.Random;
public class Player extends Character {
  private Weapon weapon;

  public Player(String name, int maxHealth, int maxMovement, Tile startingPosition) {
    super(name, maxHealth, maxMovement, startingPosition, "Player");
  }

  public void giveWeapon(Weapon weapon){
    this.weapon = weapon;
    weapon.setWielder(this);
  }

  public void mainAttack(Enemy other) {
    if (weapon == null){
      other.damage(5);
    }
    else {
     weapon.mainAttack(other);
    }
  }
}
