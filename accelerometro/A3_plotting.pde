

void Campiona()  //riempie in tempo reale i contenitori time, accX e h. Chiamato in loop draw() in A1

{
      
        
        
        
          try
          {
            accX=json.getFloat(nomeVal())-9.81;    //scalo già 9.81
          }
          catch (Exception e)
          {
            println("errore in json.getFloat(\"ax\")");
          }
        
        
        
        
        
        try
        {
          //lastTA3=json.getFloat("time");
          time=json.getFloat("time");
          h=json.getFloat(nomeVal2());
          
        }
        catch (Exception e)
        {
          println("errori in json.getFloat(\"time\") o h ");
        }
        
      
    
  //}  commentato if sopra
      
      if ( lastx>=1550)    //finito il grafico si reinizia e cancello la tabella
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
    //accX = json.getFloat("ax");
    //time = json.getFloat("time");
    
    //time=lastTA3;  //appena letto json.getFloat(time) poco fa
    
    
    
    if (abs(accX) < 1000 && time!=lastTA3 )  //dati sporchi, ma quando mai più di 100 m/s^2 in salto. Elimino i doppioni, non scendo sotto 36milli
    {
      TableRow newRow = table.addRow();
      newRow.setInt("i",i);
      newRow.setFloat("time", time);
      newRow.setFloat(nomeVal(),accX);
      
 
      
      
      newRow.setFloat(nomeVal2(),h);    
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
      lastTA3=time;
      
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
