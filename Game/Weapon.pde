abstract class Weapon extends Item{

  private int durability;
  private int power;
  private String name;

  public Weapon(int durability, int power, String name){
    super(name, "Weapon");
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
    durability -= tear;
    return durability <= 0;
  }

  public void attack(Character wielder, Character target){ //character is a parameter to call its strength stat
    int damage = wielder.getStat("Strength") + power - target.getStat("Defense");
    target.damage(damage);
    reduceDurability(1);
  }
}
