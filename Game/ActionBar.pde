public class ActionBar {
  public static final int FONT_SIZE = 8;
  
  public Pair<Integer, Integer> topRight; // X, Y
  public Pair<Integer, Integer> dimensions; // Width, Height
  
  public ActionBar() {
    topRight = new Pair<Integer, Integer>(2, height - ACTION_BAR_SIZE + 2);
    dimensions = new Pair<Integer, Integer>(width - 4, ACTION_BAR_SIZE - 4);
    
    fill(90, 67, 33, 255);
    rect(topRight.getFirst(), topRight.getSecond(), dimensions.getFirst(), dimensions.getSecond(), 5);
    
    PFont font = createFont("font.ttf", FONT_SIZE);
    textFont(font);
    
    fill(255);
    text("Health:", topRight.getFirst() + FONT_SIZE, topRight.getSecond() + FONT_SIZE * 2);

  }
  public void display(Character character) {
    // strokeWeight(7);
    // line(topRight.getFirst() + 10, topRight.getSecond() + 10, topRight.getFirst() + 110, topRight.getSecond() + 10);
  }
}
