import java.util.Queue;
import java.util.LinkedList;

public class Board {
  private Tile[][] board;
  private final String[] terrains = {"plains"};
  public Board(int rows, int cols) {
    board = new Tile[rows][cols];
    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        board[y][x] = new Tile(terrains[0], x, y);
      }
    }
  }
  public Tile get(int x, int y) {
    return board[y][x];
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
    boolean[][] visited = new boolean[board.length][board[0].length];
    Queue<Coordinate> bfs = new LinkedList<Coordinate>();
    bfs.add(tile.getCoordinate());
    int[][] directions = {{1, 0}, {0, 1}, {-1, 0}, {0, -1}};
    for (int i = 0; i <= range; i++) {
      int toVisit = bfs.size();
      for (int n = 0; n < toVisit; n++) {
        Coordinate current = bfs.remove();
        if (current.getX() < 0 || current.getX() >= board[0].length || current.getY() < 0 || current.getY() >= board.length) continue;
        if (visited[current.getY()][current.getX()]) continue;
        visited[current.getY()][current.getX()] = true;
        output.add(board[current.getY()][current.getX()]);
        for (int[] direction : directions) {
          bfs.add(new Coordinate(current.getX() + direction[0], current.getY() + direction[1]));
        }
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
  public void reset() {
    for (Tile[] row : board) {
      for (Tile tile : row) {
        tile.display();
      }
    }
  }
}
