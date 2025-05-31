public class Lord extends Player{ //note: there can only be one lord, the lord's death is a lose condition. Stats will likely be much greater than other classes as a result
  
  public Lord(int maxHealth, Tile startingPosition, HashMap<String, Integer> stats) {
    super(maxHealth, 5, startingPosition, "Lord", stats);
    stats.replace("Strength", stats.get("Strength") + 7);
    stats.replace("Speed", stats.get("Speed") + 7);
    stats.replace("Defense", stats.get("Defense") + 5);
  }
  
}
