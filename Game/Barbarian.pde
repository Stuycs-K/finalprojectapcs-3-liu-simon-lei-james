public class Barbarian extends Player{
  public Barbarian(Tile startingPosition) {
    super(18, 5, startingPosition, "Barbarian", new HashMap<String, Integer>() {{
      put("Strength", 10);
      put("Speed", 3);
      put("Defense", 6);
      put("Magic", 0);
      put("Resistance", 1);
    }}, new ArrayList<String>(Arrays.asList("Axe")));

    //Default Equipment
    Weapon axe = new Axe(40, 8, 5, "Iron");
    give(axe);
    equip(axe);
  }

}
