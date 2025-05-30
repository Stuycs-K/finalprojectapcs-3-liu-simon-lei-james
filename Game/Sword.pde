import java.util.Random;
public class Sword extends Weapon{
  private String type; //intended types for now: Iron: 40 durability, 5 power; Silver: 20 durability, 10 power; Brave: 30 durability, 7 power, special ability to attack twice

  public Sword(int durability, int power, String type){
    super(durability, power, type);
    this.type = type;
  }
  
  public boolean calculateCondition(Character wielder){ //wielder called to see class. If the character is a rogue, then increased chance to inflict any status effect
    Random rand = new Random();
    if (wielder.getCharacterClass().equals("Rogue")){
      return rand.nextInt(100) <= 20;
    }
    return rand.nextInt(100) <= 10;
  }
  
  public void attack(Character wielder, Character target){
    super.attack(wielder, target);
    if (type.equals("Brave")){ //Brave weapons attack twice consecutively independently from doubling based on speed.
      super.attack(wielder, target);
    }
    if (wielder.getStat("Speed") >= target.getStat("Speed")){
      super.attack(wielder, target);
      if (type.equals("Brave")){
        super.attack(wielder, target);
      }
    }
    if (calculateCondition(wielder)){
      target.applyCondition("Bleeding");
    }
  }
}
