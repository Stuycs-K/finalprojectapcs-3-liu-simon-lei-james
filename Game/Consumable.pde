abstract class Consumable extends Item {
  protected int uses;

  public Consumable(String name) {
    super(name, "Consumable");
    uses = 3;
  }

  public void refill(int amount) {
    uses += amount;
  }
  protected boolean consume() {
    uses -= 1;
    return uses == 0;
  }

  public int getUses() {
    return uses;
  }

  abstract boolean use(Character character); // Returns false when consumable runs out
}
