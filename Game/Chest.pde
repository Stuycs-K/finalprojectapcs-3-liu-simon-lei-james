public class Chest extends Entity {
  private Item content;

  public Chest(Tile startingPosition) {
    super(startingPosition, "Chest");
    content = new Sword("Iron Sword");
  }

  public void collect(Player player) {
    player.give(content);
    actionBar.write(player.getCharacterClass() + " " + player.getName() + " recieved one " + content);
    position.removeEntity();
  }
}
