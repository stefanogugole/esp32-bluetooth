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
  
}

void graficoCinematiche()
{
  background(255);
  
  
  lastx=xInizio;    //si parte col contatore a zero
  lasty=250;
  
  lastV=0;
  lastH=0;
  lastT=0;
  
  i=xInizio;
  
  
  strokeWeight(4);  // Thicker
  nero();
  line(xInizio, 250, 1600, 250);  //disegno asse x
  
  rosso();
  
  line(xInizio, 250-passoYLoad*9.81, 1600, 250-passoYLoad*9.81);  //linea sopra 
  line(xInizio, 250+passoYLoad*9.81, 1600, 250+passoYLoad*9.81);  //linea sotto
  nero();
  
  line(xInizio, 500, 1600, 500);  //disegno asse v
  
  line(xInizio, 750, 1600, 750);
  
}
