public class Chest extends Entity {
  private PImage img;
  private Item content;
  
  public Chest(Tile startingPosition) {
    super("Chest", startingPosition);
    img = loadImage("chest.png");
    content = new Sword(40, 5, "Iron"); 
  }
  public void display() {
    Coordinate coordinate = getPosition().getCoordinate();
    image(img, Tile.WIDTH * coordinate.getX(), Tile.HEIGHT * coordinate.getY(), Tile.HEIGHT, Tile.WIDTH);
  }
  public void collect(Player player) {
    player.giveItem(content);
    position.removeEntity();
  }
}
