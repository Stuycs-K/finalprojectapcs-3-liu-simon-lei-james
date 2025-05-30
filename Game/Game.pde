import java.util.Random;
import java.util.NoSuchElementException;

public static final int FONT_SIZE = 8;
public static final int ACTION_BAR_SIZE = FONT_SIZE * 6 - 2;
public static final int COLUMNS = 30, ROWS = 20;
public static final int GAME_SPEED = 2; // Speed the Board Updates; Lower = Faster
public static final int[][] DIRECTIONS = {{1, 0}, {0, 1}, {-1, 0}, {0, -1}};
public static final Random RANDOM = new Random();
public volatile static int TICK = 0;

private static final String[] playerClasses = {"Lord", "Archer", "Barbarian", "Mage", "Rogue"};
private static final String[] enemyClasses = {"Slime"};

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

  HashMap<String, Integer> stats = new HashMap<String, Integer>();
  stats.put("Defense", 1);
  stats.put("Strength", 1);

  for (int i = 0; i < 3; i++) {
    Tile spawnLocation = board.getRandomTile();
    while (spawnLocation.hasEntity()) spawnLocation = board.getRandomTile();
    players.add(new Player(RANDOM.nextInt(10) + 5, RANDOM.nextInt(10) + 5, spawnLocation, "Lord", stats, new ArrayList<String>()));
  }
  for (int i = 0; i < 3; i++) {
    Tile spawnLocation = board.getRandomTile();
    while (spawnLocation.hasEntity()) spawnLocation = board.getRandomTile();
    enemies.add(new Enemy(RANDOM.nextInt(10) + 5, RANDOM.nextInt(10) + 5, spawnLocation, "Slime", stats));
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
  if (mouseY < height - ACTION_BAR_SIZE) {
    Tile clickLocation = board.get(mouseX / Tile.WIDTH, mouseY / Tile.HEIGHT);
    Entity entity = clickLocation.getEntity();
    if (entity == null) {
      if (highlighted != null && highlighted.getEntity() instanceof Player) {
        ((Player) highlighted.getEntity()).moveTo(clickLocation);
        highlighted = null;
      }
    } else if (entity instanceof Player) {
      actionBar.display((Player) entity);
      ArrayList<Tile> range = ((Player) entity).movementRange();
      for (Tile tile : range) {
        tile.transform("Blue");
        if (tile.getEntity() instanceof Enemy) tile.transform("Red");
      }
      highlighted = clickLocation;
    } else if (entity instanceof Enemy) {
      actionBar.display((Enemy) entity);
      if (highlighted != null && highlighted.getEntity() instanceof Player) {
        ((Player) highlighted.getEntity()).moveTo(clickLocation);
        highlighted = null;
      } else {
        highlighted = clickLocation;
      }
    }
  }
}
