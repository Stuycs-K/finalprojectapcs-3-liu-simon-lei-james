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
    Queue<Node> bfs = new LinkedList<Node>();
    output.add(tile);
    for (int[] direction : directions) {
      bfs.add(new Node(tile.getCoordinate().shift(direction), 0));
    }
    while (! bfs.isEmpty()) {
      Node current = bfs.remove();
      Coordinate coordinate = current.getCoordinate();
      if (coordinate.outOfRange()) continue;
      if (coordinate.equals(tile.getCoordinate())) continue;
      int distance = current.getDistance() + movementPenalties.get(get(coordinate).getTerrain());
      if (distance > range) continue;
      
      if (visited[coordinate.getY()][coordinate.getX()] != 0 && visited[coordinate.getY()][coordinate.getX()] < distance) continue;
      visited[coordinate.getY()][coordinate.getX()] = distance;
      
      output.add(get(coordinate));
      if (checkTile(get(coordinate)).equals("Enemy")) continue;
      for (int[] direction : directions) {
        bfs.add(new Node(current.getCoordinate().shift(direction), distance));
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
  public Enemy getEnemy(Tile tile) {
    for (Enemy enemy : enemies) {
      if (enemy.getPosition().getCoordinate().equals(tile.getCoordinate())) return enemy;
    }
    return null;
  }
}
