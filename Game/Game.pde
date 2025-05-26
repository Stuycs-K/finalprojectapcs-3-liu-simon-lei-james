import java.util.Random;
import java.util.NoSuchElementException;

public Board board;
public int cols = 30, rows = 20;
public ArrayList<Player> players;
public ArrayList<Enemy> enemies;
public Tile prevClick;
public Random random = new Random();
public static boolean tick = false;
public static Queue<Tile> toUpdate = new LinkedList<Tile>();
public static int gameSpeed = 16;
public static int[][] directions = {{1, 0}, {0, 1}, {-1, 0}, {0, -1}};

void setup() {
  size(16 * 30, 16 * 20);
  board = new Board(rows, cols);
  players = new ArrayList<Player>();
  enemies = new ArrayList<Enemy>();
  players.add(new Player("myrmidon", 10, 10, board.get(10, 10)));
  enemies.add(new Enemy("slime", 10, 10, board.get(12, 13)));
  for (Player player : players) {
    player.getPosition().addEntity(player);
  }
  for (Enemy enemy : enemies) {
    enemy.display();
    enemy.getPosition().addEntity(enemy);
  }
  board.display();
}

void draw() {
  if (frameCount % gameSpeed == 0) {
    tick = !tick;
  }
  if (frameCount % gameSpeed != 0 && !toUpdate.isEmpty()) {
    try {
      toUpdate.remove().display();
    } catch (NoSuchElementException e) {}
  }
}

void keyPressed() {
  for (Player player : players) {
    player.endTurn();
  }
  for (Enemy enemy : enemies) {
    enemy.target(players.get(0));
    enemy.endTurn();
  }

}

void mouseClicked() {
  board.display();
  Tile clickLocation = board.get(mouseX / Tile.WIDTH, mouseY / Tile.HEIGHT);
  String type = board.checkTile(clickLocation);
  switch (type) {
    case "Player":
      ArrayList<Tile> range = board.getPlayer(clickLocation).movementRange();
      for (Tile tile : range) {
        tile.display("Blue");
        if (board.checkTile(tile).equals("Enemy")) tile.display("Red");
      }
      break;
    case "Tile":
      if (prevClick != null && board.checkTile(prevClick).equals("Player")) {
        board.getPlayer(prevClick).moveTo(clickLocation);
        System.out.println(board.getPlayer(prevClick).getMovement());
      }
      break;
  }
  prevClick = clickLocation;
}
