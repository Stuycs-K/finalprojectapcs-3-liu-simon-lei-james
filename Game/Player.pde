abstract class Player extends Character {
  private ArrayList<String> weaponProficiencies;

  private Weapon weapon;
  private ArrayList<Item> inventory = new ArrayList<Item>();

  public Player(int maxHealth, int maxMovement, Tile startingPosition, String characterClass, HashMap<String, Integer> stats, ArrayList<String> weaponProficiencies) {
    super(maxHealth, maxMovement, startingPosition, characterClass, stats);
    this.weaponProficiencies = weaponProficiencies;
  }

  public void give(Item item) {
    inventory.add(item);
  }

  public ArrayList<Item> getInventory(String type) {
    ArrayList<Item> output = new ArrayList<Item>();
    for (Item item : inventory) {
      if (item.getType().equals(type)) {
        output.add(item);
      }
    }
    return output;
  }

  public void equip(Weapon weapon) {
    if (weaponProficiencies.contains(weapon.getWeaponClass())) {
      this.weapon = weapon;
    }
  }

  public String getWeapon() {
    if (weapon == null) return "No Weapon";
    return weapon.toString();
  }

  public void attack(Character other) {
    if (weapon == null){
      other.damage(5);
    }
    else {
      weapon.attack(this, other);
    }
  }
}
