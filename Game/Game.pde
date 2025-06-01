import java.util.Random;
import java.util.NoSuchElementException;

public static final int[][] DIRECTIONS = {{1, 0}, {0, 1}, {-1, 0}, {0, -1}};
public static final Random RANDOM = new Random();

public static final int FONT_SIZE = 8;
public static final int ACTION_BAR_SIZE = FONT_SIZE * 6 - 2;

public static final int COLUMNS = 30, ROWS = 20;
public static final int GAME_SPEED = 2; // Speed the Board Updates; Lower = Faster

private static final String[] PLAYER_CLASSES = {"Lord", "Archer", "Barbarian", "Mage", "Rogue"};
private static final String[] ENEMY_CLASSES = {"Slime"};

public volatile static int tick = 0;
private static int turn = 0;
private static Tile highlighted;

public static Board board;
public static ActionBar actionBar;
public static ArrayList<Player> players;
public static ArrayList<Enemy> enemies;

public static void sleep(int time) {
  try {
    Thread.sleep(time);
  } catch(InterruptedException e) {}
}

void setup() {
  size(16 * 30, 16 * 20 + 46);
  background(92, 160, 72);

  board = new Board(ROWS, COLUMNS);
  actionBar = new ActionBar();

  players = new ArrayList<Player>();
  enemies = new ArrayList<Enemy>();
  
    // CHANGE - Add to character subclasses
  HashMap<String, Integer> stats = new HashMap<String, Integer>();
  stats.put("Defense", 1);
  stats.put("Strength", 1);
  stats.put("Speed", 1);

   Tile spawnLocation = board.getRandomTile();
   while (spawnLocation.hasEntity()) spawnLocation = board.getRandomTile();
   players.add(new Lord(spawnLocation));
   Tile spawnLocation1 = board.getRandomTile();
   while (spawnLocation1.hasEntity()) spawnLocation1 = board.getRandomTile();
   players.add(new Thief(spawnLocation1));
   Tile spawnLocation2 = board.getRandomTile();
   while (spawnLocation2.hasEntity()) spawnLocation2 = board.getRandomTile();
   players.add(new Mage(spawnLocation2));
   Tile spawnLocation3 = board.getRandomTile();
   while (spawnLocation3.hasEntity()) spawnLocation3 = board.getRandomTile();
   players.add(new Archer(spawnLocation3));
   Tile spawnLocation4 = board.getRandomTile();
   while (spawnLocation4.hasEntity()) spawnLocation4 = board.getRandomTile();
   players.add(new Barbarian(spawnLocation4));

  for (int i = 0; i < 3; i++) {
    Tile spawnLocation5 = board.getRandomTile();
    while (spawnLocation5.hasEntity()) spawnLocation5 = board.getRandomTile();
    enemies.add(new Enemy(RANDOM.nextInt(10) + 5, RANDOM.nextInt(10) + 5, spawnLocation5, "Slime", stats));
  }

  for (Player player : players) {
    player.getPosition().addEntity(player);
    Weapon sword = new Sword(30, 7, 5, "Brave");
    player.give(sword);
    player.equip(sword);
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
  if (frameCount % GAME_SPEED == 0) tick++;
}

// CHANGE - Replace with an end turn button
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
      actionBar.reset();
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
        highlighted.transform("Red");
      }
    }
  }
}
