import java.util.PriorityQueue;
import java.util.Comparator;
import java.util.Collections;

public class Tile {
  public static final int HEIGHT = 16, WIDTH = 16;
  private String terrain;
  private Entity entity;
  private Coordinate coordinate;
  public void display() {
    image(board.images.get(terrain), WIDTH * coordinate.getX(), HEIGHT * coordinate.getY(), HEIGHT, WIDTH);
    if (hasEntity()) {
      getEntity().display();
    }
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
  public ArrayList<Tile> pathTo(Tile other) {
    int[][] visited = new int[rows][cols];
    int[][] directions = {{1, 0}, {0, 1}, {-1, 0}, {0, -1}};
    PriorityQueue<Node> bfs = new PriorityQueue<Node>(4, new Comparator<Node>() {
      public int compare(Node first, Node second) {
        return first.getDistance() - second.getDistance();
      }
    });
    
    for (int[] direction : directions) {
      bfs.add(new Node(getCoordinate().shift(direction), 0));
    }
    
    while (! bfs.isEmpty()) {
      Node current = bfs.remove();
      Coordinate coordinate = current.getCoordinate();
      if (board.get(current.getCoordinate()) == null) continue;
      int distance = current.getDistance() + board.movementPenalties.get(board.get(coordinate).getTerrain());
      
      // Backtracking
      if (coordinate.equals(other.getCoordinate())) {
        ArrayList<Tile> path = new ArrayList<Tile>();
        while (! coordinate.equals(getCoordinate())) {
          path.add(board.get(coordinate));
          Tile minNeighbor = null;
          int minDistance = -1;
          for (int[] direction : directions) {
            Coordinate newCoordinate = coordinate.shift(direction);
            if (newCoordinate.equals(getCoordinate())) {
              Collections.reverse(path);
              return path;
            }
            if (visited[newCoordinate.getY()][newCoordinate.getX()] == 0) continue;
            if (minNeighbor == null || minDistance > visited[newCoordinate.getY()][newCoordinate.getX()]) {
              minNeighbor = board.get(newCoordinate);
              minDistance = visited[newCoordinate.getY()][newCoordinate.getX()];
            }
          }
          coordinate = minNeighbor.getCoordinate(); 
        }
      }
      
      if (coordinate.equals(getCoordinate())) continue;
      if (visited[coordinate.getY()][coordinate.getX()] != 0 && visited[coordinate.getY()][coordinate.getX()] <= distance) continue;
      visited[coordinate.getY()][coordinate.getX()] = distance;
      
      for (int[] direction : directions) {
        bfs.add(new Node(coordinate.shift(direction), distance));
      }
    }
    return null;
  }
  public int distanceTo(Tile other) {
    ArrayList<Tile> path = pathTo(other);
    int output = 0;
    for (Tile tile : path) {
      output += board.movementPenalties.get(tile.getTerrain());
    }
    return output;
  }
  public void tintBlue() {
    tint(0, 125, 250);
    display();
    noTint();
    if (hasEntity()) {
      getEntity().display();
    }
  }
}
