abstract class Character extends Entity {
  private String name, role;
  private Resource health;
  private Resource movement;
  protected Resource actions;
  private Tile position;
  private PImage img;
  private ArrayList<Condition> conditions;
  
  private int strength, speed, defense; //only way to change after initialized is through status conditions.

  public Character(String name, int maxHealth, int maxMovement, Tile startingPosition, String type) {
    super(type);
    this.name = name;
    img = loadImage(getName() + ".png");
    position = startingPosition;
    movement = new Resource(maxMovement, "Movement");
    health = new Resource(maxHealth, "Health");
    actions = new Resource(3, "Actions");
    conditions = new ArrayList<Condition>();
    role = type;
    if (role.equals("lord")){
      strength = 7;
      speed = 5;
      defense = 5;
    }
  }

  public String getName() {
    return name;
  }
  public Resource getHealth() {
    return health;
  }
  public Resource getActions() {
    return actions;
  }
  public int getStrength(){
    return strength;
  }
  public int getSpeed(){
    return speed;
  }
  public int getDefense(){
    return defense;
  }

  public Resource getMovement() {
    return movement;
  }
  public Tile getPosition() {
    return position;
  }
  
  
  public void damage(int ouch){
    if (!health.consume(ouch) || health.getCurrent() == 0) {
      actionBar.reset();
      if (getType().equals("Player")) {
        players.remove(board.getPlayer(position));
        position.removeEntity();
        if (players.size() == 0) {
          actionBar.write("You Lost!");
          board.reset();
          noLoop();
        }
      } else {
        enemies.remove(board.getEnemy(position));
        position.removeEntity();
        if (enemies.size() == 0) {
          actionBar.write("You won!");
          board.reset();
          noLoop();
        }
      }
      position.transform("None");
    }
  }
  protected boolean consumeActions(int amount) {
    return actions.consume(amount);
  }
  public void endTurn() {
    if (!hasCondition("sleeping")){
      movement.restore();
      actions.restore();
    }
  }

  public boolean moveTo(Tile newPosition) {
    int distance = position.distanceTo(newPosition);
    if (distance == -1) return false;
    if (!movement.consume(distance)) return false;

    LinkedList<Tile> path = position.pathTo(newPosition);
    if (newPosition.hasEntity()) path.removeLast();
    if (path.size() > 0) {
      position.removeEntity();
      path.peekLast().addEntity(this);
    }

    Thread newThread = new Thread(() -> {
      while (!path.isEmpty()) {
        int start = TICK;
        while (TICK == start) sleep(1);
        position.removeEntity();
        Tile tile = path.pop();
        position = tile;
        position.addEntity(this);
      }
    });
    newThread.start();
    return true;
  }

  public ArrayList<Tile> movementRange() {
    return board.tilesInRange(getPosition(), movement.getCurrent());
  }

  public void display() {
    Coordinate coordinate = getPosition().getCoordinate();
    image(img, Tile.WIDTH * coordinate.getX(), Tile.HEIGHT * coordinate.getY(), Tile.HEIGHT, Tile.WIDTH);
  }

  public String getConditions(){
    String all = "conditions: ";
    for (Condition condition: conditions){
      all+= condition.getName() + ", ";
    }
    return all;
  }
  public int applyCondition(String name){
    if (!hasCondition(name)){
      conditions.add(new Condition(name, 3));
    }
    switch (name) {
      case "Poison":
      damage(health.getMax() / 8);
      break;
      case "Bleeding":
      defense /= 2;
      break;
      case "Sleeping":
      actions.consume(3);
      break;
    }
      
    reduceCondition(name, 1);
    return conditions.get(getCondition(name)).getDuration();
  }
  public void reduceCondition(String name, int reduce){
    conditions.get(getCondition(name)).reduceDuration(reduce);
  }
  public boolean hasCondition(String name){
    for (Condition condition: conditions){
      if (condition.getName().equals(name)){
        return true;
      }
    }
    return false;
  }
  public int getCondition(String name){
    if (hasCondition(name)){
      for (Condition condition: conditions){
        if (condition.getName().equals(name)){
          return conditions.indexOf(condition);
        }
      }
    }
    return -1;
  }
}
