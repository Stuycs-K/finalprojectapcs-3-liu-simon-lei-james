public class Bow extends Weapon{
  //intended types for now: Iron: 40 durability, 5 power; Silver: 20 durability, 8 power; Sleep: 20 durability, 3 power, can put people to sleep
  public Bow(String weaponType){
    super(new HashMap<String, ArrayList<Integer>>() {{
      put("Iron Bow", new ArrayList(Arrays.asList(40, 5, 1, 2)));
      put("Silver Bow", new ArrayList(Arrays.asList(20, 8, 3, 2)));
      put("Sleep Bow", new ArrayList(Arrays.asList(20, 3, 5, 3)));
    }}
    , weaponType);
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
