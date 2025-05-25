abstract class Character extends Entity {
  private String name;
  private Resource health;
  private Tile position;
  private Resource movement;
  public Character(String name, int maxHealth, Tile startingPosition) {
    super("Character");
    this.name = name;
    position = startingPosition;
    health = new Resource(maxHealth);
  }
  public String getName() {
    return name;
  }
  public String getHealth() {
    return health.toString();
  }
  public Tile getPosition() {
    return position;
  }
  public boolean moveTo(Tile newPosition) {
    if (!consume(position.distanceTo(newPosition))) return false;
    position = newPosition;
    return true;
  }
}
