abstract class Character extends Entity {
  private String name;
  private Resource health;
  private Resource movement;
  protected Resource actions;
  private Tile position;
  private PImage img;
  private ArrayList<Condition> conditions;

  public Character(String name, int maxHealth, int maxMovement, Tile startingPosition, String type) {
    super(type);
    this.name = name;
    img = loadImage(getName() + ".png");
    position = startingPosition;
    movement = new Resource(maxMovement, "Movement");
    health = new Resource(maxHealth, "Health");
    actions = new Resource(3, "Actions");
    conditions = new ArrayList<Condition>();
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

  public Resource getMovement() {
    return movement;
  }
  public Tile getPosition() {
    return position;
  }
  public boolean damage(int ouch){
    return health.consume(ouch);
  }
  protected boolean consumeActions(int amount) {
    return actions.consume(amount);
  }
  public void endTurn() {
    movement.restore();
    actions.restore();
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
    return board.tilesInRange(getPosition(), movement.getCurrent().getFirst());
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
    for (Condition condition: conditions){
      if (condition.getName() == name){
        //check name of condition and then decide what to do based on condition
        reduceCondition(name, 1);
        return condition.getDuration();
      }
    }
    return -1;
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
