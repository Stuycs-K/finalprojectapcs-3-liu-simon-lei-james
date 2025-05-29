import java.util.Arrays;

abstract public class Entity {
  abstract public void display();
  private String type;
  public Entity(String type) {
    System.out.println(Arrays.asList(playerClasses));
    if (Arrays.asList(playerClasses).contains(type)) {
      this.type = "Player";
    } else if (Arrays.asList(enemyClasses).contains(type)) {
      this.type = "Enemy";
    } else {
      this.type = type;
    }
  }
  public String getType() {
    System.out.println("HERE" + type);
    return type;
  }
}
