public class ActionBar { 
  public Pair<Integer, Integer> topRight; // X, Y
  public Pair<Integer, Integer> dimensions; // Width, Height

  public Character highlighted;

  public ActionBar() {
    topRight = new Pair<Integer, Integer>(2, height - ACTION_BAR_SIZE + 2);
    dimensions = new Pair<Integer, Integer>(width - 4, ACTION_BAR_SIZE - 4);

    reset();
    PFont font = createFont("font.ttf", FONT_SIZE);
    textFont(font);
    textLeading(16);
  }
  private void reset() {
    highlighted = null;
    fill(90, 67, 33, 255);
    rect(topRight.getFirst(), topRight.getSecond(), dimensions.getFirst(), dimensions.getSecond(), 5);
    fill(255);
  }
  public void write(String s) {
    reset();
    text(s, topRight.getFirst() + FONT_SIZE, topRight.getSecond() + FONT_SIZE, topRight.getFirst() + dimensions.getFirst() - FONT_SIZE * 2, topRight.getSecond() + dimensions.getSecond() - FONT_SIZE * 2);
  }
  public void display(Character character) {
    reset();
    highlighted = character;
    text("Health: " + character.getHealth(), topRight.getFirst() + FONT_SIZE, topRight.getSecond() + FONT_SIZE * 2);
    text("Movement: " + character.getMovement(), topRight.getFirst() + FONT_SIZE, topRight.getSecond() + FONT_SIZE * 4);
    // strokeWeight(7);
    // line(topRight.getFirst() + 10, topRight.getSecond() + 10, topRight.getFirst() + 110, topRight.getSecond() + 10);
  }
  public void update() {
    if (highlighted != null) {
      display(highlighted);
    }
  }
}
