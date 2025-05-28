abstract class Character extends Entity {
  private String name;
  private Resource health;
  private Resource movement;
  protected Resource actions;
  private Tile position;
  private PImage img;
  
  public Character(String name, int maxHealth, int maxMovement, Tile startingPosition, String type) {
    super(type);
    this.name = name;
    img = loadImage(getName() + ".png");
    position = startingPosition;
    movement = new Resource(maxMovement, "Movement");
    health = new Resource(maxHealth, "Health");
    actions = new Resource(3, "Actions");
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
}
