public class Weapon extends Item{

  private int durability;
  private int power;
  private String name;
  private Player wielder;

  public Weapon(int durability, int power, String name){
    super(name, "weapon");
    this.durability = durability;
    this.power = power;
  }
  
  public void setWielder(Player wielder){
    this.wielder = wielder;
  }

  public int getDurability(){
    return durability;
  }
  public int getPower(){
    return power;
  }
  public String toString(){
    return name;
  }

  public boolean reduceDurability(int tear){
    durability-= tear;
    return durability <= 0;
  }

  public void mainAttack(Character other){ //character is a parameter to call its strength stat
    int damage = getPower() + wielder.getStrength();
    other.damage(damage - other.getDefense());
    reduceDurability(1);
  }
}
