enum MoveState
{
  none, 
    up, 
    side, 
    down
}

class Disc
{
  PVector pos = new PVector(0, 0);
  PVector vel = new PVector(0, 0);
  PVector acc = new PVector(0, 0);
  float w;
  int size;
  color c = color(random(20, 200), random(20, 200), random(20, 200));
  MoveState state = MoveState.none;
  Pole owner = null;
  int move_target;

  Disc(int _size, Pole spawn_point)
  {
    this.size = _size;
    this.w = DiscDefaultWidth + this.size * DiscGrowth;
    this.owner = spawn_point;
    this.pos = this.owner.get_spot_pos(this);
    this.owner.discs.add(this);
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

    PVector target = null;

    if (this.state == MoveState.up)
      target = this.move_up();

    else if (this.state == MoveState.side)
      target = this.move_side(tower, move_target);

    else if (this.state == MoveState.down)
      target = this.move_down(tower, move_target);

    if (target == null || this.move_target == -1)
    {
      return;
    }

    PVector direction = PVector.sub(target, this.pos);
    direction.normalize();
    direction.mult(DiscDirectionScaling);

    this.acc = direction;

    this.vel.add(this.acc);
    this.vel.limit(DiscMaxVelocity);
    this.pos.add(this.vel);

    this.owner = tower.poles.get(this.move_target);
  }

  PVector move_up()
  {
    PVector target_pos = new PVector(this.pos.x, height * 0.1);

    // Move above the pole.
    if (dist(this.pos.x, this.pos.y, target_pos.x, target_pos.y) < DiscDistance)
    {
      this.state = MoveState.side;
      target_pos.x = 0;
      target_pos.y = 0;
    }

    return target_pos;
  }

  PVector move_down(Tower tower, int which_pole)
  {
    Pole target_pole = tower.poles.get(which_pole);
    PVector target_pos = target_pole.get_spot_pos(this);

    // Arrived
    if (dist(this.pos.x, this.pos.y, target_pos.x, target_pos.y) < DiscDistance)
    {
      target_pole.discs.add(this);
      this.owner = target_pole;
      this.state = MoveState.none;
      target_pos.x = 0;
      target_pos.y = 0;
      moving = false;
      this.move_target = -1;
    }

    return target_pos;
  }

  PVector move_side(Tower tower, int which_pole)
  {
    Pole target_pole = tower.poles.get(which_pole);
    PVector target_pos = target_pole.get_pos(this);

    // Fix for jiggling due to acceleration.
    target_pos.y = height * 0.1;

    this.state = MoveState.side;

    // Move down.
    if (dist(this.pos.x, this.pos.y, target_pos.x, target_pos.y) < DiscDistance)
    {
      this.state = MoveState.down;
      target_pos.x = 0;
      target_pos.y = 0;
    }

    return target_pos;
  }
}
