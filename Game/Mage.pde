public class Mage extends Player{
  
  public Mage(Tile startingPosition) {
    super(5, 4, startingPosition, "Mage", new HashMap<String, Integer>() {{
      put("Strength", 0);
      put("Speed", 6);
      put("Defense", 2);
      put("Magic", 8);
      put("Resistance", 5);
    }}, new ArrayList<String>(Arrays.asList("Tome")));
    Weapon tome = new Tome(40, 3, 1, "Fireball");
    give(tome);
    equip(tome);
  }
  
}
