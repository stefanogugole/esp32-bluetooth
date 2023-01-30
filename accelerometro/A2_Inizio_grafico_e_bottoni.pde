void grigio()  //isto
{
  stroke(150);
}

void rosso()  //isto
{
  stroke(250,0,0);  //in rosso
}
void blu()
{
  stroke(0,0,250);
}
void nero()
{
  stroke(0);
}



void grafico()
{
  background(255);
  
  
  lastx=xInizio;    //si parte col contatore a zero
  lasty=yInizio;
  lastV=0;
  lastH=0;
  lastT=0;
  i=xInizio;
  
  
  strokeWeight(4);  // Thicker
  nero();
  line(xInizio, yInizio, 1600, yInizio);  //disegno asse x
  
  rosso();
  line(xInizio, yInizio-passoY*9.81, 1600, yInizio-passoY*9.81);  //linea sopra 
  line(xInizio, yInizio+passoY*9.81, 1600, yInizio+passoY*9.81);  //linea sotto
  nero();
  
  
  
  /*
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
*/
}
