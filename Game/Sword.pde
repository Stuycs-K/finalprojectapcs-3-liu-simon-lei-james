public class Sword extends Weapon{
  private String type;
  
  public Sword(String type){
    this.type = type;
    if (type.equals("iron")){
      super(40, 5, "iron sword");
    }
    if (type.equals("silver")){
      super(20, 10, "silver sword");
    }
    if (type.equals("brave")){ //attacks twice consecutively, independent from standard doubling (means potentially attack 4 times in one turn)
      super (30, 7, "brave sword");
    }
    //more swords implemented
  }
