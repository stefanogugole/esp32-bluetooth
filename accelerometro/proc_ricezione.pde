import processing.serial.*;
Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port
int stato=0;
int xInizio=400;
int i=xInizio;
int yInizio=400;
int passoX=5;
int passoY=13;
int lastx=xInizio;
int lasty=yInizio;
Table table;
Table tableLoad;
int isCom=0; //è presente la porta seriale




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
    isCom=1;
    table = new Table();
    table.addColumn("i",Table.INT);
    table.addColumn("time",Table.FLOAT);
    table.addColumn("ax",Table.FLOAT);
  }
  catch (Exception e){
    println("manca Seriale? "+e);
    isCom=0;
  }
  size(1600, 800);
  grafico();
  
  
  
}




void draw()
{
  if (isCom==1)
  {
      if ( myPort.available() > 0)
      {  // If data is available,
          
              val = myPort.readStringUntil('\n');         // read it and store it in val
          
          if ( stato==1 )
          {    
              
              i=i+passoX;
              
              if ( i>=1550 )    //finito il grafico
              {
                i=xInizio;
                grafico();  //ri-inizializzo
                table.clearRows();
                
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
    
                line(i,yInizio, i, yInizio-accX*passoY); //istogramma
                lineaGraf();
                line(lastx,lasty,i,int(yInizio-accX*passoY));
                lastx=i;                      //memorizzo scorso punto in lastx e lasty
                lasty=int(yInizio-accX*passoY);
                lineaGrigia();
                
              }
              catch (Exception e)
              {}
            }
              
          }
      }

}
