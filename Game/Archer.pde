public class Archer extends Player {
  public Archer(Tile startingPosition) {
    super(20, 6, startingPosition, "Archer", new HashMap<String, Integer>() {{
      put("Strength", 6);
      put("Speed", 10);
      put("Defense", 3);
      put("Magic", 0);
      put("Resistance", 3);
    }}, new ArrayList<String>(Arrays.asList("Bow")));
    Weapon bow = new Bow("Iron Bow");
    give(bow);
    equip(bow);
  }
}
