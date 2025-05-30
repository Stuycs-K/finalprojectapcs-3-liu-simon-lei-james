abstract class Character extends Entity {
  private String name;
  private String characterClass;

  private Resource health;
  private Resource movement;

  private HashMap<String, Integer> currentStats, defaultStats;

  private ArrayList<Condition> conditions;

  public Character(int maxHealth, int maxMovement, Tile startingPosition, String characterClass, HashMap<String, Integer> stats) {
    super(startingPosition, characterClass);
    
    this.name = "John";
    this.characterClass = characterClass;
    
    this.currentStats = stats;
    this.defaultStats = stats;

    movement = new Resource(maxMovement, "Movement");
    health = new Resource(maxHealth, "Health");

    position = startingPosition;

    conditions = new ArrayList<Condition>();
  }

  public String getName() {
    return name;
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

  public void damage(int ouch){
    if (!health.consume(ouch) || health.getCurrent() == 0) {
      sleep(10);
      actionBar.reset();
      if (this instanceof Player) {
        players.remove((Player) this);
        position.removeEntity();
        if (players.size() == 0) {
          actionBar.write("You Lost!");
          board.reset();
          noLoop();
        }
      } else {
        enemies.remove((Enemy) this);
        position.removeEntity();
        if (enemies.size() == 0) {
          actionBar.write("You Lost!");
          board.reset();
          noLoop();
        }
      }
      position.transform("None");
    }
  }
  
  abstract void attack(Character target);

  public void endTurn() {
    if (!hasCondition("Sleeping")) {
      movement.restore();
    }
    if (hasCondition("Poison")) {
      damage(health.getMax() / 8);
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
        int start = TICK;
        while (TICK == start) sleep(1);
        position.removeEntity();
        Tile tile = path.pop();
        position = tile;
        position.addEntity(this);
      }
      if (copy) {
        if (newPosition.getEntity() instanceof Character) {
          attack((Character) newPosition.getEntity());
          newPosition.transform("Red");
          int start = TICK;
          while (TICK == start) sleep(1);
          newPosition.transform("None");
        }
      }
    });
    newThread.start();
    return true;
  }

  public ArrayList<Tile> movementRange() {
    return board.tilesInRange(getPosition(), movement.getCurrent());
  }

  public Condition getCondition(String name) {
    for (Condition condition : conditions){
      if (condition.toString().equals(name)){
        return condition;
      }
    }
    return null;
  }

  public String getConditions() {
    String all = "Conditions: ";
    for (Condition condition : conditions){
      all += condition + ": " + condition.getDuration();
    }
    return all;
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
      conditions.add(new Condition(name, 3));
    }
    switch (name) {
      case "Bleeding":
      currentStats.replace("Defense", defaultStats.get("Defense") / 2);
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
