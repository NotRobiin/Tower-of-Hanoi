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

boolean can_move(Disc disc, Pole pole)
{
  if (disc.owner == pole)
  {
    log.set_message("Cannot move: Targeted the same pole.", 3.0);
    return false;
  }

  int size = disc.owner.discs.size() - 1;
  if (size >= 1 && disc.owner.discs.get(size) != disc)
  {
    log.set_message("Cannot move: Not the first disc on the pole.", 3.0);
    return false;
  }

  size = pole.discs.size() - 1;
  if (size >= 0 && pole.discs.get(size).size < disc.size)
  {
    log.set_message("Cannot move: Bigger disc on targeted pole.", 3.0);
    return false;
  }

  return true;
}
