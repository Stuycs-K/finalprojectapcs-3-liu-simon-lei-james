public class Mage extends Player{
  
  private Tome tome;
  
  public Mage(int maxHealth, Tile startingPosition, HashMap<String, Integer> stats) {
    super(maxHealth, 4, startingPosition, "Mage", stats);
    stats.replace("Strength", stats.get("Strength") + 0);
    stats.replace("Speed", stats.get("Speed") + 4);
    stats.replace("Defense", stats.get("Defense") + 2); 
    stats.put("Magic", 8);
    stats.put("Resistance", 5);
  }
  
  public void giveTome(Tome tome){
    this.tome = tome;
  }
  
}
