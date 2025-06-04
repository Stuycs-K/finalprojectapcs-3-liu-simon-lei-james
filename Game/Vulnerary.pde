public class Vulnerary extends Consumable {
  public Vulnerary() {
    super("Vulnerary", 3);
  }
  public boolean use(Character character) {
    character.getHealth().restore(10);
    return consume();
  }
}
