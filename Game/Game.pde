public Board board;
public int cols = 30, rows = 20;

void setup() {
  size(16 * 30, 16 * 20);
  board = new Board(rows, cols);
}

void draw() {
  board.draw();
}
