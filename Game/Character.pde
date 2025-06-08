// CLEANED

abstract class Character extends Entity {
  private String name;
  private final ArrayList<String> POSSIBLE_NAMES = new ArrayList<String>(Arrays.asList("Arthur", "Bartre", "Cole", "Diarmuid", "Eirika", "Fergus", "Garcia", "Holyn", "Ilia", "Joshua",
                                                                                       "Kent", "Lewyn", "Mareeta", "Nanna", "Oswin", "Priscilla", "Borp", "Raven", "Seth", "Tibarn", "Urvan",
                                                                                       "Valbar", "Wolf", "Xavier", "Yune", "Zihark"));
  private String characterClass;

  private Resource health;
  private Resource movement;

  public boolean turn = false;

  private HashMap<String, Integer> currentStats, defaultStats;

  private ArrayList<Condition> conditions;
  private ArrayList<String> weaponProficiencies;
  protected Weapon weapon;

  public Character(int maxHealth, int maxMovement, Tile startingPosition, String characterClass, HashMap<String, Integer> stats, ArrayList<String> weaponProficiencies) {
    super(startingPosition, characterClass);

    this.name = POSSIBLE_NAMES.get(RANDOM.nextInt(POSSIBLE_NAMES.size()));
    this.characterClass = characterClass;

    this.currentStats = stats;
    this.defaultStats = stats;

    movement = new Resource(maxMovement, "Movement");
    health = new Resource(maxHealth, "Health");

    position = startingPosition;

    conditions = new ArrayList<Condition>();
    this.weaponProficiencies = weaponProficiencies;
  }

  public String toString() {
    return characterClass + " " + name;
  }
  public String getCharacterClass() {
    return characterClass;
  }
  public Resource getHealth() {
    return health;
  }
  public Resource getMovement() {
    return movement;
  }
  public int getStat(String stat) {
    return currentStats.get(stat);
  }

  // Weapons

  public boolean equip(Weapon weapon) {
    if (weaponProficiencies.contains(weapon.getWeaponType())) {
      this.weapon = weapon;
      return true;
    }
    return false;
  }

  public Weapon getWeapon() {
    return weapon;
  }
  
  public boolean hasWeapon() {
    return weapon != null;
  }

  // Damage

  public void damage(int ouch) {
    if (!health.consume(ouch) || health.getCurrent() == 0) {
      sleep(10);
      actionBar.write(toString() + " died!");
      if (this instanceof Lord) {
        endGame("Lost (Lord Died)");
      } else {
        if (this instanceof Player) {
          players.remove((Player) this);
          position.removeEntity();
        } else {
          enemies.remove((Enemy) this);
          position.removeEntity();
        }
        position.transform("None");
      }
    }
  }

  public void attack(Character target) {
    if (!turn) return;
    if (weapon == null) {
      target.damage(5);
    } else {
      weapon.attack(this, target);
    }
    turn = false;
  }
  
  public ArrayList<Tile> attackRange() {
    if (hasWeapon()) {
      return position.tilesInRadius(weapon.getStat("Range"));
    } else {
      return position.tilesInRadius(1);
    }
  }

  // Movement

  public boolean moveTo(Tile newPosition) {
    int distance = position.distanceTo(newPosition);
    if (distance == -1) return false;
    if (!movement.consume(distance)) return false;

    boolean action = false;

    LinkedList<Tile> path = position.pathTo(newPosition);
    if (newPosition.hasEntity()) {
      action = true;
      path.removeLast();
    }
    if (path.size() > 0) {
      position.removeEntity();
      path.peekLast().addEntity(this);
    }

    boolean copy = action;
    Thread newThread = new Thread(() -> {
      while (!path.isEmpty()) {
        int start = tick;
        while (tick == start) sleep(1);
        position.removeEntity();
        Tile tile = path.pop();
        position = tile;
        position.addEntity(this);
      }
      if (copy) {
        if (newPosition.getEntity() instanceof Character) {
          attack((Character) newPosition.getEntity());
          newPosition.transform("Red");
          int start = tick;
          while (tick == start) sleep(1);
          newPosition.transform("None");
        }
        if (newPosition.getEntity() instanceof Chest) {
          ((Chest) newPosition.getEntity()).collect((Player) this);
          newPosition.transform("Red");
          int start = tick;
          while (tick == start) sleep(1);
          newPosition.transform("None");
        }
      }
    }
    );
    newThread.start();
    return true;
  }

  public ArrayList<Tile> movementRange() {
    return getPosition().tilesInRange(movement.getCurrent());
  }
  
  // End Turn / Conditions

  public void endTurn() {
    if (!hasCondition("Sleeping")) {
      movement.restore();
    }
    if (hasCondition("Poisoned")) {
      damage(health.getMax() / 8);
    }
    if (hasCondition("Pure Water")) {
      currentStats.replace("Resistance", currentStats.get("Resistance") - 2);
    }
    for (int i = 0; i < conditions.size(); i++) {
      conditions.get(i).reduceDuration();
      if (conditions.get(i).getDuration() == 0) {
        removeCondition(conditions.get(i).toString());
        i--;
      }
    }
  }

  public Condition getCondition(String name) {
    for (Condition condition : conditions) {
      if (condition.toString().equals(name)) {
        return condition;
      }
    }
    return null;
  }

  public ArrayList<Condition> getConditions() {
    return conditions;
  }

  public void removeCondition(String name) {
    switch (name) {
    case "Bleeding":
      currentStats.replace("Defense", defaultStats.get("Defense"));
    }
    for (int i = 0; i < conditions.size(); i++) {
      if (conditions.get(i).toString().equals(name)) {
        conditions.remove(i);
        return;
      }
    }
  }

  public void applyCondition(String name) {
    if (hasCondition(name)) {
      getCondition(name).reset();
    } else {
      if (name.equals("Pure Water")) {
        conditions.add(new Condition(name, 4));
      } else {
        conditions.add(new Condition(name, 3));
      }
      actionBar.write(toString() + " is now " + name);
    }
    switch (name) {
      case "Bleeding":
        currentStats.replace("Defense", defaultStats.get("Defense") / 2);
      case "Pure Water":
        currentStats.replace("Resistance", defaultStats.get("Resistance") + 8);
        break;
    }
  }

  public boolean hasCondition(String name) {
    return getCondition(name) != null;
  }
}
