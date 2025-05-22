public class Tile {
  private String terrain;
  private Entity entity;
  private Coordinate coordinate;
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
  public boolean hasEntity() {
    return entity == null;
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
  public Coordinate getCoordinate() {
    return coordinate;
  }
  // Does not account for weighted tiles
  public int distanceTo(Tile other) {
    Coordinate otherCoordinate = other.getCoordinate();
    int dx = Math.abs(otherCoordinate.getX() - coordinate.getX());
    int dy = Math.abs(otherCoordinate.getY() - coordinate.getY());
    return dx + dy;
  }
  public boolean withinRange(Tile other, int range) {
    return distanceTo(other) <= range;
  }
}
