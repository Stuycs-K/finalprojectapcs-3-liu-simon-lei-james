abstract class Character extends Entity {
  private String name;
  private Resource health;
  private Tile position;
  private Resource movement;
  protected Resource actions;
  public Character(String name, int maxHealth, int maxMovement, Tile startingPosition, String type) {
    super(type);
    this.name = name;
    position = startingPosition;
    movement = new Resource(maxMovement, "Movement");
    health = new Resource(maxHealth, "Health");
    actions = new Resource(3, "Actions");
  }
  public String getName() {
    return name;
  }
  public String getHealth() {
    return health.toString();
  }
  public String getActions() {
    return actions.toString();
  }
  public Resource getMovement() {
    return movement.copy();
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
    if (!movement.consume(position.distanceTo(newPosition))) return false;

    LinkedList<Tile> path = position.pathTo(newPosition);
    if (newPosition.hasEntity()) path.removeLast();
    if (path.size() > 0) {
      position.removeEntity();
      path.peekLast().addEntity(this);
    }

    Thread newThread = new Thread(() -> {
      while (!path.isEmpty()) {
        int start = TICK;
        while (TICK == start) sleep(100);
        Tile tile = path.pop();
        tile.display();
        position.removeEntity();
        updateQueue.add(position);
        position = tile;
        position.addEntity(this);
        updateQueue.add(position);
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
    PImage img = loadImage(getName() + ".png");
    image(img, Tile.WIDTH * coordinate.getX(), Tile.HEIGHT * coordinate.getY(), Tile.HEIGHT, Tile.WIDTH);
  }
}
