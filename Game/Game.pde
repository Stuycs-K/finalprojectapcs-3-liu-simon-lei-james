import java.util.Random;
import java.util.NoSuchElementException;

public static final int COLUMNS = 30, ROWS = 20, ACTION_BAR_SIZE = 50;
public static final int GAME_SPEED = 2; // Speed the Board Updates; Lower = Faster
public static final int[][] DIRECTIONS = {{1, 0}, {0, 1}, {-1, 0}, {0, -1}};
public static final Random RANDOM = new Random();
public volatile static int TICK = 0;

public volatile static Board board;
public static ActionBar actionBar;
public static ArrayList<Player> players;
public static ArrayList<Enemy> enemies;

public static Tile highlighted;


public static void sleep(int time) {
  try {
    Thread.sleep(time);
  } catch(InterruptedException e) {}
}

void setup() {
  size(16 * 30, 16 * 20 + 50);
  background(92, 160, 72);
  board = new Board(ROWS, COLUMNS);
  actionBar = new ActionBar();
  
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
  actionBar.display(players.get(0));
}

void draw() {
  board.display();
  if (frameCount % GAME_SPEED == 0) TICK++;
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
          board.getPlayer(highlighted).moveTo(clickLocation); // Selected player goes to tile
        }
        break;
      case "Enemy":
        actionBar.display(board.getEnemy(clickLocation));
        if (highlighted != null && highlighted.getEntity().equals("Player")) {
          // Selected player moves to and attacks enemy
          if (board.getPlayer(highlighted).moveTo(clickLocation)) {
            board.getPlayer(highlighted).mainAttack(board.getEnemy(clickLocation));
          }
        } else {
          clickLocation.transform("Red");
        }
        break;
    }
    highlighted = clickLocation;
  } else {
    
  }
}
