class Tower
{
  int w;
  int h;
  PVector base_pos = new PVector(0, 0);
  ArrayList<Pole> poles = new ArrayList<Pole>();

  Tower()
  {
    this.w = (int) (width * TowerWidthMult);
    this.h = (int) (height * TowerHeightMult);

    this.base_pos.x = width / 2 - (this.w / 2);
    this.base_pos.y = height * 0.65;

    this.poles.add(new Pole(this, PoleSpot.left));
    this.poles.add(new Pole(this, PoleSpot.middle));
    this.poles.add(new Pole(this, PoleSpot.right));
  }

  void draw()
  {
    // Base
    fill(TowerColor);
    rect(this.base_pos.x, this.base_pos.y, this.w, this.h, TowerCurve);

    // Poles
    for (Pole p : this.poles)
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
    return this.w;
  }

  int get_height()
  {
    return this.h;
  }
}
