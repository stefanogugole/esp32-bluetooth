class Ricezione
{
  float accXInizio=9.81;
  void setAccXInizio(float valore)
  {
    accXInizio=valore;
  }
  float getAccXInizio()
  {
    return accXInizio;
  } 
   
   
  
  int convalidaAccX(float accX)  //qui devo inserire diversi controlli sul dato
  {
    if (abs(accX)<40)  //non ci sono salti oltre 4g, spero
    {
      return 1;
    }
    else
    { return 0;}
  }
  
  
  void setTime()
  {
    time=float(split(val , ':' )[0]);
  }
  float getTime()
  {
    return time;
  }
  
  void setAccX()
  {
    String tmpVal = split(val , ':' )[1];
    accX=float(splitTokens(tmpVal)[0])-getAccXInizio(); //round()
    
  }
  float getAccX()
  {
    return accX;
  }
  
  
  
}


void Campiona()  //riempie in tempo reale i contenitori time, accX e h. Chiamato in loop draw() in A1

{
      
      
      
      if ( lastx>=1550 )    //finito il grafico si reinizia e cancello la tabella
      {
        grafico();  //ri-inizializzo 
        table.clearRows();
        lastx=xInizio;
      }
  
  try{
    
    
   
    
    
    /*
    time = float(split(val , ':' )[0]);
    //val1 = split(val , ':' )[1]; val2 = split(val , ':' )[2]; 
    accX = float(splitTokens(split(val , ':' )[1])[0])-9.81; //round()
    h = float(splitTokens(split(val , ':' )[2])[0]); //round() in CM!!!!!
    //println("a "+accX+" h "+h);
    //plotGraficoAx(i,yInizio,accX);
    */
    accX = json.getFloat("ax");
    time = json.getFloat("time");
    h=json.getFloat("h");
    
    if (abs(accX) < 1000)  //dati sporchi, ma quano mai più di 100 m/s^2 in salto
    {
      TableRow newRow = table.addRow();
      newRow.setInt("i",i);
      newRow.setFloat("time", time);
      newRow.setFloat("ax",accX);    //se premi stop salvi il file
      newRow.setFloat("h",h);    //se premi stop salvi il file
      //println(accX+":"+h);
      strokeWeight(2);  // Thicker
      grigio();
      
      if (lastx==xInizio)  //setto Dt iniziale per le "x" del grafico
                {
                  timeInizio=time;
                  lasty=yInizio;    
                }
      stroke(0);
      
      
      int xAttuale=xInizio + passoX+ int((time-timeInizio)/10);              //e se x troppo in là?
      int yAttuale=int(yInizio-accX*passoY);
      //println("x Attuale"+xAttuale);
      line(xAttuale,yInizio, xAttuale, yAttuale ); //istogramma
      blu();
      line(lastx,lasty,xAttuale,yAttuale);
      //lastx=i;                      //memorizzo scorso punto in lastx e lasty
      lastx=xAttuale;
      lasty=yAttuale;
      
      println("tempo"+int((time-timeInizio)/10));
      grigio();   
      
      //i=i+passoX;  //la i è la x sul grafico, che avanza nel tempo
      
      
                
                
      i=i+passoX;      //serve salvarlo? al momento, no
      
      
      
      
    }
  }
  catch (Exception e)
  {
    //println("errore parsing "+e);
  }
    
}
