public class Mage extends Player{

  public Mage(Tile startingPosition) {
    super(5, 4, startingPosition, "Mage", new HashMap<String, Integer>() {{
      put("Strength", 0);
      put("Speed", 6);
      put("Defense", 2);
      put("Magic", 8);
      put("Resistance", 5);
    }}, new ArrayList<String>(Arrays.asList("Tome")));
    Weapon tome = new Tome(10, 12, 20, "Blizzard");
    give(tome);
    equip(tome);
  }

}
