abstract class Humanoid extends Enemy {
  private ArrayList<String> weaponProficiencies;
  private Weapon weapon;

  public Humanoid(int maxHealth, int maxMovement, Tile startingPosition, String characterClass, HashMap<String, Integer> stats, ArrayList<String> weaponProficiencies) {
    super(maxHealth, maxMovement, startingPosition, characterClass, stats, true);
    this.weaponProficiencies = weaponProficiencies;
  }

  public void attack(Character other) {
    if (weapon == null){
      other.damage(5);
    }
    else {
      weapon.attack(this, other);
    }
  }

  public ArrayList<Tile> attackRange() {
    return getPosition().tilesInRadius(weapon.getStat("Range"));
  }
}

public class Soldier extends Humanoid {
  public Soldier(Tile startingPosition) {
    super(14, 5, startingPosition, "Soldier", new HashMap<String, Integer>() {{
      put("Strength", 3);
      put("Speed", 2);
      put("Defense", 8);
      put("Magic", 0);
      put("Resistance", 2);
    }}, new ArrayList<String>(Arrays.asList("Lance")));
  }
  Weapon lance = new Lance("Javelin");
}
