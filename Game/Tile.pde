import java.util.PriorityQueue;
import java.util.Comparator;
import java.util.Collections;

public class Tile {
  public static final int HEIGHT = 16, WIDTH = 16;
  private String terrain;
  private Entity entity;
  private Coordinate coordinate;
  public void display() {
    display("None");
  }
  public void display(String tint) {
    switch (tint) {
      case "Blue":
        tint(0, 125, 250);
        break;
      case "Red":
        tint(250, 125, 0);
        break;
    }
    image(board.images.get(terrain), WIDTH * coordinate.getX(), HEIGHT * coordinate.getY(), HEIGHT, WIDTH);
    noTint();
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
      if (coordinate.outOfRange()) continue;
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
            if (newCoordinate.outOfRange()) continue;
            if (visited[newCoordinate.getY()][newCoordinate.getX()] == 0) continue;
            if (minNeighbor == null || minDistance > visited[newCoordinate.getY()][newCoordinate.getX()]) {
              minNeighbor = board.get(newCoordinate);
              minDistance = visited[newCoordinate.getY()][newCoordinate.getX()];
            }
          }
          coordinate = minNeighbor.getCoordinate(); 
        }
      }
      
      if (board.checkTile(board.get(current.getCoordinate())).equals("Enemy")) continue;
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
}
