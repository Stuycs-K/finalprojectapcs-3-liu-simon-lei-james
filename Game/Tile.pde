public class Tile {
  public static final int HEIGHT = 16, WIDTH = 16;
  private String terrain;
  private Entity entity;
  private Coordinate coordinate;
  public void display() {
    PImage img = loadImage(getTerrain() + ".png");
    image(img, WIDTH * coordinate.getX(), HEIGHT * coordinate.getY(), HEIGHT, WIDTH);
  }
  public boolean hasEntity() {
    return entity != null;
  }
  public void removeEntity() {
    entity = null;
  }
  public Entity getEntity() {
    return entity;
  }
  public void addEntity(Entity newEntity) {
    entity = newEntity;
  }
  public Tile(String terrain, int x, int y) {
    this.terrain = terrain;
    this.coordinate = new Coordinate(x, y);
  }
  public Coordinate getCoordinate() {
    return coordinate;
  }
  public String getTerrain() {
    return terrain;
  }
  public void setTerrain(String newTerrain) {
    terrain = newTerrain;
  }
  public int distanceTo(Tile other) {
    Coordinate otherCoordinate = other.getCoordinate();
    int dx = Math.abs(otherCoordinate.getX() - coordinate.getX());
    int dy = Math.abs(otherCoordinate.getY() - coordinate.getY());
    return dx + dy;
  }
  public void tintGreen() {
    tint(0, 255, 0);
    display();
    noTint();
    if (hasEntity()) {
      getEntity().display();
    }
  }
}
