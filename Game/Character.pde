abstract class Character extends Entity {
  private String name;
  private Tile position;
  public Character(String name, Tile startingPosition) {
    super("Character");
    this.name = name;
    position = startingPosition;
  }
  public String getName() {
    return name;
  }
  public Tile getPosition() {
    return position;
  }
}
