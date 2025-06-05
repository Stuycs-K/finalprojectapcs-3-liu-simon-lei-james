abstract class Consumable extends Item {
  protected int uses;

  public Consumable(String name, int uses) {
    super(name, "Consumable");
    this.uses = uses;
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

public class Vulnerary extends Consumable {
  public Vulnerary() {
    super("Vulnerary", 3);
  }
  public boolean use(Character character) {
    character.getHealth().restore(10);
    return consume();
  }
}

public class PureWater extends Consumable {
  public PureWater() {
    super("Pure Water", 1);
  }
  public boolean use(Character character) {
    character.applyCondition("Pure Water");
    return consume();
  }
}
