public class Condition {
  private String name;
  private Resource duration;

  public Condition(String name, int duration){
    this.name = name;
    this.duration = new Resource(duration, "Duration");
  }


  public String getName(){
    return name;
  }
  public Resource getDuration(){
    return duration;
  }

  public boolean reduceDuration(int time){
    return duration.consume(time);
  }

}
