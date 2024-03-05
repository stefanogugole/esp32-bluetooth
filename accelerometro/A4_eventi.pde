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
   
      
      for (TableRow row : table.rows()) 
      {
      
        
        
        float time=xInizio + int((row.getFloat("time")-timeInizio)/10);
        
        
        
        
        
        
        if (time>xMouseInizio && time<xMouseFine)
        {
          contatore=contatore+1;
          if (contatore==1)
          {
            tInizio=row.getFloat("time");
          }
          
          
            
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
            cp5.get(Textfield.class,"textInputVariable3").setText(""+(tFine-tInizio)/1000);  //azzerata in Load A1
          }
      }
        //xAttuale=xInizio + int((time-timeInizio)/10);
        cp5.get(Textfield.class,"textInputVariableMax").setText(""+String.format("%.02f", maxAx));
        nero();
        strokeWeight(16);
        point(int(xInizio + int((maxTime-timeInizio)/10)),int(yInizio-maxAx*passoY));
        strokeWeight(4);
        fill(0,0,0);
        textSize(40);
        text("Max Ax: "+maxAx,int(xInizio + int((maxTime-timeInizio)/10)),int(yInizio-maxAx*passoY)-20);
        
    
      
     
      
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
          if (mouseX>=xInizio && isCom==2)  //isCom 2 è load e stop mode
            {
                  //fill(0,0,0);
                  
              if(contatoreClick==1)    //ho già cliccato sopra, è diventato 1
              {
                xMouseInizio=mouseX;
                
                
                
                
                
                        cp5.get(Textfield.class,"textInputVariableMax").setText("");

                
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
    
    
