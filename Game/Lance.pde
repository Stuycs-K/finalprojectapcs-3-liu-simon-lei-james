public class Lance extends Weapon {
  public Lance(String weaponType){
    super(new HashMap<String, ArrayList<Integer>>() {{
      put("Iron Lance", new ArrayList(Arrays.asList(40, 7, 1, 1)));
      put("Silver Lance", new ArrayList(Arrays.asList(20, 14, 3, 1)));
      put("Javelin Lance", new ArrayList(Arrays.asList(20, 5, 5, 2)));
    }}
    , weaponType);
  }
  
  public void attack(Character wielder, Character target){
    super.attack(wielder, target);
  }
}
