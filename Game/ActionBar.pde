public class ActionBar { 
  private int X = 4;
  private int Y = height - ACTION_BAR_SIZE + 4;
  private int WIDTH = width - 6;
  private int HEIGHT = ACTION_BAR_SIZE - 6;

  private String[] options;

  private int OPTION_WIDTH = FONT_SIZE * 29 / 2 - 2;
  private int OPTION_HEIGHT = FONT_SIZE * 2;
  private int OPTION_GAP = FONT_SIZE / 2;
  private int PADDING = FONT_SIZE / 2;

  public String status = "None"; // Message, None, Focus, Inventory
  private String message;

  public ActionBar() {
    drawBackground();
    textFont(createFont("font.ttf", FONT_SIZE));
    textLeading(16);
    textAlign(LEFT, TOP);
  }

  private void drawBackground() {
    fill(90, 67, 33, 255);
    rect(X - 2, Y - 2, WIDTH + 2, HEIGHT + 2, 5);
    fill(255);
  }
  
  private void write(int col, int row, String text) {
    text(text, X + FONT_SIZE * (1 + col * 14), Y + FONT_SIZE * (1 + row * 2));
  }

  public void write(String text) {
    status = "Message";
    message = text;
    write(0, 0, text);
  }
  
  public void displayStats(Character character) {
    write(0, 0, character.getCharacterClass() + " " + character.getName());
    write(0, 1, "Speed: " + character.getStat("Speed"));
    write(1, 0, "Strength: " + character.getStat("Strength"));
    write(1, 1, "Defense: " + character.getStat("Defense"));
    write(2, 0, "Magic: " + character.getStat("Magic"));
    write(2, 1, "Resistance: " + character.getStat("Resistance"));
  }
  
  public void displayOptions() {
    int x = X + WIDTH - OPTION_WIDTH - OPTION_GAP;
    int y = Y - 2 + OPTION_GAP;
    
    for (int i = 0; i < options.length; i++) {
      rect(x, y, OPTION_WIDTH, OPTION_HEIGHT, 5);
      if (options[i] != null) {
        fill(0);
        text(options[i], x + PADDING + 1, y + PADDING + 1, OPTION_WIDTH - 2 * PADDING - 2, OPTION_HEIGHT - 2 * PADDING);
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

  public void setOptions(String[] options) {
    this.options = options; 
  }

  public void focus(Tile tile) {
    status = "Focus";
    drawBackground();
    
    if (tile.hasEntity() && tile.getEntity() instanceof Character) {
      Character character = (Character) tile.getEntity();
      write(0, 0, character.getCharacterClass() + " " + character.getName());
      if (character instanceof Player) {
        write(0, 1, ((Player) character).getWeapon());
        setOptions(new String[]{"End Turn", "Inventory", "Attack", "Character Stats"});
        displayOptions();
      } else {
        write(0, 1, tile.getTerrain() + " Tile");
      }
      write(1, 0, "Health: " + character.getHealth());
      write(1, 1, "Movement: " + character.getMovement());
    } else {
      if (tile.hasEntity()) {
        write(0, 0, tile.getTerrain() + " Tile With Chest");
      } else {
        write(0, 0, tile.getTerrain() + " Tile");
      }
      write(0, 1, "Movement Cost: " + tile.getMovementPenalty());
    }
  }

  public void update() {
    drawBackground();
    switch (status) {
      case "Message":
        write(message);
        break;
      case "Focus":
        focus(highlighted);
        break;
      case "Inventory":
        displayOptions();
        break;
      case "Character Stats":
        displayStats((Character) highlighted.getEntity());
        displayOptions();
        break;
    }
  }

  public void click() {
    String action = null;
    int x = X + WIDTH - OPTION_WIDTH - OPTION_GAP;
    int y = Y - 2 + OPTION_GAP;
    for (int i = 0; i < options.length; i++) {
      if (x < mouseX && mouseX < x + OPTION_WIDTH && y < mouseY && mouseY < y + OPTION_HEIGHT) {
        action = options[i];
      }
      if (i % 2 == 0) {
        y = (Y - 2) + FONT_SIZE * 3;
      } else {
        x -= OPTION_WIDTH + OPTION_GAP;
        y = (Y - 2) + FONT_SIZE / 2;
      }
    }
    if (action == null) return;
    switch (action) {
      case "Inventory":
        status = "Inventory";
        ArrayList<Item> inventory = ((Player) highlighted.getEntity()).getInventory();
        String[] options = new String[8];
        options[0] = "Return";
        for (int i = 0; i < inventory.size(); i++) {
          options[7 - i] = inventory.get(i).toString();
        }
        setOptions(options);
        break;
      case "Character Stats":
        setOptions(new String[] {"Return"});
        status = "Character Stats";
        break;
      case "Return":
        status = "Focus";
    }
  }
}
