class Arrow
{
  Disc owner;
  PVector pos;

  Arrow(Disc disc)
  {
    this.owner = disc;
    this.pos = this.owner.pos.copy();
  }

  void draw()
  {
    float x = this.owner.owner.get_spot_pos(this.owner).x - ArrowWidth * 2;
    float y = this.pos.y + DiscHeight / 2;
    float x1 = x + ArrowWidth;
    float y1 = y - ArrowWidth / 2;
    float x2 = x + ArrowWidth;
    float y2 = y + ArrowWidth / 2 + ArrowHeight;
    float x3 = x + ArrowHeight + ArrowWidth + ArrowOffsetX;
    float y3 = y + (ArrowHeight / 2);

    push();
    noStroke();
    fill(ArrowColor);
    rect(x - ArrowWidth * 2, y, ArrowWidth * 3, ArrowHeight, ArrowCurve);
    triangle(x1, y1, x2, y2, x3, y3);
    pop();
  }
}

void make_arrow()
{
  for (Disc d : discs)
  {
    if (is_clicked(d.pos, (int) d.w, DiscHeight))
    {
      arrow = new Arrow(d);
    }
  }
}
