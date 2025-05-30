public class Item {
  String name;
  String type;
  public Item(String name, String type) {
    this.name = name;
    this.type = type;
  }
  public String getType() {
    return type;
  }
  public String toString() {
    return name;
  }
}
