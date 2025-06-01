public class Tome extends Weapon{
  /* types for tomes will be different kinds of spells. I will likely be implementing more conditions to go with these spells
    Fireball: 40 durability, 3 power, low weight, chance to burn and/or increased chance to crit
    Thunder: 30 durability, 5 power, medium weight, paralyze and/or brave effect similar to Brave Sword. I am hesitant to give it the brave effect, because magic inherently does
    more damage than physical attacks thanks to every class besides Mage generally having less resistance than defense. Increased range could be an alternative.
    Blizzard: 10 durability, 12 power, very high weight, chance to put enemies to sleep (frozen would be more accurate but the implementation would likely be the same, and there
    are instances in Fire Emblem where ice magic puts enemies to sleep */
  public Tome(int durability, int power, int weight, String material){
    super(durability, power, weight, 2, material, "Tome");
    this.type = type;
  }
  
  public void attack(Character wielder, Character target){
    if (getMaterial().equals("Fireball")){
      if (RANDOM.nextInt() <= 12){
        super.critical(wielder, target);
      }
      else{
        super.attack(wielder, target);
      }
    }
    super.attack(wielder, target);
    if (getType().equals("Thunder")){
      super.attack(wielder, target);
    }
    if (getType().equals("Blizzard")){
      target.applyCondition("Sleeping");
    }
  }
}
