import java.util.Random;
import java.util.List;

public static final int[][] DIRECTIONS = {{1, 0}, {0, 1}, {-1, 0}, {0, -1}};
public static final Random RANDOM = new Random();

public static final int FONT_SIZE = 16;
public static final int ACTION_BAR_SIZE = FONT_SIZE * 6;

public static final int COLUMNS = 30, ROWS = 20;
public static final int GAME_SPEED = 1; // Speed the Board Updates; Lower = Faster

private static final ArrayList<String> PLAYER_CLASSES = new ArrayList<String>(Arrays.asList("Lord", "Archer", "Barbarian", "Mage", "Thief"));
/* additional classes that could be nice to have:
   Cavalier/Paladin: well-rounded stats, high movement, uses lances/axes/swords, can move after an attack (will change the other classes to automatically end their turn after attacking if cavalier does get added), gets punished harder by terrain (higher movement reduction from forests, can't cross hills/mountains at all)
   Pegasus Knight: emphasis on speed, resistance, and avoid (if accuracy is implemented), high movement, uses lances/swords, can move after an attack, ignores terrain, weak to arrows
   Wyvern Knight: emphasis on health, attack, and defense, high movement, uses lances/axes, can move after an attack, ignores terrain, weak to all magic 
   (this is for balancing, wyverns are consistently among the best classes in Fire Emblem games due to high mobility alongside high strength and bulk without compromising speed. To make them less dominant, emphasize their usual vulnerabilty to magic, something 
   pegasus knights are usually good against)
*/
private static final ArrayList<String> ENEMY_CLASSES = new ArrayList<String>(Arrays.asList("Slime"));

public volatile static int tick = 0;
private static int turn = 0;

public static String action = "None";
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

private boolean isDoing(String action) {
  if (Game.action == null) return false;
  return Game.action.equals(action);
}

void setup() {
  size(32 * 30, 32 * 20 + 96);
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
  actionBar.status = "None";
  action = "None";
  for (int i = 0; i < players.size(); i++) {
    players.get(i).endTurn();
  }
  for (int i = 0; i < enemies.size(); i++) {
    enemies.get(i).takeTurn();
    enemies.get(i).endTurn();
  }
  turn++;
  actionBar.write("Turn " + turn);
}

void mouseClicked() {
  board.reset();
  if (mouseButton == RIGHT) {
    actionBar.status = "None";
    if (highlighted != null) highlighted.transform("None");
    highlighted = null;
    return;
  }
  if (mouseY > height - ACTION_BAR_SIZE) {
    actionBar.click();
  } else {
    Tile clickedTile = board.get(mouseX / Tile.WIDTH, mouseY / Tile.HEIGHT);
    Entity entity = clickedTile.getEntity();
    if (action.equals("None")) { // Selecting New Tile
      if (entity instanceof Player) { // Select Player
        action = "Moving";
        highlighted = clickedTile;
        actionBar.focus(clickedTile);
        ArrayList<Tile> range = ((Player) entity).movementRange();
        for (Tile tile : range) {
          tile.transform("Blue");
          if (tile.getEntity() instanceof Enemy) tile.transform("Red");
        }
      } else { // Select Enemy, Chest, or Tile
        highlighted = clickedTile;
        clickedTile.transform("Blue");
        actionBar.focus(clickedTile);
      } 
    } else if (isDoing("Moving")) {
      if (((Player) highlighted.getEntity()).moveTo(clickedTile)) { // Within Range
        actionBar.status = "None";
        highlighted = null;
        action = "None";
      } else { // Highlight New Tile
        highlighted = clickedTile;
        clickedTile.transform("Blue");
        actionBar.focus(clickedTile);
      }
    } else if (isDoing("Attacking")) {
      if (entity instanceof Enemy) {
        // TO BE IMPLEMENTED
      }
    }
  }
}
