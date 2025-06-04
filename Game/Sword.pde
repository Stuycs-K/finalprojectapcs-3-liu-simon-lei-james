public class Sword extends Weapon {
  // Iron: 40 durability, 5 power; Silver: 20 durability, 10 power; Brave: 30 durability, 7 power, special ability to attack twice

  public Sword(String weaponType){
    super(new HashMap<String, ArrayList<Integer>>() {{
      put("Iron Sword", new ArrayList(Arrays.asList(40, 5, 1, 1)));
      put("Silver Sword", new ArrayList(Arrays.asList(20, 8, 3, 1)));
      put("Brave Sword", new ArrayList(Arrays.asList(30, 7, 5, 1)));
    }}
    , weaponType);
  }


  public boolean calculateCondition(Character wielder){ //wielder called to see class. If the character is a rogue, then increased chance to inflict any status effect
    if (wielder.getCharacterClass().equals("Thief")){
      return RANDOM.nextInt(100) <= 20;
    }
    return RANDOM.nextInt(100) <= 10;
  }

  public void attack(Character wielder, Character target){
    super.attack(wielder, target);
    if (getMaterial().equals("Brave")){ //Brave weapons attack twice consecutively independently from doubling based on speed.
      super.attack(wielder, target);
    }
    if (calculateCondition(wielder)){
      target.applyCondition("Bleeding");
    }
  }
}
