class Log
{
  int time;
  String message;

  Log()
  {
  }

  void set_message(String _message, float _time)
  {
    this.message = _message;
    this.time = (int) (millis() + _time * 1000);
  }

  void update()
  {
    if (millis() > this.time)
    {
      this.time = 0;
      this.message = null;
    }
  }

  void draw()
  {
    if (millis() > this.time || this.message == null)
    {
      return;
    }

    push();
    fill(LogTextColor);
    textSize(LogTextSize);
    text(this.message, 0, LogTextSize);
    pop();
  }
}
