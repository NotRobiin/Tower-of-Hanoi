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
final color LogTextColor = color(255, 255, 255);

// Arrow
final color ArrowColor = color(255, 255, 255);
final int ArrowWidth = 10;
final int ArrowHeight = 4;
final int ArrowCurve = 2;
final int ArrowOffsetX = 5;

// Tower
final float TowerWidthMult = 0.9; // Window width * TowerWidthMult
final float TowerHeightMult = 0.08; // Window height * TowerHeightMult

final color TowerColor = color(164, 116, 73);
final int TowerCurve = 35;

// Pole
final float PoleWidthMult = 0.03; // Width * PoleWidthMult
final float PoleHeightMult = 1.25; // Def. height * PoleHeightMult
final float PoleOffset = 0.15; // Width * PoleOffset

final int PoleCurve = 13;

// Disc
final int DiscGrowth = 25;
final int DiscCurve = 40;
final int DiscWidth = 30;
final int DiscHeight = 20;
final int DiscDefaultWidth = 40;

final boolean DiscShowSize = true;
final int DiscShowSizeTextSize = 10;
final color DiscTextColor = color(255, 255, 255);

final int DiscMaxVelocity = 7;
final float DiscDirectionScaling = 100.0;
final int DiscDistance = 5;

final int[] DiscColorRange = {20, 200};

// Button
final int ButtonHeight = 40;
final int ButtonWidthRatio = 5; // Pole width * ratio
final color ButtonColor = color(100, 100, 100);
final int ButtonCurve = 4;
final color ButtonTextColor = color(255, 255, 255);
final int ButtonTextSize = 18;
