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
  color c = color(random(20, 200), random(20, 200), random(20, 200));
  MoveState state = MoveState.none;
  Pole owner = null;
  int move_target;

  Disc(int _size, Pole spawn_point)
  {
    this.pos = new PVector(0, 0);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    this.size = _size;
    this.w = DiscDefaultWidth + this.size * DiscGrowth;
    this.pos = spawn_point.get_spot_pos(this);
    spawn_point.discs.add(this);
    this.owner = spawn_point;
  }

  void draw()
  {
    push();
    strokeWeight(1);
    fill(this.c);

    rect(this.pos.x, this.pos.y, this.w, DiscHeight, DiscCurve);

    if (DiscShowSize)
    {
      float x = this.pos.x + this.w / 2;
      float y = this.pos.y + DiscHeight * 0.75;

      fill(255);
      textSize(DiscShowSizeTextSize);
      text(str(this.size), x, y);
    }

    pop();
  }

  void update(Tower tower)
  {
    this.move(tower);
  }

  void move_to(int which_pole)
  {
    // Leaving a pole.
    if (this.owner != null)
    {
      this.owner.leave(this);
    }

    this.state = MoveState.up;
    this.move_target = which_pole;
  }

  void move(Tower tower)
  {
    if (this.state == MoveState.none)
    {
      return;
    }

    PVector target = new PVector(0, 0);

    if (this.state == MoveState.up)
      target = this.move_up();

    else if (this.state == MoveState.side)
      target = this.move_side(tower, move_target);

    else if (this.state == MoveState.down)
      target = this.move_down(tower, move_target);

    if (target.x == 0 && target.y == 0)
    {
      return;
    }

    PVector direction = PVector.sub(target, this.pos);
    direction.normalize();
    direction.mult(DiscDirectionScaling);

    this.acc = direction;

    this.vel.add(acc);
    this.vel.limit(DiscMaxVelocity);
    this.pos.add(this.vel);

    this.owner = tower.poles.get(this.move_target);
  }

  PVector move_up()
  {
    PVector t = new PVector(this.pos.x, height * 0.1);

    // Move above the pole.
    if (dist(this.pos.x, this.pos.y, t.x, t.y) < DiscDistance)
    {
      this.state = MoveState.side;
      t.x = 0;
      t.y = 0;
    }

    return t;
  }

  PVector move_down(Tower tower, int which_pole)
  {
    Pole p = tower.poles.get(which_pole);
    PVector t = p.get_spot_pos(this);

    // Arrived
    if (dist(this.pos.x, this.pos.y, t.x, t.y) < DiscDistance)
    {
      p.discs.add(this);
      this.owner = p;
      this.state = MoveState.none;
      t.x = 0;
      t.y = 0;
      moving = false;
      this.move_target = -1;
    }

    return t;
  }

  PVector move_side(Tower tower, int which_pole)
  {
    Pole p = tower.poles.get(which_pole);
    PVector t = p.get_pos(this);

    // Fix for jiggling due to acceleration.
    t.y = height * 0.1;

    this.state = MoveState.side;

    // Move down.
    if (dist(this.pos.x, this.pos.y, t.x, t.y) < DiscDistance)
    {
      this.state = MoveState.down;
      t.x = 0;
      t.y = 0;
    }

    return t;
  }
}
