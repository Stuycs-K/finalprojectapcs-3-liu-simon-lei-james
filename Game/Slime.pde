public class Slime extends Enemy {
  public Slime(Tile startingPosition) {
    super(10, 5, startingPosition, "Slime", new HashMap<String, Integer>() {{
      put("Strength", 7);
      put("Speed", 0);
      put("Defense", 12);
      put("Magic", 0);
      put("Resistance", 12);
    }});
  }
  public void attack(Character target) {
    target.damage(2);
  }
}
