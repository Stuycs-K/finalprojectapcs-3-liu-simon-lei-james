abstract class Humanoid extends Enemy {
  private Weapon weapon;
  
  public Humanoid(int maxHealth, int maxMovement, Tile startingPosition, String characterClass, HashMap<String, Integer> stats, ArrayList<String> weaponProficiencies, Weapon weapon) {
    super(maxHealth, maxMovement, startingPosition, characterClass, stats, weaponProficiencies, weapon, true);
    this.weapon = weapon;
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
    super((RANDOM.nextInt(3) - 1) + 16, 5, startingPosition, "Soldier", new HashMap<String, Integer>() {{
      put("Strength", (RANDOM.nextInt(5) - 2) + 5);
      put("Skill", 4);
      put("Speed", 4);
      put("Defense", 8);
      put("Magic", 0);
      put("Resistance", 2);
    }}, new ArrayList<String>(Arrays.asList("Lance")), new Lance("Javelin"));
  }
}

public class Bully extends Humanoid {
  public Bully(Tile startingPosition) {
    super((RANDOM.nextInt(5) - 1) + 18, 5, startingPosition, "Bully", new HashMap<String, Integer>() {{
      put("Strength", (RANDOM.nextInt(5) - 1) + 7);
      put("Skill", 2);
      put("Speed", 2);
      put("Defense", 6);
      put("Magic", 0);
      put("Resistance", 2);
    }}, new ArrayList<String>(Arrays.asList("Axe")), new Axe("Iron"));
  }
}

public class Mercenary extends Humanoid {
  public Mercenary(Tile startingPosition) {
    super(14, 5, startingPosition, "Mercenary", new HashMap<String, Integer>() {{
      put("Strength", 3);
      put("Skill", (RANDOM.nextInt(5) - 1) + 6);
      put("Speed", (RANDOM.nextInt(5) - 1) + 6);
      put("Defense", 4);
      put("Magic", 0);
      put("Resistance", 2);
    }}, new ArrayList<String>(Arrays.asList("Lance")), new Lance("Javelin"));
  }
}
