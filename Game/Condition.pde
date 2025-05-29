public class Condition{
  private String name;
  private int duration;

  public Condition(String name, int duration){
    this.name = name;
    this.duration = duration;
  }


  public String getName(){
    return name;
  }
  public int getDuration(){
    return duration;
  }

  public boolean reduceDuration(int time){
    if (duration <= 0){
      return false;
    }
    duration-= time;
    return true;
  }

  public void increaseDuration(int time){ //when would increasing duration be used?
    duration+= time;
  }
}
