import java.util.Comparator;

public class Pair<F extends Comparable<F>, S> {
  private final F first;
  private final S second;

  public Pair(F first, S second) {
    this.first = first;
    this.second = second;
  }

  public F getFirst() {
    return first;
  }

  public S getSecond() {
    return second;
  }
  
  public Comparator<Pair<F, S>> getComparator() {
    return new Comparator<Pair<F, S>>() {
      public int compare(Pair<F, S> a, Pair<F, S> b) {
        return a.getFirst().compareTo(b.getFirst());
      }
    };
  }
}
