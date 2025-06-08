import java.util.Random;
import java.util.List;
import java.util.Arrays;
import java.util.Set;

public static final int[][] DIRECTIONS = {{1, 0}, {0, 1}, {-1, 0}, {0, -1}};
public static final Random RANDOM = new Random();

public static final int FONT_SIZE = 16;
public static final int ACTION_BAR_SIZE = FONT_SIZE * 6;

public static final int COLUMNS = 30, ROWS = 20;
public static final int GAME_SPEED = 1; // Speed the Board Updates; Lower = Faster

public static int BOARD = 0;
public static int HIT_CHANCE = 0;
public static int CONDITION_CHANCE = 0;

private static final ArrayList<String> PLAYER_CLASSES = new ArrayList<String>(Arrays.asList("Lord", "Archer", "Barbarian", "Mage", "Thief", "Cavalier"));
/* additional classes that could be nice to have:
   Cavalier/Paladin: well-rounded stats, high movement, uses lances/axes/swords, can move after an attack (will change the other classes to automatically end their turn after attacking if cavalier does get added), gets punished harder by terrain (higher movement reduction from forests, can't cross hills/mountains at all)
   Pegasus Knight: emphasis on speed, resistance, and avoid (if accuracy is implemented), high movement, uses lances/swords, can move after an attack, ignores terrain, weak to arrows
   Wyvern Knight: emphasis on health, attack, and defense, high movement, uses lances/axes, can move after an attack, ignores terrain, weak to all magic
   (this is for balancing, wyverns are consistently among the best classes in Fire Emblem games due to high mobility alongside high strength and bulk without compromising speed. To make them less dominant, emphasize their usual vulnerabilty to magic, something
   pegasus knights are usually good against)
*/
private static final ArrayList<String> ENEMY_CLASSES = new ArrayList<String>(Arrays.asList("Slime", "Soldier", "Bully", "Mercenary"));

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

public void endGame(String winner) {
  background(0);
  textAlign(CENTER, CENTER);
  text("You " + winner + "!", width / 2, height / 2);
  noLoop();
}

void setup() {
  size(32 * 30, 32 * 20 + 96);
  background(92, 160, 72);

  board = new Board(ROWS, COLUMNS);
  actionBar = new ActionBar();

  players = new ArrayList<Player>();
  enemies = new ArrayList<Enemy>();
  
  if (BOARD == 6) {
    Weapon trialAxe = new Axe("Iron");
    Weapon trialSword = new Sword("Iron");
    for (int i = 0; i < 3; i++){
      players.add(new Cavalier(board.get(6, i * 9)));
      players.add(new Cavalier(board.get(22, i * 9)));
    }
    enemies.add(new Bully(board.get(14, 0)));
    players.get(0).give(trialSword);
    players.get(0).equip(trialSword);
    enemies.add(new Mercenary(board.get(14, 9)));
    players.get(3).give(trialAxe);
    players.get(3).equip(trialAxe);
    enemies.add(new Soldier(board.get(14, 18)));
    players.get(4).give(trialAxe);
    players.get(4).equip(trialAxe);
    players.get(5).give(trialSword);
    players.get(5).equip(trialSword);
  } else {
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
          if (BOARD == 4) { // Board 4 is the special weapons. Lord is not given special weapons because the brave sword is already a special weapon
            Weapon special = new Bow("Sleep");
            player.give(special);
            player.equip(special);
          }
          break;
        case "Barbarian":
          player = new Barbarian(spawnLocation);
          if (BOARD == 4) {
            Weapon special = new Axe("Killer");
            player.give(special);
            player.equip(special);
          }
          break;
        case "Mage":
          player = new Mage(spawnLocation);
          if (BOARD == 4) {
            Weapon special;
            if (RANDOM.nextInt(2) == 0) {
              special = new Tome("Thunder");
            } else {
              special = new Tome("Blizzard");
            }
            // Every tome the mage is technically a special weapon, so what weapon they get for Board 2 is decided randomly
            player.give(special);
            player.equip(special);
          }
          break;
        case "Thief":
          player = new Thief(spawnLocation);
          if (BOARD == 4){
            Weapon special = new Sword("Sleep");
            player.give(special);
            player.equip(special);
          }
          break;
        case "Cavalier":
          player = new Cavalier(spawnLocation);
          if (BOARD == 4) {
            Weapon special = new Lance("Javelin");
            player.give(special);
            player.equip(special);
        }
        break;
      }
      players.add(player);
      if (BOARD == 5) {
        player.give(new Vulnerary());
        player.give(new PureWater());
      }
    }
    int numEnemies = 7;
    if (BOARD == 7) numEnemies = 1;
    for (int i = 0; i < numEnemies; i++) {
      Tile spawnLocation = board.getRandomTile();
      while (spawnLocation.hasEntity()) spawnLocation = board.getRandomTile();
      if (BOARD == 1) {
        enemies.add(new Slime(spawnLocation));
      } else if (BOARD == 2) {
        enemies.add(new Soldier(spawnLocation));
      } else {
        int chosenClass = RANDOM.nextInt(4);
        if (chosenClass == 0) {
          enemies.add(new Slime(spawnLocation));
        } else if (chosenClass == 1){
          enemies.add(new Soldier(spawnLocation));
        } else if (chosenClass == 2){
          enemies.add(new Bully(spawnLocation));
        } else{
          enemies.add(new Mercenary(spawnLocation));
        }
      }
    }
  }

  int numChests;
  switch (BOARD) {
    case 3:
      numChests = 10;
      break;
    case 6:
      numChests = 0;
      break;
    default:
      numChests = 2;
      break;
  }
  for (int i = 0; i < numChests; i++) {
    Tile spawnLocation = board.getRandomTile();
    while (spawnLocation.hasEntity()) spawnLocation = board.getRandomTile();
    Chest chest = new Chest(spawnLocation);
  }

  board.display();
  actionBar.write("Welcome to our game. Please click on a player to begin.");
}

void draw() {
  if (enemies.size() == 0) {
    endGame("Won");
  } else if (players.size() == 0) {
    endGame("Lost");
  } else {
    board.display();
    actionBar.update();
    if (frameCount % GAME_SPEED == 0) tick++;
  }
}

void keyPressed() {
  if ('0' < key && key < '9') {
    BOARD = key - '0';
    setup();
  }
  switch (key) {
    case ' ':
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
      for (int i = 0; i < players.size(); i++) {
        players.get(i).turn = true;
      }
      turn++;
      break;
    case 'h':
      actionBar.write("Character health has been increased!");
      for (int i = 0; i < players.size(); i++) {
        players.get(i).getHealth().max += 100;
        players.get(i).getHealth().current += 100;
      }
      for (int i = 0; i < enemies.size(); i++) {
        enemies.get(i).getHealth().max += 100;
        enemies.get(i).getHealth().current += 100;
      }
      break;
    case 'c':
      if (CONDITION_CHANCE == 0) {
        CONDITION_CHANCE = 100;
        actionBar.write("Chance of applying conditions has been increased!");
      } else {
        CONDITION_CHANCE = 0;
        actionBar.write("Chance of applying conditions has been decreased!");
      }
      break;
    case 'a':
      if (HIT_CHANCE == 0) {
        HIT_CHANCE = 100;
        actionBar.write("Chance of hitting has been increased!");
      } else {
        HIT_CHANCE = 0;
        actionBar.write("Chance of hitting has been decreased!");
      }
      break;
  }
}

private void highlightTile(Tile tile) {
  highlighted = tile;
  tile.highlight();
  actionBar.focus(tile);
}

private void removeHighlighted() {
  highlighted = null;
  action = "None";
  actionBar.status = "None";
}

void mouseClicked() {
  if (mouseButton == RIGHT) {
    board.reset();
    actionBar.status = "None";
    action = "None";
    if (highlighted != null) highlighted.unhighlight();
    highlighted = null;
    return;
  }
  if (mouseY > height - ACTION_BAR_SIZE) {
    board.reset();
    actionBar.click();
  } else {
    Tile clickedTile = board.get(mouseX / Tile.WIDTH, mouseY / Tile.HEIGHT);
    Entity entity = clickedTile.getEntity();
    if (action.equals("Giving")) {
      board.reset();
      if (entity instanceof Player) {
        ((Player) entity).give(actionBar.displayed);
        ((Player) highlighted.getEntity()).take(actionBar.displayed);
        ((Player) highlighted.getEntity()).turn = false;
        removeHighlighted();
      } else {
        removeHighlighted();
        highlightTile(clickedTile);
      }
      action = "None";
    } else if (action.equals("None") || entity instanceof Player) { // Selecting New Tile
      board.reset();
      if (entity instanceof Player && ((Player) entity).turn) { // Select Player
        action = "Moving";
        ArrayList<Tile> range = ((Player) entity).movementRange();
        for (Tile tile : range) {
          if (!(tile.getEntity() instanceof Player)) tile.highlight();
        }
      }
      highlightTile(clickedTile);
    } else if (action.equals("Moving")) {
      if (clickedTile.isHighlighted()) {
        ((Player) highlighted.getEntity()).moveTo(clickedTile);
        removeHighlighted();
        board.reset();
      } else {
        board.reset();
        highlightTile(clickedTile);
        action = "None";
      }
    } else if (action.equals("Attacking")) {
      if (entity instanceof Enemy && clickedTile.isHighlighted()) {
        ((Player) highlighted.getEntity()).attack((Character) entity);
        removeHighlighted();
      } else {
        highlightTile(clickedTile);
      }
      board.reset();
    }
  }
}
