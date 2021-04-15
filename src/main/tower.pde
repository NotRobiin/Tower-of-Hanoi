class Tower
{
  int w;
  int h;
  PVector base_pos = new PVector(0, 0);
  ArrayList<Pole> poles = new ArrayList<Pole>();

  Tower()
  {
    w = (int) (width * TowerWidthMult);
    h = (int) (height * TowerHeightMult);

    base_pos.x = width / 2 - (w / 2);
    base_pos.y = height * 0.65;

    poles.add(new Pole(this, PoleSpot.left));
    poles.add(new Pole(this, PoleSpot.middle));
    poles.add(new Pole(this, PoleSpot.right));
  }

  void draw()
  {
    // Base
    fill(TowerColor);
    rect(base_pos.x, base_pos.y, w, h, TowerCurve);

    // Poles
    for (Pole p : poles)
    {
      p.draw();
    }
  }

  color get_color()
  {
    return TowerColor;
  }

  int get_width()
  {
    return w;
  }

  int get_height()
  {
    return h;
  }
}
