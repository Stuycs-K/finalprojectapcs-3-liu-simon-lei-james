public class Weapon extends Item{

  private int durability;
  private int power;
  private String name;

  public Weapon(int durability, int power, String name){
    super(name, "weapon");
    this.durability = durability;
    this.power = power;
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

  public int mainAttack(Character other){ //character is a parameter to call its strength stat
    int damage = getPower();
    return damage;
  }
}
