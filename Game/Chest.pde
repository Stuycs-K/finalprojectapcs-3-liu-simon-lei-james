public class Chest extends Entity {
  private Item content;
  
  public String[] weaponTypes = {"Bow", "Sword", "Tome", "Axe", "Lance"};
  public String[] swordTypes = {"Iron", "Silver", "Brave"};
  public String[] lanceTypes = {"Iron", "Silver", "Javelin"};
  public String[] tomeTypes = {"Fireball", "Thunder", "Blizzard"};
  public String[] bowTypes = {"Iron", "Silver", "Sleep"};
  public String[] axeTypes = {"Iron", "Silver", "Killer"};

  public Chest(Tile startingPosition) {
    super(startingPosition, "Chest");
    content = new Sword("Iron");
  }

  public void collect(Player player) {
    player.turn = false;
    player.give(content);
    actionBar.write(player.toString() + " recieved one " + content);
    position.removeEntity();
  }
}
