abstract class Player extends Character {
  private ArrayList<Item> inventory = new ArrayList<Item>();

  public Player(int maxHealth, int maxMovement, Tile startingPosition, String characterClass, HashMap<String, Integer> stats, ArrayList<String> weaponProficiencies, Weapon startingWeapon) {
    super(maxHealth, maxMovement, startingPosition, characterClass, stats, weaponProficiencies);
    give(startingWeapon);
    equip(startingWeapon);
    turn = true;
  }
  
  // Consumables
  
  public void consume(Consumable item) {
    item.use(this);
  }

  // Inventory

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
  
  public void give(Item item) {
    inventory.add(item);
  }
  
  public void take(Item item) {
    inventory.remove(item);
    if (weapon.toString().equals(item.toString())) weapon = null;
  }

  public Item getItem(String name) {
    for (Item item : inventory) {
      if (item.toString().equals(name)) return item;
    }
    return null;
  }
}

public class Archer extends Player {
  public Archer(Tile startingPosition) {
    super((RANDOM.nextInt(3) - 1) + 17, 6, startingPosition, "Archer", new HashMap<String, Integer>() {{
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
    super((RANDOM.nextInt(5) - 2) + 29, 5, startingPosition, "Barbarian", new HashMap<String, Integer>() {{
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
    super((RANDOM.nextInt(3) - 1) + 18, 5, startingPosition, "Lord", new HashMap<String, Integer>() {{
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
    super(17, 4, startingPosition, "Mage", new HashMap<String, Integer>() {{
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
    super((RANDOM.nextInt(3) - 1) + 18, 6, startingPosition, "Thief", new HashMap<String, Integer>() {{
      put("Strength", (RANDOM.nextInt(3) - 1) + 3);
      put("Skill", 4);
      put("Speed", (RANDOM.nextInt(5) - 1) + 12);
      put("Defense", 3);
      put("Magic", 0);
      put("Resistance", 2);
    }}, new ArrayList<String>(Arrays.asList("Sword")), new Sword("Iron"));
  }
}

public class Cavalier extends Player {
  public Cavalier(Tile startingPosition){
    super(22, 8, startingPosition, "Cavalier", new HashMap<String, Integer>() {{
      put("Strength", (RANDOM.nextInt(3) - 1) + 7);
      put("Skill", 5);
      put("Speed", (RANDOM.nextInt(5) - 1) + 7);
      put("Defense", 5);
      put("Magic", 0);
      put("Resistance", 2);
    }}, new ArrayList<String>(Arrays.asList("Sword", "Axe", "Lance")), new Lance("Iron"));
  }
}
