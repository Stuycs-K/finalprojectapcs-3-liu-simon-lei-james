public class Tile {
  public static final int HEIGHT = 16, WIDTH = 16;
  private String terrain;
  private Coordinate coordinate;
  public void draw() {
    PImage img = loadImage(getTerrain() + ".png");
    image(img, WIDTH * coordinate.getX(), HEIGHT * coordinate.getY(), HEIGHT, WIDTH);
  }
  public Tile(String terrain, int x, int y) {
    this.terrain = terrain;
    this.coordinate = new Coordinate(x, y);
  }
  public String getTerrain() {
    return terrain;
  }
  public void setTerrain(String newTerrain) {
    terrain = newTerrain;
  }
}
