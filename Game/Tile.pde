import java.util.ArrayList;
import java.util.Queue;
import java.util.LinkedList;

class Tile {
  private String terrain;
  private Coordinate coordinate;
  public void display() {
    
  }
  public Tile(String terrain, int x, int y) {
    this.terrain = terrain;
  }
  public String getTerrain() {
    return terrain;
  }
  public void setTerrain(String newTerrain) {
    terrain = newTerrain;
  }
}
