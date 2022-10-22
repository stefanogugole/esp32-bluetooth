boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}

void mousePressed()
{
    if (overCircle(100,750,50))    //verde -> verifica se c'è porta e in caso la collega e parte acquisizione
    {
        
        grafico();
        if (isCom==0)
          {
            try
            { 
              String portName = Serial.list()[2]; //Prima si accende l'esp32 con sensore, poi quello al pc
              myPort = new Serial(this, portName, 115200);
              isCom=1;
              stato=1;
              
             }
             catch (Exception e)
             {
                println("Non c'è seriale? "+e);
                isCom=0;
                stato=0;
             }
            }
            
            
            table = new Table();
            table.addColumn("i",Table.INT);
            table.addColumn("time",Table.FLOAT);
            table.addColumn("ax",Table.FLOAT);
            //grafico();                             //reinizia grafico
        
        
    }
    else  if (overCircle(200,750,50))    //rosso -> stop acquisizione
    {     
        stato=0;
    }
    else if (overCircle(300,750,50))    //load
    {
          stato=0;
          tableLoad = loadTable(nameFile, "header");  //servirebbe PATH automatico
          grafico();
          for (TableRow row : tableLoad.rows()) 
          {
            int i = row.getInt("i");
            float time = row.getFloat("time");
            float accX = row.getFloat("ax");
            println(i + " tempo " + time + " a " + accX);
            
            strokeWeight(2);  // Thicker
            stroke(0);
            line(i,yInizio, i, yInizio-accX*passoY); //istogramma
            lineaGraf();
            line(lastx,lasty,i,int(yInizio-accX*passoY));
            lastx=i;                      //memorizzo scorso punto in lastx e lasty
            lasty=int(yInizio-accX*passoY);
            lineaGrigia();            
          }   
      }
      else if (overCircle(400,750,50))
      {
        stato=0;
        saveTable(table, nameFile);    //il salva deve essere su un altro bottone
        
      }
      else if (mouseX>=xInizio)
      {
            //fill(0,0,0);
            textSize(40);
            if (mouseY<400)          //etichetta con scritta sopra o sotto punto in base a settore sopra o sotto
            {
              text("A: "+(yInizio-mouseY)/passoY,mouseX,mouseY-50);
            }
            else
            {
              text("A: "+(yInizio-mouseY)/passoY,mouseX,mouseY+50);
            }
            stroke(0);
            strokeWeight(16);
            point(mouseX,mouseY);
            strokeWeight(1);
        }
}
    
    
