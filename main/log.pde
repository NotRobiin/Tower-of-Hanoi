class Log
{
  int time;
  String message;

  Log()
  {
  }

  void set_message(String _message, float _time)
  {
    message = _message;
    time = (int) (millis() + _time * 1000);
  }

  void update()
  {
    if (millis() > time)
    {
      time = 0;
      message = null;
    }
  }

  void draw()
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
