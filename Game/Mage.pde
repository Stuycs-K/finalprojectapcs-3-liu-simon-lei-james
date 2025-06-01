public class Mage extends Player{
  
  private Tome tome;
  
  public Mage(Tile startingPosition) {
    super(5, 4, startingPosition, "Mage", new HashMap<String, Integer>() {{
      put("Strength", 0);
      put("Speed", 4);
      put("Defense", 2);
      put("Magic", 8);
      put("Resistance", 5);
    }}, new ArrayList<String>(Arrays.asList("Tome")));
  }
  
  public void giveTome(Tome tome){
    this.tome = tome;
  }
  
}
