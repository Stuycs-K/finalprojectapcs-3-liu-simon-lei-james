public class ActionBar { 
  private int X = 4;
  private int Y = height - ACTION_BAR_SIZE + 4;
  private int WIDTH = width - 6;
  private int HEIGHT = ACTION_BAR_SIZE - 6;
  
  private Tile highlighted;
  private ArrayList<String> options = new ArrayList<String>();
  
  public ActionBar() {
    clear();
    PFont font = createFont("font.ttf", FONT_SIZE);
    textFont(font);
    textLeading(16);
    textAlign(LEFT, TOP);
  }
  
  private void clear() {
    fill(90, 67, 33, 255);
    rect(X - 2, Y - 2, WIDTH + 2, HEIGHT + 2, 5);
    fill(255);
  }
  
  private void removeHighlighted() {
    highlighted = null;
    clear();
  }
  
  public void write(String s) {
    removeHighlighted();
    text(s, X + FONT_SIZE, Y + FONT_SIZE, X + WIDTH - FONT_SIZE * 2, Y + HEIGHT - FONT_SIZE * 2);
  }
  
  public void displayOptions() {
    int boxWidth = FONT_SIZE * 23 / 2;
    int[][] bounds = {
      {X + WIDTH - FONT_SIZE * 12, (Y - 2) + FONT_SIZE / 2},
      {X + WIDTH - FONT_SIZE * 12, (Y - 2) + FONT_SIZE * 3},
      {X + WIDTH - FONT_SIZE * 24, (Y - 2) + FONT_SIZE / 2},
      {X + WIDTH - FONT_SIZE * 24, (Y - 2) + FONT_SIZE * 3},
    };
    for (int i = 0; i < options.size(); i++) {
      rect(bounds[i][0], bounds[i][1], boxWidth, FONT_SIZE * 2, 5);
      fill(0);
      text(options.get(i), bounds[i][0] + FONT_SIZE / 2 + 1, bounds[i][1] + FONT_SIZE / 2 + 1, boxWidth - FONT_SIZE - 2, FONT_SIZE);
      fill(255);
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
        setOptions(new String[]{"Inventory", "Character Stats", "Attack", "Give"}); 
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
    if (highlighted != null) focus(highlighted);
    displayOptions();
  }
}
