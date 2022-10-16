import processing.serial.*;
Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port
int stato=0;
int i=400;
int passoX=5;
int passoY=20;
int lastx=i;
int lasty=400;
Table table;
Table tableLoad;

void mousePressed()
{
    if (overCircle(100,750,50))    //verde -> parte acquisizione
    {
      stato=1;
    }
    else
    {
      if (overCircle(200,750,50))    //rosso -> stop acquisizione e salva su falco.csv nella cartella acquisizioni
      {
        stato=0;
        saveTable(table, "falco.csv");
      }
      else
      {
        if (overCircle(300,750,50))
        {
          stato=0;
          
          tableLoad = loadTable("falco.csv", "header");  //servirebbe PATH automatico
          grafico();
          for (TableRow row : tableLoad.rows()) 
          {
            int i = row.getInt("i");
            float time = row.getFloat("time");
            float accX = row.getFloat("ax");
            println(i + " tempo " + time + " a " + accX);
            
            strokeWeight(2);  // Thicker
            stroke(0);
            line(i,400, i, 400-accX*passoY); //istogramma
            lineaGraf();
            line(lastx,lasty,i,int(400-accX*passoY));
            lastx=i;                      //memorizzo scorso punto in lastx e lasty
            lasty=int(400-accX*passoY);
            lineaGrigia();
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
          }
          
          
        }
        else{
            fill(0,0,0);
            textSize(40);
            if (mouseY<400)          //etichetta con scritta sopra o sotto punto in base a settore sopra o sotto
            {
              text("A: "+(400-mouseY)/passoY,mouseX,mouseY-50);
            }
            else
            {
              text("A: "+(400-mouseY)/passoY,mouseX,mouseY+50);
            }
            stroke(0);
            strokeWeight(16);
            point(mouseX,mouseY);
            strokeWeight(1);
        }
      }
    }
    
    
}




void setup()
{
  // I know that the first port in the serial list on my mac
  // is Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  try
  {
  String portName = Serial.list()[2]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 115200);
  }
  catch (Exception e){
    println("manca Seriale? "+e);
  }
  size(1600, 800);
  grafico();
  
  table = new Table();
  table.addColumn("i",Table.INT);
  table.addColumn("time",Table.FLOAT);
  table.addColumn("ax",Table.FLOAT);
  
  



}




void draw()
{
  
  if ( myPort.available() > 0)
  {  // If data is available,
    
      val = myPort.readStringUntil('\n');         // read it and store it in val
      if ( stato==1 )
      {    
          
          i=i+passoX;
          
          if ( i>=1550 )    //finito il grafico
          {
            i=400;
            grafico();  //ri-inizializzo
            
          }
          
          
          
          //println(val[2:val.length()]);
          float time = 0;
          float accX = 0.0;
          
          try{
            
            /*time = float(split( val, ':' )[0]);
            val = split( val , ':' )[1];
            accX = float(val.split(val , '\n')[0]);
            println(time);
            */
            time = float(split(val , ':' )[0]);
            val = split(val , ':' )[1];
            accX=float(splitTokens(val)[0]);
            TableRow newRow = table.addRow();
            newRow.setInt("i",i);
            newRow.setFloat("time", time);
            newRow.setFloat("ax",accX);    //se premi stop salvi il file
            println(accX);
            
            strokeWeight(2);  // Thicker

            line(i,400, i, 400-accX*passoY); //istogramma
            lineaGraf();
            line(lastx,lasty,i,int(400-accX*passoY));
            lastx=i;                      //memorizzo scorso punto in lastx e lasty
            lasty=int(400-accX*passoY);
            lineaGrigia();
            
          }
          catch (Exception e)
          {}
        }
          
      }

  //line(i,0, i, float(val.substring(3,val.length()-2))); 
}
