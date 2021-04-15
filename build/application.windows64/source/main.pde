Tower tower;
ArrayList<Disc> discs = new ArrayList<Disc>();
Arrow arrow;
boolean moving;
Log log = new Log();

void setup()
{
  size(1000, 500);

  tower = new Tower();

  for (int i = DiscsAmount; i >= 1; i--)
  {
    Disc d = new Disc(i, tower.poles.get(1));
    discs.add(d);
  }
}

void draw()
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

void mousePressed()
{
  if (moving)
  {
    return;
  }

  make_arrow();
  move_discs();
}

void move_discs()
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

boolean is_clicked(PVector pos, int w, int h)
{
  return (mouseX > pos.x && mouseX < pos.x + w && mouseY > pos.y && mouseY < pos.y + h) ? true : false;
}

boolean can_move(Disc d, Pole p)
{
  Pole own = d.owner;
  if (own == p)
  {
    log.set_message("Cannot move: Targeted the same pole.", 3.0);
    return false;
  }

  int size = own.discs.size() - 1;
  if (size >= 1 && own.discs.get(size) != d)
  {
    log.set_message("Cannot move: Not the first disc on the pole.", 3.0);
    return false;
  }

  size = p.discs.size() - 1;
  if (size >= 0 && p.discs.get(size).size < d.size)
  {
    log.set_message("Cannot move: Bigger disc on targeted pole.", 3.0);
    return false;
  }

  return true;
}
