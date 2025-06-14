public class ActionBar { 
  private int X = 4;
  private int Y = height - ACTION_BAR_SIZE + 4;
  private int WIDTH = width - 6;
  private int HEIGHT = ACTION_BAR_SIZE - 6;
  
  private LinkedList<String> messageQueue = new LinkedList<String>();

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
    text(text, X + CELL_WIDTH * col + PADDING * 4, Y + PADDING * 4 + row * (CELL_HEIGHT - PADDING));
  }

  public void write(String text) {
    if (status != "Message") {
      message = text;
      status = "Message";
    } else {
      messageQueue.add(text);
    }
    write(0, 0, text);
  }

  public void displayStats(Character character) {
    write(0, 0, "Skill: " + character.getStat("Skill"));
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
  
  public void displayConditions() {
    ArrayList<Condition> conditions = ((Character) highlighted.getEntity()).getConditions();
    for (int i = 0; i < conditions.size(); i++) {
        write(i / 2, i % 2, conditions.get(i).toString() +  " " + conditions.get(i).getDuration());
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
      write(0, 0, character.toString());
      if (character.hasWeapon()) {
        write(0, 1, character.getWeapon().toString());
      } else {
        write(0, 1, "Weaponless");
      }
      if (character instanceof Player) {
        if (((Player) character).turn) {
          setOptions(new String[]{"End Turn", "Inventory", "Attack", "Character Stats"});
        } else {
          setOptions(new String[]{"Inventory", "Character Stats"});
        }
      } else {
        if (character.hasWeapon()) {
          setOptions(new String[]{"Character Stats", "View Weapon"});
        } else {
          setOptions(new String[]{"Character Stats"});
        }
      }
      displayOptions();
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
        write(0, 0, message);
        if (messageQueue.size() >= 1) write(0, 1, "(Click for Next Message)");
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
        displayConditions();
        displayOptions();
        break;
      case "Item":
        displayItem();
        displayOptions();
        break;
    }
  }

  public void displayItem() {
    if (displayed instanceof Consumable) {
      write(0, 0, displayed.toString());
      write(0, 1, "Uses: " + ((Consumable) displayed).getUses());
    } else {
      write(0, 0, "Durability: " + ((Weapon) displayed).getDurability());
      write(0, 1, "Range: " + ((Weapon) displayed).getStat("Range"));
      write(1, 0, "Hit: " + ((Weapon) displayed).getStat("Hit"));
      write(1, 1, "Power: " + ((Weapon) displayed).getStat("Power"));
      write(2, 1, "Weight: " + ((Weapon) displayed).getStat("Weight"));
    }
  }

  public void click() {
    if (status.equals("Message")) {
      if (messageQueue.size() == 0) {
        status = "None";
      } else {
        message = messageQueue.pop();
      }
      return;
    } else {
      messageQueue = new LinkedList<String>();
    }
    if (status.equals("None")) return;
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
      case "View Weapon":
        setOptions(new String[] {"Return"});
        displayed = ((Character) highlighted.getEntity()).getWeapon();
        status = "Item";
        break;
      case "Character Stats":
        setOptions(new String[] {"Return", "Conditions"});
        status = "Character Stats";
        break;
      case "Conditions":
        setOptions(new String[] {"Return", "Character Stats"});
        status = "Conditions";
        break;
      case "Return":
        status = "Focus";
        break;
      case "Attack":
        Game.action = "Attacking";
        ArrayList<Tile> range = ((Player) highlighted.getEntity()).attackRange();
        for (Tile tile : range) {
          if (tile.getEntity() instanceof Enemy) tile.highlight();
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
      case "Equip":
        status = "Focus";
        if (!((Player) highlighted.getEntity()).equip((Weapon) displayed)) {
          write(((Player) highlighted.getEntity()).toString() + " is not proficient with " + displayed + "s");
        }
        break;
      case "Give":
        Game.action = "Giving";
        ArrayList<Tile> adjacent = ((Player) highlighted.getEntity()).getPosition().tilesInRadius(1);
        for (Tile tile : adjacent) {
          if (tile.getEntity() instanceof Player) tile.highlight();
        }
        highlighted.unhighlight();
        break;
      default:
        status = "Item";
        displayed = ((Player) highlighted.getEntity()).getItem(action);
        if (((Player) highlighted.getEntity()).turn) {
          if (displayed instanceof Consumable) {
            setOptions(new String[] {"Inventory", "Consume", "Give"});
          } else {
            setOptions(new String[] {"Inventory", "Equip", "Give"});
          }
        } else {
          setOptions(new String[] {"Inventory"});
        }
        displayItem();
        break;
    }
  }
}
