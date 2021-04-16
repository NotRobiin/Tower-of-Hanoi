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
    Disc d = new Disc(i, tower.poles.get(DiscsDefaultPole));
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
