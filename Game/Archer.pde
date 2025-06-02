public class Archer extends Player {
  public Archer(Tile startingPosition) {
    super(10, 6, startingPosition, "Archer", new HashMap<String, Integer>() {{
      put("Strength", 6);
      put("Speed", 10);
      put("Defense", 3);
      put("Magic", 0);
      put("Resistance", 3);
    }}, new ArrayList<String>(Arrays.asList("Bow")));
    Weapon bow = new Bow(40, 5, 1, "Iron");
    give(bow);
    equip(bow);
  }
}
