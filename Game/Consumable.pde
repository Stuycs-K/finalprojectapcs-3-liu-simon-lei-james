abstract class Consumable extends Item {
  protected Resource uses;
  public Consumable(String name) {
    super(name, "Consumable");
  }
  public String toString() {
    return name;
  }
  public void refill(int amount) {
    uses.restore(amount);
  }
  protected boolean consume(int amount) {
    return uses.consume(amount);
  }
  protected boolean empty() {
    return uses.getCurrent().getFirst() == 0;
  }
  public Resource getUses() {
    return uses.copy();
  }
  abstract boolean use(Character character); // Returns false when consumable runs out
}
