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
  
  
  lastx=xInizio;    //si parte col contatore a zero
  lasty=yInizio;
  i=xInizio;
  
  
  strokeWeight(4);  // Thicker
  line(xInizio, yInizio, 1600, yInizio);
  stroke(250,0,0);
  line(xInizio, yInizio-passoY*9.81, 1600, yInizio-passoY*9.81);
  line(xInizio, yInizio+passoY*9.81, 1600, yInizio+passoY*9.81);
  lineaGrigia();
  stroke(0);
  fill(0,255,0);
  ellipse(100, 750, 50, 50);        //bottone start
  text("Campiona",100,720);
  fill(255,0,0);
  ellipse(200, 750, 50, 50);        //bottone stop
  text("Stop camp.",200,720);
  fill(0,0,255);
  ellipse(300, 750, 50, 50);        //bottone load
  text("Load "+nameFile,270,720);
  fill (100,100,100);
  ellipse(400,750,50,50);            //bottone save
  text("salva "+nameFile,400,720);

}
