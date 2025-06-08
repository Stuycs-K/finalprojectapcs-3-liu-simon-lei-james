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
    movementPenalties.put("Hills", 3);
  }

  public Board(int rows, int cols) {
    initializeConstants();
    board = new Tile[rows][cols];
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        if (BOARD == 5) {
          board[y][x] = new Tile(TERRAINS[0], x, y);
        } else {          
          int randomNum = RANDOM.nextInt(100);
          String tileType;
          if (randomNum <= 50) {
            tileType = "Plains";
          } else if (randomNum <= 90) {
            tileType = "Forest";
          } else {
            tileType = "Hills";
          }
          board[y][x] = new Tile(tileType, x, y);
        }
      }
    }
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
        tile.unhighlight();
        tile.display();
      }
    }
  }

  public Tile getRandomTile() {
    return get(new Coordinate(RANDOM.nextInt(COLUMNS), RANDOM.nextInt(ROWS)));
  }
}
