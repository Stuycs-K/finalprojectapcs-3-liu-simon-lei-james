public class Resource {
  private int current, max;
  private String name;
  public Resource(int max, String name) {
    this.max = max;
    this.name = name;
    current = max;
  }
  public String getName() {
    return name;
  }
  public int getCurrent() {
    return current;
  }
  public String toString() {
    return current + " / " + max;
  }
  public void restore() {
    current = max;
  }
  public void restore(int amount) {
    current = (current + amount) % max;
  }
  public boolean consume(int amount) {
    if (amount > current) return false;
    current -= amount;
    return true;
  }
}
