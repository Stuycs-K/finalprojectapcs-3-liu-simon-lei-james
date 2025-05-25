public Board board;
public int cols = 30, rows = 20;
public ArrayList<Player> players;
public Tile prevClick;

void setup() {
  size(16 * 30, 16 * 20);
  board = new Board(rows, cols);
  players = new ArrayList<Player>();
  players.add(new Player("myrmidon", 10, 10, board.get(10, 10)));
  board.display();
  for (Player player : players) {
    player.display();
    player.getPosition().addEntity(player);
  }
}

void draw() {
}

void mouseClicked() {
  Tile clickLocation = board.get(mouseX / Tile.WIDTH, mouseY / Tile.HEIGHT);
  String type = board.checkTile(clickLocation);
  System.out.println(type);
  switch (type) {
    case "Player":
      ArrayList<Tile> range = board.getPlayer(clickLocation).movementRange();
      for (Tile tile : range) tile.tintGreen();
      prevClick = clickLocation;
      break;
    case "Tile":
    if (prevClick != null && board.checkTile(prevClick).equals("Player")) {
      if (board.getPlayer(prevClick).moveTo(clickLocation)) prevClick = null;
    }
  }
}
