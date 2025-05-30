import java.util.Arrays;

abstract public class Entity {
  abstract public void display();
  private String type;
  protected Tile position;
  public Entity(String type, Tile startingPosition) {
    if (Arrays.asList(playerClasses).contains(type)) {
      this.type = "Player";
    } else if (Arrays.asList(enemyClasses).contains(type)) {
      this.type = "Enemy";
    } else {
      this.type = type;
    }
    position = startingPosition;
  }
  public Tile getPosition() {
    return position;
  }
  public String getType() {
    return type;
  }
}
