public class PureWater extends Consumable {
  public PureWater() {
    super("Pure Water", 1);
  }
  public boolean use(Character character) {
    character.applyCondition("Pure Water");
    return consume();
  }
}
