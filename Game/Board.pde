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
        board[y][x] = new Tile(terrains[random.nextInt(terrains.length)], x, y);
      }
    }
    initializeConstants();
  }
  public Tile get(int x, int y) {
    if (x < 0 || x >= cols || y < 0 || y >= rows) return null;
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
  public ArrayList<Tile> tilesInRange(Tile tile, int range) {
    ArrayList<Tile> output = new ArrayList<Tile>();
    int[][] visited = new int[board.length][board[0].length];
    Queue<Coordinate> bfs = new LinkedList<Coordinate>();
    Queue<Integer> distances = new LinkedList<Integer>();
    int[][] directions = {{1, 0}, {0, 1}, {-1, 0}, {0, -1}};
    output.add(tile);
    for (int[] direction : directions) {
      bfs.add(new Coordinate(tile.getCoordinate().getX() + direction[0], tile.getCoordinate().getY() + direction[1]));
      distances.add(0);
    }
    bfs.add(tile.getCoordinate());
    distances.add(0);
    while (! bfs.isEmpty()) {
      Coordinate current = bfs.remove();
      if (current.getX() < 0 || current.getX() >= board[0].length || current.getY() < 0 || current.getY() >= board.length) continue;
      
      int distance = distances.remove() + movementPenalties.get(get(current).getTerrain());
      if (distance > range) continue;
      
      if (visited[current.getY()][current.getX()] != 0 && visited[current.getY()][current.getX()] < distance) continue;
      visited[current.getY()][current.getX()] = distance;
      
      output.add(board[current.getY()][current.getX()]);
      for (int[] direction : directions) {
        bfs.add(new Coordinate(current.getX() + direction[0], current.getY() + direction[1]));
        distances.add(distance);
      }
    }
    return output;
  }
  public String checkTile(Tile tile) {
    if (tile.hasEntity()) return tile.getEntity().getType();
    return "Tile";
  }
  public Player getPlayer(Tile tile) {
    for (Player player : players) {
      if (player.getPosition().getCoordinate().equals(tile.getCoordinate())) return player;
    }
    return null;
  }
}
