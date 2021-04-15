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
    pos = new PVector(0, 0);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    size = _size;
    w = DiscDefaultWidth + size * DiscGrowth;
    pos = spawn_point.get_spot_pos(this);
    spawn_point.discs.add(this);
    owner = spawn_point;
  }

  void draw()
  {
    push();
    strokeWeight(1);
    fill(c);

    rect(pos.x, pos.y, w, DiscHeight, DiscCurve);

    if (DiscShowSize)
    {
      float x = pos.x + w / 2;
      float y = pos.y + DiscHeight * 0.75;

      fill(255);
      textSize(DiscShowSizeTextSize);
      text(str(size), x, y);
    }

    pop();
  }

  void update(Tower tower)
  {
    move(tower);
  }

  void move_to(int which_pole)
  {
    // Leaving a pole.
    if (owner != null)
    {
      owner.leave(this);
    }

    state = MoveState.up;
    move_target = which_pole;
  }

  void move(Tower tower)
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

  PVector move_up()
  {
    PVector t = new PVector(pos.x, height * 0.1);

    // Move above the pole.
    if (dist(pos.x, pos.y, t.x, t.y) < DiscDistance)
    {
      state = MoveState.side;
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

  PVector move_side(Tower tower, int which_pole)
  {
    Pole p = tower.poles.get(which_pole);
    PVector t = p.get_pos(this);

    // Fix for jiggling due to acceleration.
    t.y = height * 0.1;

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
