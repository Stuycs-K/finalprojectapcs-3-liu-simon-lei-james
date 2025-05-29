public class HealthPotion extends Consumable {
  public HealthPotion() {
    super("Health Potion");
  }
  public boolean use(Character character) {
    character.getHealth().restore(10);
    consume(1);
    return empty();
  }
}
