abstract class Character extends Entity {
  private String name;
  private String characterClass;
  private boolean human;

  private Resource health;
  private Resource movement;

  private HashMap<String, Integer> currentStats, defaultStats;

  private ArrayList<Condition> conditions;
  private ArrayList<String> weaponProficiencies;
  protected Weapon weapon;

  public Character(int maxHealth, int maxMovement, Tile startingPosition, String characterClass, HashMap<String, Integer> stats, ArrayList<String> weaponProficiencies, Weapon weapon, boolean isHuman) {
    super(startingPosition, characterClass);

    this.name = "John";
    this.characterClass = characterClass;
    human = isHuman;

    this.currentStats = stats;
    this.defaultStats = stats;

    movement = new Resource(maxMovement, "Movement");
    health = new Resource(maxHealth, "Health");

    position = startingPosition;

    conditions = new ArrayList<Condition>();
    if (isHuman()){
      this.weaponProficiencies = weaponProficiencies;
      this.weapon = weapon;
      equip(weapon);
    }
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
  
  public boolean isHuman(){
    return human;
  }

  public void damage(int ouch){
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
  
  abstract void attack(Character target);

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
    });
    newThread.start();
    return true;
  }

  public ArrayList<Tile> movementRange() {
    return getPosition().tilesInRange(movement.getCurrent());
  }

  public Condition getCondition(String name) {
    for (Condition condition : conditions){
      if (condition.toString().equals(name)){
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
    for (Condition condition: conditions){
      if (condition.toString().equals(name)){
        return true;
      }
    }
    return false;
  }
}
