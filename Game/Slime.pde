public class Slime extends Enemy {
  public Slime(Tile startingPosition) {
    super(10, 5, startingPosition, "Slime", new HashMap<String, Integer>() {{
      put("Strength", 7);
      put("Speed", 9);
      put("Defense", 5);
    }});
  }
  public void attack(Character target) {
    target.damage(2);
  }
}
