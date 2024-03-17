/*boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}
*/

int contatoreClick=0;
int xMouseInizio=0;
int xMouseFine=0;

float maxAx=0;
float maxTime=0;
float maxV=0;
float maxH=0;
float maxTimeH=0;
float maxTimeV=0;
float maxTimeHsens=0;
float minTimeHsens=0;
float maxHsens=0;
float minHsens=0;
float maxHsensDT=0;

float tInizio=0;  //prima riga rossa
float tFine=0;

int contatore=0;  //misuro se è la prima riga dell'intervallo righe rosse verticali
int contatore2=0;  //misuro se sono uscito dall'intervallo righe rosse verticali
      
      
void aggiungiClick()
{
  contatoreClick=(contatoreClick+1)%2;    //resto divisione: 0 scelto inizio, 1 scelto fine.
}

void cercaMax(int xMouseInizio, int xMouseFine)
{
  try
  {
       //println("entrato in cercaMax");  
      //contorno iniziale
              maxHsensDT=0;
              minHsens=0;
              maxHsens=0;
              maxAx=0;
              maxV=0;
              maxH=0;
              timeInizio=table.getRow(0).getFloat("time");
              float timeInizioIntervallo=timeInizio;  //lo uso solo per righe rosse cercamax
              lastV=0;
              lastx=xInizio;
              lasty=yInizio;
              lastH=0;
              lastT=timeInizio;
              
              //fine contorno  
      
      float time=timeInizio;
      float accX=0;
      float timeX=xInizio;
      
      for (TableRow row : table.rows()) 
      {
          //println("contatore: "+contatore);
        
        
        
        time=row.getFloat("time");  
        accX = row.getFloat(nomeVal());
        timeX=xInizio + int((time-timeInizio)/10);  //dove sono su asse x, serve timeinizio
        
        if (timeX>xMouseInizio && timeX<xMouseFine)
        {
          contatore=contatore+1;
        }
        
        if (contatore==1)  //ha a che fare con le righe rosse e cercamax in A4
          {
            minHsens=row.getFloat("h");
            maxHsens=row.getFloat("h");
            //println("entrato contatore 1:"+contatore);
            timeInizioIntervallo=row.getFloat("time");  //non serve probabilmente
            lastT=timeInizioIntervallo;
            lastx=timeX;   
            //lasty=500;  //??? 500 è v, 250 è a, 750 è h//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            
 
            
          }
          
        
        
        println("Contatore: "+contatore+" timeX: "+timeX+" mouseinizio "+xMouseInizio+" mousefine "+xMouseFine);
        if (timeX>xMouseInizio && timeX<xMouseFine)
        {
          
          //plot v e h
          
          if (isCom==3)
          {
                println("isCom=3, tempo " + time + " a " + accX);
                
                strokeWeight(2);  // Thicker
                stroke(0);
                v=lastV+accX*(time-lastT)/1000;
                h=lastH+lastV*(time-lastT)/1000+0.5*round(accX)*(time-lastT)/1000*(time-lastT)/1000;
                println("velocità "+v+" dt "+(time-lastT));
                //line(i,250, i, int(250-accX*passoYLoad)); //istogramma
                line(timeX,500,timeX,500 - round(v*passoV));  //qui il time serve in pixel
                line(timeX,750,timeX,750-round(h*passoH));
                
                blu();
                //line(lastx,lasty,i,int(250-accX*passoYLoad));
                
                
                
                line(lastx,500-round(lastV*passoV),timeX,500-round(v*passoV));
                line(lastx,750-round(passoH*lastH),timeX,750-round(h*passoH));
                
                lastx=timeX;                      //memorizzo scorso punto in lastx e lasty
                //lastT=time;  //assegnazione che fa sempre e comunque a fine for 
                //lasty=int(250-accX*passoYLoad);
                lastV=v;
                lastH=h;
                println("velocità v"+v);
                 
                grigio();   
                
                
                
                if(h>maxH)
                {
                  maxH=h;
                  maxTimeH=time;
                }
                
                if (v>maxV)
                {
                  maxV=v;
                  maxTimeV=time;
                  
                }
                
                if (row.getFloat("h")>maxHsens)
                {
                  maxHsens=row.getFloat("h");
                  maxTimeHsens=time;
                }
                if (row.getFloat("h")<minHsens)
                {
                  minHsens=row.getFloat("h");
                  minTimeHsens=time;
                }
          
          
          }
          // fine plot v e h

            
          if (row.getFloat(nomeVal())>maxAx)
            {
              maxAx=row.getFloat(nomeVal());
              maxTime=row.getFloat("time");
            }
          
        }
        if (contatore>0){
          contatore2=contatore2+1;
        }
        if (contatore>0 && contatore2==contatore+1)  //scrivo solo la prima volta, sennò continua
          {
            tFine=row.getFloat("time");
            cp5.get(Textfield.class,"textInputVariable3").setText(""+(tFine-timeInizioIntervallo)/1000);  //azzerata in Load A1
            
          }
          
          
          lastT=time;
      }      //fine for table
      
      
        cp5.get(Textfield.class,"textInputVariableMax").setText(""+String.format("%.02f", maxAx));
        cp5.get(Textfield.class,"textInputVariableMaxV").setText(""+String.format("%.02f",maxV));
        cp5.get(Textfield.class,"textInputVariableMaxH").setText(""+String.format("%.02f",maxH));
        cp5.get(Textfield.class,"textInputSensMaxH").setText(""+String.format("%.02f",maxHsens-minHsens));
        cp5.get(Textfield.class,"textInputSensMaxHDT").setText(""+String.format("%.03f",(maxTimeHsens-minTimeHsens)*2/1000));

        
        nero();
        strokeWeight(16);
        
        
        if (isCom==2)  //finestra Load o cmq Stop
        {
          point(xInizio + int((maxTime-timeInizio)/10),int(yInizio-maxAx*passoY));  //non serve timeInizio, è già scalato
        }
        if (isCom==3)
        {
          point(xInizio+int((maxTime-timeInizio)/10),int(yInizioCine-maxAx*passoYLoad));
          point(xInizio+int((maxTimeV-timeInizio)/10),500-round(maxV*passoV));
          point(xInizio+int((maxTimeH-timeInizio)/10),750-round(maxH*passoH));
        }
        
        strokeWeight(4);
        fill(0,0,0);
        textSize(40);
        if (isCom==2)
        {
          text("Max Ax: "+maxAx,int(xInizio + int((maxTime-timeInizio)/10)),int(yInizio-maxAx*passoY)-20);
        }
        if (isCom==3)
        {
          text("Max Ax: "+maxAx,int(xInizio + int((maxTime-timeInizio)/10)),int(yInizioCine-maxAx*passoYLoad)-10);
          text("Vmax: "+maxV,xInizio+int((maxTimeV-timeInizio)/10),500-round(maxV*passoV)-10);
          text("Hmax: "+maxH,xInizio+int((maxTimeH-timeInizio)/10),750-round(maxH*passoH)-10);
        }
        
        
    
      
     
      
  }
   catch (Exception e)
             {
               println("problemi con max e min");
             }
}

void mousePressed()
{
  if (mouseButton == LEFT)
     {    
    if (mouseX>=xInizio && mouseY>=200)  //and not in LOAD mode? in Load mode ci sono 2-3 grafici cinematici, bisogna cambiarlo
      {
           
        
        
            
            //fill(0,0,0);
            stroke(0);
            strokeWeight(4);
            textSize(40);
            if (mouseY<400)          //etichetta con scritta sopra o sotto punto in base a settore sopra o sotto
            {
              text("A: "+(yInizio-mouseY)/passoY,mouseX,mouseY-50);
            }
            else
            {
              text("A: "+(yInizio-mouseY)/passoY,mouseX,mouseY+50);
            }
            fill(0,0,0);
            nero();
            strokeWeight(16);
            point(mouseX,mouseY);
            strokeWeight(4);
        }
     }
      if (mouseButton == RIGHT)
     {    
          aggiungiClick();  //con Load devo azzerare click
          if (mouseX>=xInizio && (isCom==2 || isCom==3))  //isCom 2 è load e stop mode o isCom 3 cinematiche
            {
                  //fill(0,0,0);
                  
              if(contatoreClick==1)    //ho già cliccato sopra, è diventato 1
              {
                xMouseInizio=mouseX;
                
                
                
                
                
                        cp5.get(Textfield.class,"textInputVariableMax").setText("");
                        cp5.get(Textfield.class,"textInputVariableMaxV").setText("");
                        cp5.get(Textfield.class,"textInputVariableMaxH").setText("");
                        cp5.get(Textfield.class,"textInputSensMaxH").setText("");
                        cp5.get(Textfield.class,"textInputSensMaxHDT").setText("");
                        maxAx=0;
                        maxV=0;
                        maxH=0;

                
                //cp5.get(Textfield.class,"textInputVariableMax").setText(""+xMouseInizio);
              }
              else
              {
                if (contatoreClick==0 && mouseX>xMouseInizio) //ho già cliccato sopra, è diventato 2
                {
                  xMouseFine=mouseX;
                  cercaMax(xMouseInizio, mouseX);
                  xMouseInizio=0;
                  xMouseFine=0;
                  maxAx=0;    //resetto i max
                  maxTime=0;
                  contatore=0;
                  contatore2=0;
                  
                  //cp5.get(Textfield.class,"textInputVariableMax").setText(""+xMouseFine);
                }
               
              }
                
                strokeWeight(4);
                rosso();
                line(mouseX,800,mouseX,0);
               
               
               
                nero();
               
           
                strokeWeight(4);
            }
     }
     
    /*
    
    
    if (overCircle(100,750,50))    //verde -> verifica se c'è porta e in caso la collega e parte acquisizione
    {
        
        
        if (isCom==1)
          {
            grafico();
            verde=1;    //premuto tasto verde
            i=xInizio;                             //si parte dall'inizio
            table = new Table();                  //tabella nuova ad ogni pressione
            table.addColumn("i",Table.INT);
            table.addColumn("time",Table.FLOAT);
            table.addColumn("ax",Table.FLOAT);
            
          }
        
    }
    else  if (overCircle(200,750,50))    //rosso -> stop acquisizione
    {     
        verde=0;
    }
    else if (overCircle(300,750,50))    //load
    {
          verde=0;
          table = new Table();                  //tabella nuova ad ogni pressione
          //table = loadTable(nameFile, "header");  //servirebbe PATH automatico
          //cp5.get(Textfield.class,"textInput_1").getText(); 
          url1 = cp5.get(Textfield.class,"textInput_1").getText();
          table = loadTable("data/"+url1+".csv", "header");
          grafico();
          for (TableRow row : table.rows()) 
          {
            int i = row.getInt("i");
            float time = row.getFloat("time");
            float accX = row.getFloat("ax");
            println(i + " tempo " + time + " a " + accX);
            
    strokeWeight(4)  // Thicker
            stroke(0);
            line(i,yInizio, i, yInizio-accX*passoY); //istogramma
            blu();
            line(lastx,lasty,i,int(yInizio-accX*passoY));
            lastx=i;                      //memorizzo scorso punto in lastx e lasty
            lasty=int(yInizio-accX*passoY);
            grigio();        
          }   
      }
      else if (overCircle(400,750,50))
      {
        verde=0;
        //saveTable(table, nameFile);    //il salva deve essere su un altro bottone
        url1 = cp5.get(Textfield.class,"textInput_1").getText();
        saveTable(table,"data/"+url1+".csv");
        
      }
      
      
      
      else if
      */
      
}
    
    
