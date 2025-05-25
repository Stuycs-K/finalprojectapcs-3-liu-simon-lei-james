abstract public class Entity {
  private String type;
  public Entity(String type) {
    this.type = type;
  }
  public String getType() {
    return type;
  }
  abstract void display();
}
