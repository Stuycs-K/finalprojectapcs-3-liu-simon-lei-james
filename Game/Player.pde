public class Player extends Character {
  private Weapon weapon;

  public Player(int maxHealth, int maxMovement, Tile startingPosition, String characterClass, HashMap<String, Integer> stats) {
    super(maxHealth, maxMovement, startingPosition, characterClass, stats);
    
  }

  public void giveWeapon(Weapon weapon){
    this.weapon = weapon;
  }

  public void mainAttack(Enemy other) {
    if (weapon == null){
      other.damage(5);
    }
    else {
     weapon.attack(this, other);
    }
  }
}
