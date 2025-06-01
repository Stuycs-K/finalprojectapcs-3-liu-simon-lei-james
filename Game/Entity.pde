abstract public class Entity {
  private PImage img;

  protected Tile position;

  public Entity(Tile startingPosition, String imageName) {
    position = startingPosition;
    img = loadImage(imageName.toLowerCase() + ".png");
    img.resize(16, 0);
    startingPosition.addEntity(this);
  }

  public Tile getPosition() {
    return position;
  }

  public void display() {
    Coordinate coordinate = getPosition().getCoordinate();
    image(img, Tile.WIDTH * coordinate.getX(), Tile.HEIGHT * coordinate.getY(), Tile.HEIGHT, Tile.WIDTH);
  }
}
