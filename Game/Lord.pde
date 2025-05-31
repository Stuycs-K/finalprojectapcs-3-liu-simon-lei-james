import java.util.Arrays;

public class Lord extends Player {
  // Note: there can only be one lord, the lord's death is a lose condition. Stats will likely be much greater than other classes as a result
  public Lord(Tile startingPosition) {
    super(10, 5, startingPosition, "Lord", new HashMap<String, Integer>() {{
      put("Strength", 7);
      put("Speed", 9);
      put("Defense", 5);
    }}, new ArrayList<String>(Arrays.asList("Sword")));
  }
}
