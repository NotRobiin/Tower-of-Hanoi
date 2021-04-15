enum PoleSpot
{
  left, 
    middle, 
    right
}

class Pole
{
  PVector pos = new PVector(0, 0);
  int w;
  int h;
  int offset;
  PoleSpot spot;
  ArrayList<Disc> discs = new ArrayList<Disc>();
  Button button;

  Pole(Tower tower, PoleSpot _spot)
  {
    w = sf_get_width(tower);
    h = sf_get_height();
    offset = sf_get_offset(tower);
    spot = _spot;

    pos.x = tower.base_pos.x;
    pos.y = tower.base_pos.y - h;

    sf_set_pos_by_spot(tower);

    button = new Button(tower, this);
  }

  void draw()
  {
    rect(pos.x, pos.y + PoleCurve, w, h, PoleCurve);

    button.draw();
  }

  void leave(Disc d)
  {
    for (int i = 0; i < discs.size(); i++)
    {
      if (discs.get(i) == d)
      {
        discs.remove(i);
        break;
      }
    }
  }

  PVector get_pos(Disc d)
  {
    PVector p = pos.copy();

    p.x += -(d.w / 2) + w / 2;

    return p;
  }

  PVector get_spot_pos(Disc d)
  {
    PVector p = pos.copy();

    p.x += -(d.w / 2) + w / 2;
    p.y += h - DiscHeight * (discs.size() + 1);

    return p;
  }

  int get_width()
  {
    return w;
  }

  int get_height()
  {
    return h;
  }

  // Setup functions
  int sf_get_width(Tower tower)
  {
    return (int) (tower.get_width() * PoleWidthMult);
  }

  int sf_get_height()
  {
    return DiscsAmount * (int) (DiscHeight * PoleHeightMult);
  }

  int sf_get_offset(Tower tower)
  {
    return (int) (tower.get_width() * PoleOffset);
  }
  
  void sf_set_pos_by_spot(Tower tower)
  {
    if (spot == PoleSpot.left) pos.x += offset;
    else if (spot == PoleSpot.middle) pos.x += tower.get_width() / 2 - w;
    else if (spot == PoleSpot.right) pos.x += tower.get_width() - offset - w;
  }
}
