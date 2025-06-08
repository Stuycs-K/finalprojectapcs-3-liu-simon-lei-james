abstract class Enemy extends Character {
  public Enemy(int maxHealth, int maxMovement, Tile startingPosition, String enemyClass, HashMap<String, Integer> stats, ArrayList<String> weaponProficiencies) {
    super(maxHealth, maxMovement, startingPosition, enemyClass, stats, weaponProficiencies);
  }

  public void takeTurn() {
    if (!hasCondition("Sleeping")){
      int minDistance = -2;
      // Can sort list by closest player to avoid enemies freezing when there's no available path
      Player closestPlayer = null;
      for (int i = 0; i < players.size(); i++) {
        Player player = players.get(i);
        int distance = getPosition().distanceTo(player.getPosition());
        if (minDistance == -2 || minDistance > distance) {
          minDistance = distance;
          closestPlayer = player;
        }
      }
      if (closestPlayer == null) return;
  
      LinkedList<Tile> path = getPosition().pathTo(closestPlayer.getPosition());
      if (path == null) return;
  
      int index = -1;
      Resource movement = getMovement().copy();
      Tile current = null, next;
      while (!path.isEmpty()) {
        next = path.pop();
        if (!movement.consume(next.getMovementPenalty())) break; // No Movement
        current = next;
        index++;
      }
      if (index != -1) {
        moveTo(current);
      }
    }
  }
}

public class Slime extends Enemy {
  public Slime(Tile startingPosition) {
    super(10, 5, startingPosition, "Slime", new HashMap<String, Integer>() {{
      put("Strength", 5);
      put("Skill", 2);
      put("Speed", 3);
      put("Defense", 5);
      put("Magic", 0);
      put("Resistance", 6);
    }}, new ArrayList<String>());
  }
  
  @Override
  public void attack(Character target) {
    int damage = getStat("Strength") - target.getStat("Defense");
    damage = max(damage, 0);
    target.damage(damage);
    if (RANDOM.nextInt(100) <= 30 + CONDITION_CHANCE){
      target.applyCondition("Poisoned");
    }
  }
}

public class Soldier extends Enemy {
  public Soldier(Tile startingPosition) {
    super((RANDOM.nextInt(3) - 1) + 16, 5, startingPosition, "Soldier", new HashMap<String, Integer>() {{
      put("Strength", (RANDOM.nextInt(5) - 2) + 5);
      put("Skill", 4);
      put("Speed", 4);
      put("Defense", 8);
      put("Magic", 0);
      put("Resistance", 2);
    }}, new ArrayList<String>(Arrays.asList("Lance")));
    equip(new Lance("Javelin"));
  }
}

public class Bully extends Enemy {
  public Bully(Tile startingPosition) {
    super((RANDOM.nextInt(5) - 1) + 18, 5, startingPosition, "Bully", new HashMap<String, Integer>() {{
      put("Strength", (RANDOM.nextInt(5) - 1) + 7);
      put("Skill", 2);
      put("Speed", 2);
      put("Defense", 6);
      put("Magic", 0);
      put("Resistance", 2);
    }}, new ArrayList<String>(Arrays.asList("Axe")));
    equip(new Axe("Iron"));
  }
}

public class Mercenary extends Enemy {
  public Mercenary(Tile startingPosition) {
    super(14, 5, startingPosition, "Mercenary", new HashMap<String, Integer>() {{
      put("Strength", 3);
      put("Skill", (RANDOM.nextInt(5) - 1) + 6);
      put("Speed", (RANDOM.nextInt(5) - 1) + 6);
      put("Defense", 4);
      put("Magic", 0);
      put("Resistance", 2);
    }}, new ArrayList<String>(Arrays.asList("Sword")));
    equip(new Sword("Iron"));
  }
}
