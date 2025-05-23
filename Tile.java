import java.util.ArrayList;
import java.util.Queue;
import java.util.LinkedList;

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
  public boolean isWithinRange(Tile other, int range) {
    return distanceTo(other) <= range;
  }
  public ArrayList<Tile> tilesInRange(Tile[][] board, int range) {
    ArrayList<Tile> output = new ArrayList<Tile>();
    boolean[][] visited = new boolean[board.length][board[0].length];
    Queue<Coordinate> bfs = new LinkedList<Coordinate>();
    bfs.add(coordinate);
    int[][] directions = {{1, 0}, {0, 1}, {-1, 0}, {0, -1}};
    while (!bfs.isEmpty()) {
      Coordinate current = bfs.remove();
      if (current.getX() < 0 || current.getX() >= board[0].length || current.getY() < 0 || current.getY() >= board.length) continue;
      if (visited[current.getX()][current.getY()]) continue;
      visited[current.getX()][current.getY()] = true;
      output.add(board[current.getX()][current.getY()]);
      for (int[] direction : directions) {
        bfs.add(new Coordinate(current.getX() + direction[0], current.getY() + direction[1]));
      }
    }
    return output;
  }
}
