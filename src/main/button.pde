class Button
{
  PVector pos;
  Pole owner;
  int w;
  int h;

  Button(Tower tower, Pole pole)
  {
    this.owner = pole;
    this.h = ButtonHeight;
    this.w = (int) (this.owner.get_width() * ButtonWidthRatio);

    float x = this.owner.pos.x - (this.w / 2) + (this.owner.get_width() / 2);
    float y = tower.base_pos.y + (this.h * 2);
    this.pos = new PVector(x, y);
  }

  void draw()
  {
    push();
    fill(ButtonColor);
    rect(this.pos.x, this.pos.y, this.w, this.h, ButtonCurve);


    pushMatrix();
    translate(this.pos.x, this.pos.y);

    float x = this.w / 2;
    float y = this.h / 2;

    fill(ButtonTextColor);

    textAlign(CENTER, CENTER);
    textSize(ButtonTextSize);
    text(this.get_text(), x, y);

    popMatrix();
    pop();
  }

  String get_text()
  {
    String out = "";

    // Such a weird syntax...
    switch(this.owner.spot)
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
