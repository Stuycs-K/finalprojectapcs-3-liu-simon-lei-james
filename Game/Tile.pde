import java.util.PriorityQueue;
import java.util.LinkedList;

public class Tile {
  public static final int HEIGHT = 32, WIDTH = 32;

  // Possible Values: None, Red, Blue
  private String highlighted;
  private String terrain;
  private Entity entity;
  private Coordinate coordinate;

  public Tile(String terrain, int x, int y) {
    this.terrain = terrain;
    coordinate = new Coordinate(x, y);
    highlighted = "None";
  }

  public void display() {
    if (highlighted.equals("Red")) {
      tint(250, 125, 0);
    } else if (highlighted.equals("Blue")) {
      tint(0, 125, 250);
    }
    image(board.images.get(terrain), WIDTH * coordinate.getX(), HEIGHT * coordinate.getY(), HEIGHT, WIDTH);
    noTint();
    if (hasEntity()) entity.display();
  }
  
  // Coloring

  public void highlight() {
    if (hasEntity() && getEntity() instanceof Enemy) {
      highlighted = "Red";
    } else {
      highlighted = "Blue";
    }
    display();
  }
  
  public void highlight(String newHighlight) {
    highlighted = newHighlight;
  }
  
  public void unhighlight() {
    highlighted = "None";
    display();
  }
  
  public boolean isHighlighted() {
    return !highlighted.equals("None");
  }
  
  // Entities

  public boolean hasEntity() {
    return entity != null;
  }
  public Entity getEntity() {
    return entity;
  }
  public void removeEntity() {
    entity = null;
  }
  public void addEntity(Entity newEntity) {
    entity = newEntity;
  }
  
  // Accessors

  public Coordinate getCoordinate() {
    return coordinate;
  }

  public String getTerrain() {
    return terrain;
  }
  
  public int getMovementPenalty() {
    return board.movementPenalties.get(terrain);
  }
  
  // Mapping
  
  public ArrayList<Tile> getNeighbors() {
    ArrayList<Tile> neighbors = new ArrayList<Tile>();
    for (int[] direction : DIRECTIONS) {
      Coordinate newCoordinate = getCoordinate().shift(direction);
      if (!newCoordinate.outOfRange()) neighbors.add(board.get(newCoordinate));
    }
    return neighbors;
  }
  
  public ArrayList<Tile> tilesInRadius(int radius) {
    ArrayList<Tile> output = new ArrayList<Tile>();
    for (int dy = -radius; dy <= radius; dy++) {
      for (int dx = -radius + abs(dy); dx <= radius - abs(dy); dx++) {
        Tile tile = board.get(coordinate.getX() + dx, coordinate.getY() + dy);
        if (tile != null) output.add(tile);
      }
    }
    return output;
  }
  
  public ArrayList<Tile> tilesInRange(int range) {
    ArrayList<Tile> output = new ArrayList<Tile>();
    int[][] distances = new int[ROWS][COLUMNS];
    LinkedList<Pair<Integer, Tile>> bfs = new LinkedList<Pair<Integer, Tile>>();
    bfs.add(new Pair<Integer, Tile>(0, this));

    output.add(this);
    while (!bfs.isEmpty()) {
      Pair<Integer, Tile> current = bfs.remove();
      Tile currentTile = current.getSecond();
      Coordinate coordinate = currentTile.getCoordinate();

      if (current.getFirst() > range) continue;
      if (distances[coordinate.getY()][coordinate.getX()] > 0 && distances[coordinate.getY()][coordinate.getX()] < current.getFirst()) continue;
      distances[coordinate.getY()][coordinate.getX()] = current.getFirst();

      output.add(currentTile);
      if (!coordinate.equals(this.getCoordinate()) && currentTile.hasEntity()) continue;

      for (Tile neighbor : currentTile.getNeighbors()) {
        int distance = current.getFirst() + neighbor.getMovementPenalty();
        bfs.add(new Pair<Integer, Tile>(distance, neighbor));
      }
    }
    return output;
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

  public boolean equals(Tile other) {
    return coordinate.equals(other.getCoordinate());
  }
}
