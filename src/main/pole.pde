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
    this.w = sf_get_width(tower);
    this.h = sf_get_height();
    this.offset = sf_get_offset(tower);
    this.spot = _spot;

    this.pos.x = tower.base_pos.x;
    this.pos.y = tower.base_pos.y - this.h;

    sf_set_pos_by_spot(tower);

    this.button = new Button(tower, this);
  }

  void draw()
  {
    rect(this.pos.x, this.pos.y + PoleCurve, this.w, this.h, PoleCurve);

    this.button.draw();
  }

  void leave(Disc disc)
  {
    for (int i = 0; i < this.discs.size(); i++)
    {
      if (this.discs.get(i) == disc)
      {
        this.discs.remove(i);
        break;
      }
    }
  }

  PVector get_pos(Disc disc)
  {
    PVector target_pos = this.pos.copy();

    target_pos.x += -(disc.w / 2) + this.w / 2;

    return target_pos;
  }

  PVector get_spot_pos(Disc d)
  {
    PVector target_pos = this.pos.copy();

    target_pos.x += -(d.w / 2) + this.w / 2;
    target_pos.y += this.h - DiscHeight * (this.discs.size() + 1);

    return target_pos;
  }

  int get_width()
  {
    return this.w;
  }

  int get_height()
  {
    return this.h;
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
    if (this.spot == PoleSpot.left)
      this.pos.x += this.offset;

    else if (this.spot == PoleSpot.middle)
      this.pos.x += tower.get_width() / 2 - this.w;

    else if (this.spot == PoleSpot.right)
      this.pos.x += tower.get_width() - offset - this.w;
  }
}
