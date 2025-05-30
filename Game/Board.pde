import java.util.Queue;
import java.util.LinkedList;

public class Board {
  private final String[] terrains = {"plains", "forest", "hills"};
  private HashMap<String, PImage> images = new HashMap<String, PImage>();
  private HashMap<String, Integer> movementPenalties = new HashMap<String, Integer>();

  private Tile[][] board;
  
  private void initializeConstants() {
    for (String terrain : terrains) {
      images.put(terrain, loadImage(terrain + ".png"));
    }
    movementPenalties.put("plains", 1);
    movementPenalties.put("forest", 2);
    movementPenalties.put("hills", 2);
  }
  
  public Board(int rows, int cols) {
    board = new Tile[rows][cols];
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        board[y][x] = new Tile(terrains[RANDOM.nextInt(terrains.length)], x, y);
      }
    }
    initializeConstants();
  }
  
  public Tile get(int x, int y) {
    if (x < 0 || x >= COLUMNS || y < 0 || y >= ROWS) return null;
    return board[y][x];
  }
  
  public Tile get(Coordinate coordinate) {
    return get(coordinate.getX(), coordinate.getY());
  }
  
  public void display() {
    for (Tile[] row : board) {
      for (Tile tile : row) {
        tile.display();
      }
    }
  }
  public void reset() {
    for (Tile[] row : board) {
      for (Tile tile : row) {
        tile.transform("None");
        tile.display();
      }
    }
  }
  
  public ArrayList<Tile> tilesInRange(Tile tile, int range) {
    ArrayList<Tile> output = new ArrayList<Tile>();
    int[][] distances = new int[board.length][board[0].length];
    Queue<Pair<Integer, Tile>> bfs = new LinkedList<Pair<Integer, Tile>>();
    bfs.add(new Pair<Integer, Tile>(0, tile));
    
    output.add(tile);
    while (!bfs.isEmpty()) {
      Pair<Integer, Tile> current = bfs.remove();
      Tile currentTile = current.getSecond();
      Coordinate coordinate = currentTile.getCoordinate();
      
      if (current.getFirst() > range) continue;
      if (distances[coordinate.getY()][coordinate.getX()] > 0 && distances[coordinate.getY()][coordinate.getX()] < current.getFirst()) continue;
      distances[coordinate.getY()][coordinate.getX()] = current.getFirst();
      
      output.add(currentTile);
      if (!coordinate.equals(tile.getCoordinate()) && currentTile.hasEntity()) continue;
      
      for (Tile neighbor : currentTile.getNeighbors()) {
        int distance = current.getFirst() + neighbor.getMovementPenalty();
        bfs.add(new Pair<Integer, Tile>(distance, neighbor));
      }
    }
    return output;
  }
  
  public Tile getRandomTile() {
    return get(new Coordinate(RANDOM.nextInt(COLUMNS), RANDOM.nextInt(ROWS)));
  }
}
