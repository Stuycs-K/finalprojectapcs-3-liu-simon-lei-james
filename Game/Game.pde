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

  players = new ArrayList<Player>();
  enemies = new ArrayList<Enemy>();
  for (int i = 0; i < 3; i++) players.add(new Player("lord", 10, 10, board.getRandomTile()));
  for (int i = 0; i < 3; i++) enemies.add(new Enemy("slime", 10, 10, board.getRandomTile()));

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
  if (frameCount % GAME_SPEED != 0 && !updateQueue.isEmpty()) {
    try {
      updateQueue.remove().display();
    } catch (NoSuchElementException e) {}
  }
}

void keyPressed() {
  board.reset();
  for (Player player : players) {
    player.endTurn();
  }
  for (Enemy enemy : enemies) {
    enemy.target(players.get(0));
    enemy.endTurn();
  }
  turn++;
  System.out.println(turn);
}

void mouseClicked() {
  board.reset();
  Tile clickLocation = board.get(mouseX / Tile.WIDTH, mouseY / Tile.HEIGHT);
  String type = clickLocation.getEntity();
  switch (type) {
    case "Player":
      int action = board.getPlayer(clickLocation).getActions().getFirst();
      if (!(action == 0)){
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
      break;
    case "Tile":
      if (highlighted != null && highlighted.getEntity().equals("Player")) {
        board.getPlayer(highlighted).moveTo(clickLocation);
        board.getPlayer(highlighted).consumeActions(3);
      }
      break;
    case "Enemy":
      if (highlighted != null && highlighted.getEntity().equals("Player")) {
        if (board.getPlayer(highlighted).moveTo(clickLocation)) {
          board.getPlayer(highlighted).mainAttack(board.getEnemy(clickLocation));
          int enemyCurrentHealth = board.getEnemy(clickLocation).getHealth().getFirst();
          if (enemyCurrentHealth <= 0){
            System.out.println("enemy defeated!");
            enemies.remove(board.getEnemy(clickLocation));
            clickLocation.removeEntity();
          }
          board.getPlayer(highlighted).consumeActions(3);
        };
      }
      break;
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
        if (highlighted != null && highlighted.getEntity().equals("Player")) {
          // Selected player moves to and attacks enemy
          if (board.getPlayer(highlighted).moveTo(clickLocation)) {
            board.getPlayer(highlighted).mainAttack(board.getEnemy(clickLocation));
          }
          highlighted = null;
        } else {
          clickLocation.transform("Red");
          highlighted = clickLocation;
        }
        break;
    }
  } else {

  }
}
