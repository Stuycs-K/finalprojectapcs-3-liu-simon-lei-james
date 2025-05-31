public class Sword extends Weapon {
  private String type; //intended types for now: Iron: 40 durability, 5 power; Silver: 20 durability, 10 power; Brave: 30 durability, 7 power, special ability to attack twice

  public Sword(int durability, int power, int weight, String type){
    super(durability, power, weight, 1, type, "Sword");
    this.type = type;
  }

  public String getType(){
    return type;
  }
  public String toString(){
    return getType() + " Sword";
  }

  public boolean calculateCondition(Character wielder){ //wielder called to see class. If the character is a rogue, then increased chance to inflict any status effect
    if (wielder.getCharacterClass().equals("Rogue")){
      return RANDOM.nextInt(100) <= 20;
    }
    return RANDOM.nextInt(100) <= 10;
  }

  public void attack(Character wielder, Character target){
    super.attack(wielder, target);
    if (getType().equals("Brave")){ //Brave weapons attack twice consecutively independently from doubling based on speed.
      super.attack(wielder, target);
    }
    if (calculateCondition(wielder)){
      target.applyCondition("Bleeding");
    }
  }
}
