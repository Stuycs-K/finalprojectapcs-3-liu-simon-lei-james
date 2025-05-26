abstract public class Entity {
  abstract public void display();
  private String type;
  public Entity(String type) {
    this.type = type;
  }
  public String getType() {
    return type;
  }
}
