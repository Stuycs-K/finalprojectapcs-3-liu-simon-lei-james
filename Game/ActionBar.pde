public class ActionBar { 
  private int X = 2;
  private int Y = height - ACTION_BAR_SIZE + 2;
  private int WIDTH = width - 4;
  private int HEIGHT = ACTION_BAR_SIZE - 4;
  
  private Tile highlighted;
  
  public ActionBar() {
    clear();
    PFont font = createFont("font.ttf", FONT_SIZE);
    textFont(font);
    textLeading(16);
    textAlign(LEFT, TOP);
  }
  
  private void clear() {
    fill(90, 67, 33, 255);
    rect(X, Y, WIDTH, HEIGHT, 5);
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
  public void focus(Tile tile) {
    clear();
    if (tile.hasEntity() && tile.getEntity() instanceof Character) {
      Character character = (Character) tile.getEntity();
      text(character.getCharacterClass() + " " + character.getName(), X + FONT_SIZE, Y + FONT_SIZE);
      text(tile.getTerrain() + " Tile", X + FONT_SIZE, Y + FONT_SIZE * 3);
      text("Health: " + character.getHealth(), X + FONT_SIZE * 10, Y + FONT_SIZE);
      text("Movement: " + character.getMovement(), X + FONT_SIZE * 10, Y + FONT_SIZE * 3);
    } else if (tile.hasEntity()) {
      write(tile.getTerrain() + " Tile With Chest");
    } else {
      write(tile.getTerrain() + " Tile \nMovement Cost: " + tile.getMovementPenalty());
    }
    highlighted = tile;
  }
  public void update() {
    if (highlighted != null) focus(highlighted);
  }
}
