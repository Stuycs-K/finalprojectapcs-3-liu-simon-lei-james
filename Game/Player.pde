abstract class Player extends Character {
  private ArrayList<String> weaponProficiencies;
  public boolean turn = true;
  
  private Weapon weapon;
  private ArrayList<Item> inventory = new ArrayList<Item>();

  public Player(int maxHealth, int maxMovement, Tile startingPosition, String characterClass, HashMap<String, Integer> stats, ArrayList<String> weaponProficiencies) {
    super(maxHealth, maxMovement, startingPosition, characterClass, stats);
    this.weaponProficiencies = weaponProficiencies;
  }

  public void give(Item item) {
    inventory.add(item);
  }

  public ArrayList<Item> getInventory() {
    return inventory;
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
  
  public Item getItem(String name) {
    for (Item item : inventory) {
      if (item.toString().equals(name)) return item;
    }
    return null;
  }
  
  public void consume(Consumable item) {
    if(item.use(this)) {
      inventory.remove(item);
    };
  }

  public boolean equip(Weapon weapon) {
    if (weaponProficiencies.contains(weapon.getWeaponType())) {
      this.weapon = weapon;
      return true;
    }
    return false;
  }

  public String getWeapon() {
    if (weapon == null) return "No Weapon";
    return weapon.toString();
  }

  public void attack(Character other) {
    turn = false;
    if (weapon == null){
      other.damage(5);
    }
    else {
      weapon.attack(this, other);
    }
  }
  
  public ArrayList<Tile> attackRange() {
    return getPosition().tilesInRadius(weapon.getStat("Range"));
  }
}

public class Archer extends Player {
  public Archer(Tile startingPosition) {
    super(10, 6, startingPosition, "Archer", new HashMap<String, Integer>() {{
      put("Strength", 6);
      put("Speed", 10);
      put("Defense", 3);
      put("Magic", 0);
      put("Resistance", 3);
    }}, new ArrayList<String>(Arrays.asList("Bow")));
    Weapon bow = new Bow("Iron");
    give(bow);
    equip(bow);
  }
}

public class Barbarian extends Player{
  public Barbarian(Tile startingPosition) {
    super(18, 5, startingPosition, "Barbarian", new HashMap<String, Integer>() {{
      put("Strength", 10);
      put("Speed", 3);
      put("Defense", 6);
      put("Magic", 0);
      put("Resistance", 1);
    }}, new ArrayList<String>(Arrays.asList("Axe")));
    Weapon axe = new Axe("Iron");
    give(axe);
    equip(axe);
  }

}

public class Lord extends Player {
  public Lord(Tile startingPosition) {
    super(15, 5, startingPosition, "Lord", new HashMap<String, Integer>() {{
      put("Strength", 7);
      put("Speed", 9);
      put("Defense", 5);
      put("Magic", 0);
      put("Resistance", 3);
    }}, new ArrayList<String>(Arrays.asList("Sword")));
    Weapon sword = new Sword("Brave");
    give(sword);
    equip(sword);
  }
}

public class Mage extends Player{
  public Mage(Tile startingPosition) {
    super(5, 4, startingPosition, "Mage", new HashMap<String, Integer>() {{
      put("Strength", 0);
      put("Speed", 6);
      put("Defense", 2);
      put("Magic", 8);
      put("Resistance", 5);
    }}, new ArrayList<String>(Arrays.asList("Tome")));
    Weapon tome = new Tome("Blizzard");
    give(tome);
    equip(tome);
  }
}

public class Thief extends Player {
  public Thief(Tile startingPosition) {
    super(8, 7, startingPosition, "Thief", new HashMap<String, Integer>() {{
      put("Strength", 3);
      put("Speed", 12);
      put("Defense", 3);
      put("Magic", 0);
      put("Resistance", 2);
    }}, new ArrayList<String>(Arrays.asList("Sword")));
    Weapon sword = new Sword("Iron");
    give(sword);
    equip(sword);
    give(new PureWater());
  }
}
