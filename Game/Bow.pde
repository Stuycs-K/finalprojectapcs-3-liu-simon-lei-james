import java.util.Random;
public class Bow extends Weapon{
  private String type; //intended types for now: Iron: 40 durability, 5 power; Silver: 20 durability, 8 power; Sleep: 20 durability, 3 power, can put people to sleep

  public Bow(int durability, int power, String type){
    super(durability, power, type);
    this.type = type;
  }

  public void attack(Character wielder, Character target){
    Random rand = new Random();
    super.attack(wielder, target);
    if (wielder.getStat("Speed") >= target.getStat("Speed")){
      super.attack(wielder, target);
    }
    if (type.equals("Sleep")){
      target.applyCondition("Sleeping");
    }
    if (rand.nextInt(100) <= 10){
      target.applyCondition("Bleeding");
    }
  }
}
