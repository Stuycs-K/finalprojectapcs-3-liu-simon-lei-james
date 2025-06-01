public class Bow extends Weapon{
  //intended types for now: Iron: 40 durability, 5 power; Silver: 20 durability, 8 power; Sleep: 20 durability, 3 power, can put people to sleep
  public Bow(int durability, int power, int weight, String material){
    super(durability, power, weight, 2, material, "Bow");
  }
  
  public void attack(Character wielder, Character target){
    super.attack(wielder, target);
    if (wielder.getStat("Speed") >= target.getStat("Speed")){
      super.attack(wielder, target);
    }
    if (getMaterial().equals("Sleep")){
      target.applyCondition("Sleeping");
    }
    if (RANDOM.nextInt(100) <= 10){
      target.applyCondition("Bleeding");
    }
  }
}
