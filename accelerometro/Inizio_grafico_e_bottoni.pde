void lineaGrigia()  //isto
{
  stroke(150);
}
void lineaGraf()
{
  stroke(0,0,250);
}

void casella()
{

}

void grafico()
{
  background(255);
  strokeWeight(4);  // Thicker
  line(i, 400, 1600, 400);
  stroke(250,0,0);
  line(i, 400-passoY*9.81, 1600, 400-passoY*9.81);
  line(i, 400+passoY*9.81, 1600, 400+passoY*9.81);
  lineaGrigia();
  stroke(0);
  fill(0,255,0);
  ellipse(100, 750, 50, 50);        //C(100,750)
  fill(255,0,0);
  ellipse(200, 750, 50, 50);        //C(175,750)
  fill(0,0,255);
  ellipse(300, 750, 50, 50);        //C(175,750)
}
