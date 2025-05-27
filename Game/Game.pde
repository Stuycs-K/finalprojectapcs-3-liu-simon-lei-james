import java.util.Random;
import java.util.NoSuchElementException;

public static final int COLUMNS = 30, ROWS = 20;
public static final int GAME_SPEED = 32;
public static final int[][] DIRECTIONS = {{1, 0}, {0, 1}, {-1, 0}, {0, -1}};
public static final Random RANDOM = new Random();
public volatile static int TICK = 0;

public volatile static Board board;
public static ArrayList<Player> players;
public static ArrayList<Enemy> enemies;

public static Tile highlighted;
public volatile static Queue<Tile> updateQueue = new LinkedList<Tile>();

public static void sleep(int time) {
  try {
    Thread.sleep(time);
  } catch(InterruptedException e) {}
}

void setup() {
  size(16 * 30, 16 * 20);
  board = new Board(ROWS, COLUMNS);
  
  players = new ArrayList<Player>();
  enemies = new ArrayList<Enemy>();
  for (int i = 0; i < 3; i++) players.add(new Player("lord", 10, 10, board.getRandomTile()));
  for (int i = 0; i < 3; i++) enemies.add(new Enemy("slime", 10, 10, board.getRandomTile()));
  
  for (Player player : players) {
    player.getPosition().addEntity(player);
  }
  for (Enemy enemy : enemies) {
    enemy.getPosition().addEntity(enemy);
  }
  
  board.display();
}

void draw() {
  if (frameCount % GAME_SPEED == 0) TICK++;
  if (frameCount % GAME_SPEED != 0 !updateQueue.isEmpty()) {
    try {
      updateQueue.remove().display();
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
  board.reset();
  Tile clickLocation = board.get(mouseX / Tile.WIDTH, mouseY / Tile.HEIGHT);
  String type = clickLocation.getEntity();
  switch (type) {
    case "Player":
      ArrayList<Tile> range = board.getPlayer(clickLocation).movementRange();
      for (Tile tile : range) {
        tile.transform("Blue");
        if (tile.getEntity().equals("Enemy")) tile.transform("Red");
      }
      break;
    case "Tile":
      if (highlighted != null && highlighted.getEntity().equals("Player")) {
        board.getPlayer(highlighted).moveTo(clickLocation);
      }
      break;
    case "Enemy":
      if (highlighted != null && highlighted.getEntity().equals("Player")) {
        if (board.getPlayer(highlighted).moveTo(clickLocation)) {
          board.getPlayer(highlighted).mainAttack(board.getEnemy(clickLocation));
        };
      }
      break;
  }
  highlighted = clickLocation;
}
