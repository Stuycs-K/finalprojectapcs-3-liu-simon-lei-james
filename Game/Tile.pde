import java.util.PriorityQueue;
import java.util.Collections;
import java.util.LinkedList;

public class Tile {
  public static final int HEIGHT = 16, WIDTH = 16;

  // Possible Values: None, Red, Blue
  private String hue;
  private String terrain;
  private volatile Entity entity;
  private Coordinate coordinate;

  public Tile(String terrain, int x, int y) {
    this.terrain = terrain;
    coordinate = new Coordinate(x, y);
    hue = "None";
  }

  public void display() {
    switch (hue) {
    case "Blue":
      tint(0, 125, 250);
      break;
    case "Red":
      tint(250, 125, 0);
      break;
    }

    image(board.images.get(terrain), WIDTH * coordinate.getX(), HEIGHT * coordinate.getY(), HEIGHT, WIDTH);
    noTint();
    if (hasEntity()) entity.display();
  }
  
  public void transform(String newColor) {
    hue = newColor;
    display();
  }

  public boolean hasEntity() {
    return entity != null;
  }
  public String getEntity() {
    if (!hasEntity()) return "Tile";
    return entity.getType();
  }
  public void removeEntity() {
    entity = null;
  }
  public void addEntity(Entity newEntity) {
    entity = newEntity;
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

  public ArrayList<Tile> getNeighbors() {
    ArrayList<Tile> neighbors = new ArrayList<Tile>();
    for (int[] direction : DIRECTIONS) {
      Coordinate newCoordinate = getCoordinate().shift(direction);
      if (!newCoordinate.outOfRange()) neighbors.add(board.get(newCoordinate));
    }
    return neighbors;
  }

  public LinkedList<Tile> pathTo(Tile other) {
    int[][] distances = new int[ROWS][COLUMNS];

    Pair<Integer, Tile> start = new Pair<Integer, Tile>(0, this); // Distance, Tile
    PriorityQueue<Pair<Integer, Tile>> bfs = new PriorityQueue<Pair<Integer, Tile>>(4, start.getComparator());

    distances[getCoordinate().getY()][getCoordinate().getX()] = -1; // Starting Tile
    bfs.add(start);

    while (!bfs.isEmpty()) {
      Pair<Integer, Tile> current = bfs.remove();

      Tile tile = current.getSecond();
      Coordinate coordinate = tile.getCoordinate();

      // Backtracking
      if (coordinate.equals(other.getCoordinate())) {
        LinkedList<Tile> path = new LinkedList<Tile>();

        while (!coordinate.equals(getCoordinate())) {
          path.push(board.get(coordinate));
          Tile minNeighbor = null;
          int minDistance = -2; // Impossible Value
          for (Tile neighbor : board.get(coordinate).getNeighbors()) {
            Coordinate newCoordinate = neighbor.getCoordinate();
            if (distances[newCoordinate.getY()][newCoordinate.getX()] == 0) continue;
            if (minDistance == -2 || minDistance > distances[newCoordinate.getY()][newCoordinate.getX()]) {
              minNeighbor = neighbor;
              minDistance = distances[newCoordinate.getY()][newCoordinate.getX()];
            }
          }
          coordinate = minNeighbor.getCoordinate();
        }
        return path;
      }

      if (coordinate != getCoordinate() && tile.hasEntity()) continue;
      if (distances[coordinate.getY()][coordinate.getX()] > 0 && distances[coordinate.getY()][coordinate.getX()] <= current.getFirst()) continue;
      if (distances[coordinate.getY()][coordinate.getX()] != -1) distances[coordinate.getY()][coordinate.getX()] = current.getFirst();

      for (Tile neighbor : tile.getNeighbors()) {
        int distance = current.getFirst() + board.movementPenalties.get(neighbor.getTerrain());
        bfs.add(new Pair<Integer, Tile>(distance, neighbor));
      }
    }
    return null;
  }

  public int distanceTo(Tile other) {
    LinkedList<Tile> path = pathTo(other);
    if (path == null) return -1;
    int output = 0;
    while (!path.isEmpty()) {
      output += board.movementPenalties.get(path.pop().getTerrain());
    }
    return output;
  }
}
