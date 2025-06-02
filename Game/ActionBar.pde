public class ActionBar { 
  private int X = 4;
  private int Y = height - ACTION_BAR_SIZE + 4;
  private int WIDTH = width - 6;
  private int HEIGHT = ACTION_BAR_SIZE - 6;

  private Tile highlighted;
  private ArrayList<String> options = new ArrayList<String>();

  private int OPTION_WIDTH = FONT_SIZE * 29 / 2 - 2;
  private int OPTION_GAP = FONT_SIZE / 2;
  private int OPTION_HEIGHT = FONT_SIZE * 2;
  private int PADDING = FONT_SIZE / 2;

  private String message;

  public ActionBar() {
    clear();
    PFont font = createFont("font.ttf", FONT_SIZE);
    textFont(font);
    textLeading(16);
    textAlign(LEFT, TOP);
    message = null;
  }

  private void clear() {
    message = null;
    fill(90, 67, 33, 255);
    rect(X - 2, Y - 2, WIDTH + 2, HEIGHT + 2, 5);
    fill(255);
  }

  private void removeHighlighted() {
    highlighted = null;
    options = new ArrayList<String>();
    clear();
  }

  public void write(String s) {
    removeHighlighted();
    message = s;
    text(s, X + FONT_SIZE, Y + FONT_SIZE, X + WIDTH - FONT_SIZE * 2, Y + HEIGHT - FONT_SIZE * 2);
  }

  public void displayOptions() {
    clear();
    int x = X + WIDTH - OPTION_WIDTH - OPTION_GAP;
    int y = Y - 2 + OPTION_GAP;
    
    for (int i = 0; i < options.size(); i++) {
      rect(x, y, OPTION_WIDTH, OPTION_HEIGHT, 5);
      if (options.get(i) != null) {
        fill(0);
        text(options.get(i), x + PADDING + 1, y + PADDING + 1, OPTION_WIDTH - 2 * PADDING - 2, OPTION_HEIGHT - 2 * PADDING);
        fill(255);
      }
      if (i % 2 == 0) {
        y = (Y - 2) + FONT_SIZE * 3;
      } else {
        x -= OPTION_WIDTH + OPTION_GAP;
        y = (Y - 2) + FONT_SIZE / 2;
      }
    }
  }

  public void setOptions(String[] newOptions) {
    options = new ArrayList<String>();
    for (String s : newOptions) {
      options.add(s);
    }
  }

  public void focus(Tile tile) {
    clear();
    options = new ArrayList<String>();
    if (tile.hasEntity() && tile.getEntity() instanceof Character) {
      Character character = (Character) tile.getEntity();
      text(character.getCharacterClass() + " " + character.getName(), X + FONT_SIZE, Y + FONT_SIZE);
      if (character instanceof Player) {
        text(((Player) character).getWeapon(), X + FONT_SIZE, Y + FONT_SIZE * 3);
        setOptions(new String[]{"End Turn", "Inventory", "Attack", "Character Stats"});
      } else {
        text(tile.getTerrain() + " Tile", X + FONT_SIZE, Y + FONT_SIZE * 3);
      }
      text("Health: " + character.getHealth(), X + FONT_SIZE * 15, Y + FONT_SIZE);
      text("Movement: " + character.getMovement(), X + FONT_SIZE * 15, Y + FONT_SIZE * 3);
    } else if (tile.hasEntity()) {
      write(tile.getTerrain() + " Tile With Chest");
    } else {
      write(tile.getTerrain() + " Tile \nMovement Cost: " + tile.getMovementPenalty());
    }
    highlighted = tile;
  }

  public void update() {
    if (message != null) write(message);
    if (highlighted != null) focus(highlighted);
    // displayOptions();
  }

  public void click() {
    String action = null;
    int x = X + WIDTH - OPTION_WIDTH - OPTION_GAP;
    int y = Y - 2 + OPTION_GAP;
    for (int i = 0; i < options.size(); i++) {
      if (x < mouseX && mouseX < x + OPTION_WIDTH && y < mouseY && mouseY < x + OPTION_HEIGHT) {
        action = options.get(i);
      }
      if (i % 2 == 0) {
        y = (Y - 2) + FONT_SIZE * 3;
      } else {
        x -= OPTION_WIDTH + OPTION_GAP;
        y = (Y - 2) + FONT_SIZE / 2;
      }
    }
    switch (action) {
      case "Inventory":
        ArrayList<Item> inventory = ((Player) highlighted.getEntity()).getInventory();
        String[] options = new String[8];
        options[0] = "Return";
        for (int i = 0; i < inventory.size(); i++) {
          options[9 - i] = inventory.get(i).toString();
        }
        setOptions(options);
        break;
      case "Return":
        focus(highlighted);
    }
  }
}
