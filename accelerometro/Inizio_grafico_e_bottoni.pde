void lineaGrigia()  //isto
{
  stroke(150);
}
void lineaGraf()
{
  stroke(0,0,250);
}



void grafico()
{
  background(255);
  strokeWeight(4);  // Thicker
  line(xInizio, yInizio, 1600, yInizio);
  stroke(250,0,0);
  line(xInizio, yInizio-passoY*9.81, 1600, yInizio-passoY*9.81);
  line(xInizio, yInizio+passoY*9.81, 1600, yInizio+passoY*9.81);
  lineaGrigia();
  stroke(0);
  fill(0,255,0);
  ellipse(100, 750, 50, 50);        //bottone start
  fill(255,0,0);
  ellipse(200, 750, 50, 50);        //bottone stop
  fill(0,0,255);
  ellipse(300, 750, 50, 50);        //bottone load
  fill (100,100,100);
  ellipse(400,750,50,50);            //bottone save
  text("salva",400,720);
}
