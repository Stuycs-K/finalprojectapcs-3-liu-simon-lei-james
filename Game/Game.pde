import java.util.Random;
import java.util.NoSuchElementException;

public Board board;
public int cols = 30, rows = 20;
public ArrayList<Player> players;
public Tile prevClick;
public Random random = new Random();
public static boolean tick = false;
public static Queue<Tile> toUpdate = new LinkedList<Tile>();
public static int gameSpeed = 16;

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
  if (frameCount % gameSpeed == 0) {
    tick = !tick;
  }
  if (frameCount % (gameSpeed / 4) == 0 && !toUpdate.isEmpty()) {
    try {
      toUpdate.remove().display();
    } catch (NoSuchElementException e) {}
  }
}

void mouseClicked() {
  Tile clickLocation = board.get(mouseX / Tile.WIDTH, mouseY / Tile.HEIGHT);
  String type = board.checkTile(clickLocation);
  switch (type) {
    case "Player":
      ArrayList<Tile> range = board.getPlayer(clickLocation).movementRange();
      for (Tile tile : range) {
        tile.tintBlue();
      }
      break;
    case "Tile":
      if (prevClick != null && board.checkTile(prevClick).equals("Player")) {
        board.display();
        board.getPlayer(prevClick).moveTo(clickLocation);
      }
      break;
  }
  prevClick = clickLocation;
}
