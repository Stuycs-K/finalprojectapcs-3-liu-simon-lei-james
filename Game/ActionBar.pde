public class ActionBar { 
  private int X = 4;
  private int Y = height - ACTION_BAR_SIZE + 4;
  private int WIDTH = width - 6;
  private int HEIGHT = ACTION_BAR_SIZE - 6;

  private String[] options;

  private int CELL_WIDTH = WIDTH / 4;
  private int CELL_HEIGHT = HEIGHT / 2;
  private int PADDING = FONT_SIZE / 4;
  private int BORDER = 1;

  public String status = "None"; // Message, None, Focus, Inventory, Item
  public Item displayed = null; // Displayed Item
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
    text(text, X + CELL_WIDTH * col + PADDING * 4, Y + PADDING * 4 + row * (CELL_HEIGHT));
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
    int x = X + WIDTH - CELL_WIDTH + PADDING;
    int y = Y + PADDING - BORDER;
    
    for (int i = 0; i < options.length; i++) {
      rect(x, y, CELL_WIDTH - PADDING * 2, CELL_HEIGHT - PADDING * 2, 5);
      if (options[i] != null) {
        fill(0);
        text(options[i], x + PADDING * 3, y + PADDING * 3);
        fill(255);
      }
      if (i % 2 == 0) {
        y = Y + CELL_HEIGHT + PADDING - BORDER;
      } else {
        x -= CELL_WIDTH;
        y = Y + PADDING - BORDER;
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
        if (((Player) character).turn) {
          setOptions(new String[]{"End Turn", "Inventory", "Attack", "Character Stats"});
          displayOptions();
        }
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
      case "Conditions":
        displayOptions();
        break;
      case "Item":
        displayItem();
        displayOptions();
        break;
    }
  }
  
  public void displayItem() {
    write(0, 0, displayed.toString());
    if (displayed instanceof Consumable) {
      setOptions(new String[] {"Inventory", "Consume"});
      write(0, 1, "Uses: " + ((Consumable) displayed).getUses());
    } else {
      setOptions(new String[] {"Inventory", "Equip"});
      write(0, 1, "Uses: " + ((Consumable) displayed).getUses());
    }
  }

  public void click() {
    String action = null;
    int x = X + WIDTH - CELL_WIDTH + PADDING;
    int y = Y + PADDING;
    for (int i = 0; i < options.length; i++) {
      if (x < mouseX && mouseX < x + CELL_WIDTH - PADDING * 2 && y < mouseY && mouseY < y + CELL_HEIGHT - PADDING * 2) {
        action = options[i];
      }
      if (i % 2 == 0) {
        y = Y + CELL_HEIGHT + PADDING * 2;
      } else {
        x -= CELL_WIDTH;
        y = Y + PADDING;
      }
    }
    if (action == null) return;
    String[] options;
    switch (action) {
      case "Inventory":
        status = "Inventory";
        ArrayList<Item> inventory = ((Player) highlighted.getEntity()).getInventory();
        options = new String[8];
        options[0] = "Return";
        for (int i = 0; i < inventory.size(); i++) {
          options[7 - i] = inventory.get(i).toString();
        }
        setOptions(options);
        break;
      case "Character Stats":
        setOptions(new String[] {"Return", "Conditions"});
        status = "Character Stats";
        break;
      case "Conditions":
        setOptions(new String[] {"Return", "Character Stats"});
        ArrayList<Condition> conditions = ((Player) highlighted.getEntity()).getConditions();
        options = new String[8];
        options[0] = "Return";
        for (int i = 0; i < conditions.size(); i++) {
          options[7 - i] = conditions.get(i).toString() +  " " + conditions.get(i).getDuration();
        }
        setOptions(options);
        status = "Conditions";
        break;
      case "Return":
        status = "Focus";
        break;
      case "Attack":
        Game.action = "Attacking";
        ArrayList<Tile> range = ((Player) highlighted.getEntity()).attackRange();
        for (Tile tile : range) {
          if (tile.getEntity() instanceof Enemy) tile.transform("Red");
        }
        break;
      case "End Turn":
        Game.action = "None";
        ((Player) highlighted.getEntity()).turn = false;
        status = "None";
        break;
      case "Consume":
        ((Player) highlighted.getEntity()).consume((Consumable) displayed);
        status = "None";
        break;
      default:
        status = "Item";
        displayed = ((Player) highlighted.getEntity()).getItem(action);
        displayItem();
        break;
    }
  }
}
