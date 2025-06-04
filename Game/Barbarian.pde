public class Barbarian extends Player{
  public Barbarian(Tile startingPosition) {
    super(30, 5, startingPosition, "Barbarian", new HashMap<String, Integer>() {{
      put("Strength", 10);
      put("Speed", 3);
      put("Defense", 4);
      put("Magic", 0);
      put("Resistance", 1);
    }}, new ArrayList<String>(Arrays.asList("Axe")));

    //Default Equipment
    Weapon axe = new Axe("Iron Axe");
    give(axe);
    equip(axe);
  }

}
