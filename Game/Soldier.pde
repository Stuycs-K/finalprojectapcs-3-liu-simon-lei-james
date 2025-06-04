public class Soldier extends HumanEnemy {
  public Soldier(Tile startingPosition) {
    super(14, 5, startingPosition, "Slime", new HashMap<String, Integer>() {{
      put("Strength", 3);
      put("Speed", 2);
      put("Defense", 8);
      put("Magic", 0);
      put("Resistance", 2);
    }}, new ArrayList<String>(Arrays.asList("Lance")));
  }
  
  public void attack(Character target) { //uses lances
    
  }
}
