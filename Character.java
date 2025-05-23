import java.util.ArrayList;

abstract class Character extends Entity {
  private String name;
  private Resource health;
  private Tile position;
  private Resource movement;
  protected Resource actions;
  public Character(String name, int maxHealth, int maxMovement, Tile startingPosition) {
    super("Character");
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
  public String getMovement() {
    return movement.toString();
  }
  public Tile getPosition() {
    return position;
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
    position = newPosition;
    return true;
  }
}
