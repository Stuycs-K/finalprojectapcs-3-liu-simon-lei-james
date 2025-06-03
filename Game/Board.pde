import java.util.Queue;
import java.util.LinkedList;

public class Board {
  private final String[] TERRAINS = {"Plains", "Forest", "Hills"};

  private HashMap<String, PImage> images = new HashMap<String, PImage>();
  private HashMap<String, Integer> movementPenalties = new HashMap<String, Integer>();

  private Tile[][] board;

  private void initializeConstants() {
    for (String terrain : TERRAINS) {
      images.put(terrain, loadImage(terrain.toLowerCase() + ".png"));
    }
    movementPenalties.put("Plains", 1);
    movementPenalties.put("Forest", 2);
    movementPenalties.put("Hills", 2);
  }

  public Board(int rows, int cols) {
    board = new Tile[rows][cols];
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        board[y][x] = new Tile(TERRAINS[RANDOM.nextInt(TERRAINS.length)], x, y);
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

  public Tile getRandomTile() {
    return get(new Coordinate(RANDOM.nextInt(COLUMNS), RANDOM.nextInt(ROWS)));
  }
}
