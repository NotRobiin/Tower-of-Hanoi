class Button
{
  PVector pos;
  Pole owner;
  int w;
  int h;

  Button(Tower tower, Pole o)
  {
    owner = o;
    h = ButtonHeight;
    w = (int) (owner.get_width() * ButtonWidthRatio);

    float x = owner.pos.x  - (w / 2) + (owner.get_width() / 2);
    float y = tower.base_pos.y + (h * 2);
    pos = new PVector(x, y);
  }

  void draw()
  {
    push();
    fill(ButtonColor);
    rect(pos.x, pos.y, w, h, ButtonCurve);


    pushMatrix();
    translate(pos.x, pos.y);

    float x = w / 2;
    float y = h / 2;

    fill(ButtonTextColor);

    textAlign(CENTER, CENTER);
    textSize(ButtonTextSize);
    text(get_text(), x, y);

    popMatrix();
    pop();
  }

  String get_text()
  {
    String out = "";

    // Such a weird syntax...
    switch(owner.spot)
    {
    case left: 
      out = "Left"; 
      break;
    case middle:
      out = "Middle"; 
      break;
    case right:
      out = "Right"; 
      break;
    }

    return out;
  }
}
