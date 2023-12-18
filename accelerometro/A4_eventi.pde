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

void mousePressed()
{
  if (mouseButton == LEFT)
     {    
    if (mouseX>=xInizio && mouseY>=200)  //and not in LOAD mode? in Load mode ci sono 2-3 grafici cinematici, bisogna cambiarlo
      {
            //fill(0,0,0);
            stroke(0);
            strokeWeight(2);
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
            strokeWeight(1);
        }
     }
      if (mouseButton == RIGHT)
     {    
        if (mouseX>=xInizio)  //and not in LOAD mode? in Load mode ci sono 2-3 grafici cinematici, bisogna cambiarlo
          {
                //fill(0,0,0);
                
                strokeWeight(2);
                rosso();
                line(mouseX,800,mouseX,0);
               
               
               
                nero();
                strokeWeight(16);
           
                strokeWeight(1);
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
            
            strokeWeight(2);  // Thicker
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
    
    
