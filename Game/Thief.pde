public class Thief extends Player {
  public Thief(Tile startingPosition) {
    super(18, 7, startingPosition, "Thief", new HashMap<String, Integer>() {{
      put("Strength", 5);
      put("Speed", 12);
      put("Defense", 3);
      put("Magic", 0);
      put("Resistance", 2);
    }}, new ArrayList<String>(Arrays.asList("Sword")));
    Weapon sword = new Sword("Iron Sword");
    give(sword);
    equip(sword);
  }

}
