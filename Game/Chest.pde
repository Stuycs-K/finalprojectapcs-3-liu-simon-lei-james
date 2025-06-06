public class Chest extends Entity {
  private Item content;
  
  public String[] weaponTypes = {"Bow", "Sword", "Tome", "Axe", "Lance"};
  public HashMap<String, String[]> materials = new HashMap<String, String[]>() {{
    put("Sword", new String[]{"Iron", "Silver", "Brave"});
    put("Lance", new String[]{"Iron", "Silver", "Javelin"});
    put("Tome", new String[]{"Fireball", "Thunder", "Blizzard"});
    put("Bow", new String[]{"Iron", "Silver", "Sleep"});
    put("Axe", new String[]{"Iron", "Silver", "Killer"});
  }};
  public String[] consumables = {"Vulnerary", "Pure Water"};

  public Chest(Tile startingPosition) {
    super(startingPosition, "Chest");
    if (RANDOM.nextInt(2) == 1) {
      String weaponType = weaponTypes[RANDOM.nextInt(weaponTypes.length)];
      String material = materials.get(weaponType)[RANDOM.nextInt(materials.get(weaponType).length)];
      switch (weaponType) {
        case "Sword":
          content = new Sword(material);
          break;
        case "Lance":
          content = new Lance(material);
          break;
        case "Tome":
          content = new Tome(material);
          break;
        case "Bow":
          content = new Bow(material);
          break;
        case "Axe":
          content = new Axe(material);
          break;
      }
    } else {
      String consumable = consumables[RANDOM.nextInt(consumables.length)];
      switch (consumable) {
        case "Vulnerary":
          content = new Vulnerary();
          break;
        case "Pure Water":
          content = new PureWater();
          break;
      }
    }
  }

  public void collect(Player player) {
    player.turn = false;
    player.give(content);
    actionBar.write(player.toString() + " recieved one " + content);
    position.removeEntity();
  }
}
