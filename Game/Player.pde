public class Player extends Character {
  private ArrayList<String> weaponProficiencies;
  private Weapon weapon;
  private ArrayList<Item> inventory;
  
  public Player(int maxHealth, int maxMovement, Tile startingPosition, String characterClass, HashMap<String, Integer> stats, ArrayList<String> weaponProficiencies) {
    super(maxHealth, maxMovement, startingPosition, characterClass, stats);
    this.weaponProficiencies = weaponProficiencies;
  }
  
  public void giveItem(Item item) {
    inventory.add(item);
  }
  
  public ArrayList<Weapon> getWeapons() {
    ArrayList<Weapon> output = new ArrayList<Weapon>();
    for (Item item : inventory) {
      if (item instanceof Weapon) {
        output.add((Weapon) item);
      }
    }
    return output;
  }

  public void equip(Weapon weapon){
    if (weaponProficiencies.contains(weapon.getType())) {
      this.weapon = weapon;
    }
  }

  public void attack(Enemy other) {
    if (weapon == null){
      other.damage(5);
    }
    else {
     weapon.attack(this, other);
    }
  }
}
