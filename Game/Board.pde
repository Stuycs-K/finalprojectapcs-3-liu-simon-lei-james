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
  public void draw() {
    for (Tile[] row : board) {
      for (Tile tile : row) {
        tile.draw();
      }
    }
  }
}
