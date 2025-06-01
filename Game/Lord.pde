import java.util.Arrays;

// Note: there can only be one lord, the lord's death is a lose condition. Stats will likely be much greater than other classes as a result

public class Lord extends Player {
  public Lord(Tile startingPosition) {
    super(15, 5, startingPosition, "Lord", new HashMap<String, Integer>() {{
      put("Strength", 7);
      put("Speed", 9);
      put("Defense", 5);
      put("Magic", 0);
      put("Resistance", 3);
    }}, new ArrayList<String>(Arrays.asList("Sword")));
    
    // Default Equipment
    Weapon sword = new Sword(30, 7, 5, "Brave");
    give(sword);
    equip(sword);
  }
}
