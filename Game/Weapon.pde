abstract class Weapon extends Item {
  private int durability;
  private int power;
  private int weight;
  private int maxRange;
  private String weaponType;

  public Weapon(int durability, int power, int weight, int maxRange, String name, String weaponType){
    super(name, "Weapon");
    this.durability = durability;
    this.power = power;
    this.weight = weight;
    this.maxRange = maxRange;
    this.weaponType = weaponType;
  }

  public int getDurability(){
    return durability;
  }
  public int getPower(){
    return power;
  }
  public int getWeight(){
    return weight;
  }
  public int getRange(){
    return maxRange;
  }
  public String weaponType(){
    return weaponType;
  }
  public String toString(){
    return name;
  }

  public boolean reduceDurability(int tear){
    durability -= tear;
    return durability <= 0;
  }
  public boolean canDouble(Character wielder, Character target){
    int heavy = getWeight() - wielder.getStat("Strength");
    if (heavy < 0){
      heavy = 0;
    }
    return (wielder.getStat("Speed") - heavy) >= (target.getStat("Speed") + 4);
  }

  public void attack(Character wielder, Character target){ //character is a parameter to call its strength stat
    int damage = wielder.getStat("Strength") + power - target.getStat("Defense");
    target.damage(damage);
    reduceDurability(1);
    if (canDouble(wielder, target)){
      target.damage(damage);
      reduceDurability(1);
    }
  }

  public void critical(Character wielder, Character target){
    int damage = (2 * (wielder.getStat("Strength") + power)) - target.getStat("Defense");
    target.damage(damage);
    reduceDurability(1);
  }
}
