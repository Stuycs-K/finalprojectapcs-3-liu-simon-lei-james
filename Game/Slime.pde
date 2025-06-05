public class Slime extends Enemy {
  public Slime(Tile startingPosition) {
    super(10, 5, startingPosition, "Slime", new HashMap<String, Integer>() {{
      put("Strength", 5);
      put("Speed", 3);
      put("Defense", 5);
      put("Magic", 0);
      put("Resistance", 6);
    }}, false);
  }
  public void attack(Character target) {
    int damage = getStat("Strength") - target.getStat("Defense");
    if (damage <= 0){
      damage = 0;
    }
    target.damage(damage);
    if (RANDOM.nextInt(100) <= 5){
      target.applyCondition("Poison");
    }
  }
}
