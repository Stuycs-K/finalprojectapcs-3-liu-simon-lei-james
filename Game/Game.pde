import java.util.Random;
import java.util.NoSuchElementException;

public static final int FONT_SIZE = 8;
public static final int ACTION_BAR_SIZE = FONT_SIZE * 6 - 2;
public static final int COLUMNS = 30, ROWS = 20;
public static final int GAME_SPEED = 2; // Speed the Board Updates; Lower = Faster
public static final int[][] DIRECTIONS = {{1, 0}, {0, 1}, {-1, 0}, {0, -1}};
public static final Random RANDOM = new Random();
public volatile static int TICK = 0;

public volatile static Board board;
public static ActionBar actionBar;
public static ArrayList<Player> players;
public static ArrayList<Enemy> enemies;
public static int turn;

public static Tile highlighted;

public static void sleep(int time) {
  try {
    Thread.sleep(time);
  } catch(InterruptedException e) {}
}

void setup() {
  size(16 * 30, 16 * 20 + 46);
  background(92, 160, 72);
  board = new Board(ROWS, COLUMNS);
  turn = 0;
  
  actionBar = new ActionBar();

  players = new ArrayList<Player>();
  enemies = new ArrayList<Enemy>();
  for (int i = 0; i < 3; i++) {
    Tile spawnLocation = board.getRandomTile();
    while (spawnLocation.hasEntity()) spawnLocation = board.getRandomTile();
    players.add(new Player("lord", RANDOM.nextInt(10) + 5, RANDOM.nextInt(10) + 5, spawnLocation));
  }
  for (int i = 0; i < 3; i++) {
    Tile spawnLocation = board.getRandomTile();
    while (spawnLocation.hasEntity()) spawnLocation = board.getRandomTile();
    enemies.add(new Enemy("slime", RANDOM.nextInt(10) + 5, RANDOM.nextInt(10) + 5, spawnLocation));
  }

  for (Player player : players) {
    player.getPosition().addEntity(player);
  }
  for (Enemy enemy : enemies) {
    enemy.getPosition().addEntity(enemy);
  }

  board.display();
  actionBar.write("Welcome to our game. Please click on a player to begin.");
}

void draw() {
  board.display();
  actionBar.update();
  if (frameCount % GAME_SPEED == 0) TICK++;
}

void keyPressed() {
  board.reset();
  for (Player player : players) {
    player.endTurn();
  }
  for (Enemy enemy : enemies) {
    enemy.takeTurn();
    enemy.endTurn();
  }
  turn++;
}

void mouseClicked() {
  board.reset();
  // On Board
  if (mouseY < height - ACTION_BAR_SIZE) {
    Tile clickLocation = board.get(mouseX / Tile.WIDTH, mouseY / Tile.HEIGHT);
    String type = clickLocation.getEntity();
    switch (type) {
      case "Player":
        actionBar.display(board.getPlayer(clickLocation));
        ArrayList<Tile> range = board.getPlayer(clickLocation).movementRange();
        for (Tile tile : range) {
          tile.transform("Blue");
          if (tile.getEntity().equals("Enemy")) tile.transform("Red");
        }
        highlighted = clickLocation;
      break;
      case "Tile":
        if (highlighted != null && highlighted.getEntity().equals("Player")) {
          board.getPlayer(highlighted).moveTo(clickLocation); // Selected player goes to tile
          highlighted = null;
        }
        break;
      case "Enemy":
        actionBar.display(board.getEnemy(clickLocation));
        clickLocation.transform("Red");
        if (highlighted != null && highlighted.getEntity().equals("Player")) {
          // Selected player moves to and attacks enemy
          if (board.getPlayer(highlighted).moveTo(clickLocation)) {
            board.getPlayer(highlighted).mainAttack(board.getEnemy(clickLocation));
          }
          highlighted = null;
        } else {
          highlighted = clickLocation;
        }
        break;
    }
  } else {

  }
}
