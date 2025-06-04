public class Soldier extends EnemyH {
  public Soldier(Tile startingPosition) {
    super(22, 5, startingPosition, "Soldier", new HashMap<String, Integer>() {{
      put("Strength", 3);
      put("Speed", 2);
      put("Defense", 8);
      put("Magic", 0);
      put("Resistance", 2);
    }}, new ArrayList<String>(Arrays.asList("Lance")));
    
    Weapon lance = new Lance("Javelin Lance");
    equip(lance);
  }
}
