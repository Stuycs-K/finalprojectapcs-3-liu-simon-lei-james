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
     if other.
    }
    System.out.println("Enemy health: " + other.getHealth());
  }
  public void secondaryAttack(Enemy other) {
    int damage = (int)(Math.random() * 5) + 2;
    other.damage(damage);
    System.out.println("Enemy health: " + other.getHealth());
  }
}
