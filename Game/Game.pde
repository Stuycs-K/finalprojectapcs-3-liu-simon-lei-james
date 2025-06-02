import java.util.Random;
import java.util.List;

public static final int[][] DIRECTIONS = {{1, 0}, {0, 1}, {-1, 0}, {0, -1}};
public static final Random RANDOM = new Random();

public static final int FONT_SIZE = 8;
public static final int ACTION_BAR_SIZE = FONT_SIZE * 6;

public static final int COLUMNS = 30, ROWS = 20;
public static final int GAME_SPEED = 2; // Speed the Board Updates; Lower = Faster

private static final ArrayList<String> PLAYER_CLASSES = new ArrayList<String>(Arrays.asList("Lord", "Archer", "Barbarian", "Mage", "Thief"));
private static final ArrayList<String> ENEMY_CLASSES = new ArrayList<String>(Arrays.asList("Slime"));

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
  size(16 * 30, 16 * 20 + 48);
  background(92, 160, 72);

  board = new Board(ROWS, COLUMNS);
  actionBar = new ActionBar();

  players = new ArrayList<Player>();
  enemies = new ArrayList<Enemy>();

  Collections.shuffle(PLAYER_CLASSES);
  for (String playerClass : PLAYER_CLASSES) {
    Tile spawnLocation = board.getRandomTile();
    while (spawnLocation.hasEntity()) spawnLocation = board.getRandomTile();
    Player player = null;
    switch (playerClass) {
      case "Lord":
        player = new Lord(spawnLocation);
        break;
      case "Archer":
        player = new Archer(spawnLocation);
        break;
      case "Barbarian":
        player = new Barbarian(spawnLocation);
        break;
      case "Mage":
        player = new Mage(spawnLocation);
        break;
      case "Thief":
        player = new Thief(spawnLocation);
        break;
     }
     players.add(player);
  }
  for (int i = 0; i < 7; i++) {
    Tile spawnLocation = board.getRandomTile();
    while (spawnLocation.hasEntity()) spawnLocation = board.getRandomTile();
    enemies.add(new Slime(spawnLocation));
  }
  Tile spawnLocation = board.getRandomTile();
  while (spawnLocation.hasEntity()) spawnLocation = board.getRandomTile();
  Chest chest = new Chest(spawnLocation);

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
  actionBar.write("Turn " + turn);
}

void mouseClicked() {
  board.reset();
  if (mouseY < height - ACTION_BAR_SIZE) {
    Tile clickLocation = board.get(mouseX / Tile.WIDTH, mouseY / Tile.HEIGHT);
    if (mouseButton == RIGHT) { // Clear Highlight
      if (highlighted != null) highlighted.transform("None");
      highlighted = null;
      actionBar.removeHighlighted();
      return;
    }
    Entity entity = clickLocation.getEntity();
    if (entity == null) {
      if (highlighted != null && highlighted.getEntity() instanceof Player) {
        if (! ((Player) highlighted.getEntity()).moveTo(clickLocation)) {
          clickLocation.transform("Blue");
          actionBar.focus(clickLocation);
        } else {
          actionBar.removeHighlighted();
        }
        highlighted = null;
      } else {
        clickLocation.transform("Blue");
        actionBar.focus(clickLocation);
      }
    } else if (entity instanceof Player) {
      actionBar.focus(clickLocation);
      ArrayList<Tile> range = ((Player) entity).movementRange();
      for (Tile tile : range) {
        tile.transform("Blue");
        if (tile.getEntity() instanceof Enemy) tile.transform("Red");
      }
      highlighted = clickLocation;
    } else if (entity instanceof Enemy || entity instanceof Chest) {
      if (highlighted != null && highlighted.getEntity() instanceof Player) {
        actionBar.removeHighlighted();
        if (! ((Player) highlighted.getEntity()).moveTo(clickLocation)) {
          actionBar.focus(clickLocation);
        }
        highlighted = null;
      } else {
        highlighted = clickLocation;
        clickLocation.transform("Red");
        actionBar.focus(clickLocation);
      }
    }
  } else {
    actionBar.click();
  }
}
