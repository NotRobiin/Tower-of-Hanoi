import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class main extends PApplet {

Tower tower;
ArrayList<Disc> discs = new ArrayList<Disc>();
Arrow arrow;
boolean moving;
Log log = new Log();

public void setup()
{
  

  tower = new Tower();

  for (int i = DiscsAmount; i >= 1; i--)
  {
    Disc d = new Disc(i, tower.poles.get(1));
    discs.add(d);
  }
}

public void draw()
{
  background(BackgroundColor);
  noStroke();

  tower.draw();

  for (Disc d : discs)
  {
    d.update(tower);
    d.draw();
  }

  if (arrow != null)
  {
    arrow.draw();
  }

  log.update();
  log.draw();
}

public void mousePressed()
{
  if (moving)
  {
    return;
  }

  make_arrow();
  move_discs();
}

public void move_discs()
{
  if (arrow == null)
  {
    return;
  }

  for (int i = 0; i < tower.poles.size(); i++)
  {
    Pole p = tower.poles.get(i);
    Disc d = arrow.owner;

    if (is_clicked(p.button.pos, p.button.w, p.button.h) && can_move(d, p))
    {
      arrow.owner.move_to(i);
      moving = true;
      arrow = null;

      break;
    }
  }
}

public boolean is_clicked(PVector pos, int w, int h)
{
  return (mouseX > pos.x && mouseX < pos.x + w && mouseY > pos.y && mouseY < pos.y + h) ? true : false;
}

public boolean can_move(Disc d, Pole p)
{
  Pole own = d.owner;
  if (own == p)
  {
    log.set_message("Cannot move: Targeted the same pole.", 3.0f);
    return false;
  }

  int size = own.discs.size() - 1;
  if (size >= 1 && own.discs.get(size) != d)
  {
    log.set_message("Cannot move: Not the first disc on the pole.", 3.0f);
    return false;
  }

  size = p.discs.size() - 1;
  if (size >= 0 && p.discs.get(size).size < d.size)
  {
    log.set_message("Cannot move: Bigger disc on targeted pole.", 3.0f);
    return false;
  }

  return true;
}
class Arrow
{
  Disc owner;
  PVector pos;

  Arrow(Disc d)
  {
    owner = d;
    pos = d.pos.copy();
  }

  public void draw()
  {
    float x = owner.owner.get_spot_pos(owner).x - ArrowWidth * 2;
    float y = pos.y + DiscHeight / 2;
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

public void make_arrow()
{
  for (Disc d : discs)
  {
    if (is_clicked(d.pos, (int) d.w, DiscHeight))
    {
      arrow = new Arrow(d);
    }
  }
}
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

  public void draw()
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

  public String get_text()
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
/*
  Values listed below have been specifically made for the tower of hanoi to
  look nice. They are very detailed and higly dependent on other values.
  Probably should not touch them unless you absolutely have to and know
  well how (x, y) cartesian coordinate system, RGB and text rendering works.

  @Author github.com/wwicked
*/


// Basic setup
final int DiscsAmount = 10;

// Window
final int BackgroundColor = 51;

// Logs
final int LogTextSize = 13;
final int LogTextColor = color(255, 255, 255);

// Arrow
final int ArrowColor = color(255, 255, 255);
final int ArrowWidth = 10;
final int ArrowHeight = 4;
final int ArrowCurve = 2;
final int ArrowOffsetX = 5;

// Tower
final float TowerWidthMult = 0.9f; // Window width * TowerWidthMult
final float TowerHeightMult = 0.08f; // Window height * TowerHeightMult

final int TowerColor = color(164, 116, 73);
final int TowerCurve = 35;

// Pole
final float PoleWidthMult = 0.03f; // Width * PoleWidthMult
final float PoleHeightMult = 1.25f; // Def. height * PoleHeightMult
final float PoleOffset = 0.15f; // Width * PoleOffset

final int PoleCurve = 13;

// Disc
final int DiscGrowth = 25;
final int DiscCurve = 40;
final int DiscWidth = 30;
final int DiscHeight = 20;
final int DiscDefaultWidth = 40;

final boolean DiscShowSize = true;
final int DiscShowSizeTextSize = 10;
final int DiscTextColor = color(255, 255, 255);

final int DiscMaxVelocity = 7;
final float DiscDirectionScaling = 100.0f;
final int DiscDistance = 5;

final int[] DiscColorRange = {20, 200};

// Button
final int ButtonHeight = 40;
final int ButtonWidthRatio = 5; // Pole width * ratio
final int ButtonColor = color(100, 100, 100);
final int ButtonCurve = 4;
final int ButtonTextColor = color(255, 255, 255);
final int ButtonTextSize = 18;
enum MoveState
{
  none, 
    up, 
    side, 
    down
}

class Disc
{
  PVector pos;
  PVector vel;
  PVector acc;
  float w;
  int size;
  int c = color(random(20, 200), random(20, 200), random(20, 200));
  MoveState state = MoveState.none;
  Pole owner = null;
  int move_target;

  Disc(int _size, Pole spawn_point)
  {
    pos = new PVector(0, 0);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    size = _size;
    w = DiscDefaultWidth + size * DiscGrowth;
    pos = spawn_point.get_spot_pos(this);
    spawn_point.discs.add(this);
    owner = spawn_point;
  }

  public void draw()
  {
    push();
    strokeWeight(1);
    fill(c);

    rect(pos.x, pos.y, w, DiscHeight, DiscCurve);

    if (DiscShowSize)
    {
      float x = pos.x + w / 2;
      float y = pos.y + DiscHeight * 0.75f;

      fill(255);
      textSize(DiscShowSizeTextSize);
      text(str(size), x, y);
    }

    pop();
  }

  public void update(Tower tower)
  {
    move(tower);
  }

  public void move_to(int which_pole)
  {
    // Leaving a pole.
    if (owner != null)
    {
      owner.leave(this);
    }

    state = MoveState.up;
    move_target = which_pole;
  }

  public void move(Tower tower)
  {
    if (state == MoveState.none)
    {
      return;
    }

    PVector target = new PVector(0, 0);

    if (state == MoveState.up) target = move_up();
    else if (state == MoveState.side) target = move_side(tower, move_target);
    else if (state == MoveState.down) target = move_down(tower, move_target);

    if (target.x == 0 && target.y == 0)
    {
      return;
    }

    PVector direction = PVector.sub(target, pos);
    direction.normalize();
    direction.mult(DiscDirectionScaling);

    acc = direction;

    vel.add(acc);
    vel.limit(DiscMaxVelocity);
    pos.add(vel);

    owner = tower.poles.get(move_target);
  }

  public PVector move_up()
  {
    PVector t = new PVector(pos.x, height * 0.1f);

    // Move above the pole.
    if (dist(pos.x, pos.y, t.x, t.y) < DiscDistance)
    {
      state = MoveState.side;
      t.x = 0;
      t.y = 0;
    }

    return t;
  }

  public PVector move_down(Tower tower, int which_pole)
  {
    Pole p = tower.poles.get(which_pole);
    PVector t = p.get_spot_pos(this);

    // Arrived
    if (dist(pos.x, pos.y, t.x, t.y) < DiscDistance)
    {
      p.discs.add(this);
      owner = p;
      state = MoveState.none;
      t.x = 0;
      t.y = 0;
      moving = false;
      move_target = -1;
    }

    return t;
  }

  public PVector move_side(Tower tower, int which_pole)
  {
    Pole p = tower.poles.get(which_pole);
    PVector t = p.get_pos(this);

    // Fix for jiggling due to acceleration.
    t.y = height * 0.1f;

    state = MoveState.side;

    // Move down.
    if (dist(pos.x, pos.y, t.x, t.y) < DiscDistance)
    {
      state = MoveState.down;
      t.x = 0;
      t.y = 0;
    }

    return t;
  }
}
class Log
{
  int time;
  String message;

  Log()
  {
  }

  public void set_message(String _message, float _time)
  {
    message = _message;
    time = (int) (millis() + _time * 1000);
  }

  public void update()
  {
    if (millis() > time)
    {
      time = 0;
      message = null;
    }
  }

  public void draw()
  {
    if (millis() > time || message == null)
    {
      return;
    }

    push();
    fill(LogTextColor);
    textSize(LogTextSize);
    text(message, 0, 0 + LogTextSize);
    pop();
  }
}
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

  public void draw()
  {
    rect(pos.x, pos.y + PoleCurve, w, h, PoleCurve);

    button.draw();
  }

  public void leave(Disc d)
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

  public PVector get_pos(Disc d)
  {
    PVector p = pos.copy();

    p.x += -(d.w / 2) + w / 2;

    return p;
  }

  public PVector get_spot_pos(Disc d)
  {
    PVector p = pos.copy();

    p.x += -(d.w / 2) + w / 2;
    p.y += h - DiscHeight * (discs.size() + 1);

    return p;
  }

  public int get_width()
  {
    return w;
  }

  public int get_height()
  {
    return h;
  }

  // Setup functions
  public int sf_get_width(Tower tower)
  {
    return (int) (tower.get_width() * PoleWidthMult);
  }

  public int sf_get_height()
  {
    return DiscsAmount * (int) (DiscHeight * PoleHeightMult);
  }

  public int sf_get_offset(Tower tower)
  {
    return (int) (tower.get_width() * PoleOffset);
  }
  
  public void sf_set_pos_by_spot(Tower tower)
  {
    if (spot == PoleSpot.left) pos.x += offset;
    else if (spot == PoleSpot.middle) pos.x += tower.get_width() / 2 - w;
    else if (spot == PoleSpot.right) pos.x += tower.get_width() - offset - w;
  }
}
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
    base_pos.y = height * 0.65f;

    poles.add(new Pole(this, PoleSpot.left));
    poles.add(new Pole(this, PoleSpot.middle));
    poles.add(new Pole(this, PoleSpot.right));
  }

  public void draw()
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

  public int get_color()
  {
    return TowerColor;
  }

  public int get_width()
  {
    return w;
  }

  public int get_height()
  {
    return h;
  }
}
  public void settings() {  size(1000, 500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
