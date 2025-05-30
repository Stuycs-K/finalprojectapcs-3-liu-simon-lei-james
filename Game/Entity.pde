import java.util.Arrays;

abstract public class Entity {
  abstract public void display();
  private String type;
  protected Tile position;
  public Entity(Tile startingPosition) {
    if (this instanceof Player) {
      this.type = "Player";
    } else if (this instanceof Enemy) {
      this.type = "Enemy";
    } else {
      this.type = "Chest";
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
