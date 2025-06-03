import java.util.Arrays;
public class Axe extends Weapon{
  // Iron: 40 durability, 8 power; Silver: 20 durability, 16 power; Killer: 20 durability, 9 power, can crit
  public Axe(int durability, int power, int weight, String material){
    super(durability, power, weight, 1, material, "Axe");
  }
  
  public Axe(String weaponType){
    super(new HashMap<String, ArrayList<Integer>>() {{
      put("Iron Axe", new ArrayList(Arrays.asList(40, 8, 5, 1)));
      put("Silver Axe", new ArrayList(Arrays.asList(20, 16, 10, 1)));
      put("Killer Axe", new ArrayList(Arrays.asList(20, 9, 6, 1)));
    }}
    , weaponType);
  }
  /* axes are the heaviest hitting weapon in the standard Fire Emblem weapon triangle (sword-lance-axe). However, they are also by far the least accurate, along with the heaviest. May make axes
  specifically unable to double, but have a higher chance to inflict bleed. */

  public void attack(Character wielder, Character target){
    if (getMaterial().equals("Killer")) {
      if (RANDOM.nextInt(100) <= 30){
        critical(wielder, target);
      }
      else {
        super.attack(wielder, target);
      }
    }
    else {
      super.attack(wielder, target);
    }
    if (RANDOM.nextInt(100) <= 15){
      target.applyCondition("Bleeding");
    }
  }
}
