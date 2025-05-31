public class Axe extends Weapon{
  private String type; //intended types for now: Iron: 40 durability, 8 power; Silver: 20 durability, 16 power; Killer: 20 durability, 9 power, can crit

  public Axe(int durability, int power, int weight, String type){
    super(durability, power, weight, 1, type, "Axe");
    this.type = type;
  }

  public String getType(){
    return type;
  }
  public String toString(){
    return getType() + " Axe";
  }
  /* axes are the heaviest hitting weapon in the standard Fire Emblem weapon triangle (sword-lance-axe). However, they are also by far the least accurate, along with the heaviest. May make axes
  specifically unable to double, but have a higher chance to inflict bleed. */

  public void attack(Character wielder, Character target){
    if (getType().equals("Killer")){
      if (RANDOM.nextInt(100) <= 30){
        critical(wielder, target);
      }
      else{
        super.attack(wielder, target);
      }
    }
    else{
      super.attack(wielder, target);
    }
    if (RANDOM.nextInt(100) <= 15){
      target.applyCondition("Bleeding");
    }
  }
}
