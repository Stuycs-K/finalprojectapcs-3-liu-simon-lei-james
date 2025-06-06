abstract class Player extends Character {
  public boolean turn = true;

  private Weapon weapon;
  private ArrayList<Item> inventory = new ArrayList<Item>();

  public Player(int maxHealth, int maxMovement, Tile startingPosition, String characterClass, HashMap<String, Integer> stats, ArrayList<String> weaponProficiencies, Weapon weapon) {
    super(maxHealth, maxMovement, startingPosition, characterClass, stats, weaponProficiencies, weapon, true);
    this.weapon = weapon;
    give(weapon);
    equip(weapon);
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

  public boolean isPlayer(){
    return true;
  }
}

public class Archer extends Player {
  public Archer(Tile startingPosition) {
    super((RANDOM.nextInt(3) - 1) + 10, 6, startingPosition, "Archer", new HashMap<String, Integer>() {{
      put("Strength", (RANDOM.nextInt(5) - 1) + 6);
      put("Skill", 7);
      put("Speed", (RANDOM.nextInt(5) - 1) + 10);
      put("Defense", 3);
      put("Magic", 0);
      put("Resistance", 3);
    }}, new ArrayList<String>(Arrays.asList("Bow")), new Bow("Iron"));
  }
}

public class Barbarian extends Player{
  public Barbarian(Tile startingPosition) {
    super( (RANDOM.nextInt(5) - 2) + 18, 5, startingPosition, "Barbarian", new HashMap<String, Integer>() {{
      put("Strength", (RANDOM.nextInt(5) - 2) + 10);
      put("Skill", 1);
      put("Speed", 3);
      put("Defense", (RANDOM.nextInt(3) - 1) + 6);
      put("Magic", 0);
      put("Resistance", 1);
    }}, new ArrayList<String>(Arrays.asList("Axe")), new Axe("Iron"));
  }

}

public class Lord extends Player {
  public Lord(Tile startingPosition) {
    super( (RANDOM.nextInt(3) - 1) + 15, 5, startingPosition, "Lord", new HashMap<String, Integer>() {{
      put("Strength", (RANDOM.nextInt(3) - 1) + 7);
      put("Skill", 5);
      put("Speed", (RANDOM.nextInt(3) - 1) + 9);
      put("Defense", (RANDOM.nextInt(3) - 1) + 5);
      put("Magic", 0);
      put("Resistance", 3);
    }}, new ArrayList<String>(Arrays.asList("Sword")), new Sword("Brave"));
  }
}

public class Mage extends Player{
  public Mage(Tile startingPosition) {
    super(5, 4, startingPosition, "Mage", new HashMap<String, Integer>() {{
      put("Strength", 0);
      put("Skill", 6);
      put("Speed", (RANDOM.nextInt(3) - 1) + 6);
      put("Defense", 2);
      put("Magic", (RANDOM.nextInt(5) - 1) + 8);
      put("Resistance", (RANDOM.nextInt(5) - 1) + 5);
    }}, new ArrayList<String>(Arrays.asList("Tome")), new Tome("Fireball"));
  }
}

public class Thief extends Player {
  public Thief(Tile startingPosition) {
    super( (RANDOM.nextInt(3) - 1) + 8, 7, startingPosition, "Thief", new HashMap<String, Integer>() {{
      put("Strength", (RANDOM.nextInt(3) - 1) + 3);
      put("Skill", 10);
      put("Speed", (RANDOM.nextInt(5) - 1) + 12);
      put("Defense", 3);
      put("Magic", 0);
      put("Resistance", 2);
    }}, new ArrayList<String>(Arrays.asList("Sword")), new Sword("Iron"));
    give(new PureWater());
  }
}
