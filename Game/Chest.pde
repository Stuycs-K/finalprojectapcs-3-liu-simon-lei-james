public class Chest extends Entity {
  private Item content;
  
  public Chest(Tile startingPosition) {
    super(startingPosition, "Chest");
    content = new Sword(40, 5, "Iron"); 
  }
  
  public void collect(Player player) {
    player.giveItem(content);
    position.removeEntity();
  }
}
