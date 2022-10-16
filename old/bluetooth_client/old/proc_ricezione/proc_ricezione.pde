import processing.serial.*;
Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port


void setup()
{
  // I know that the first port in the serial list on my mac
  // is Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[2]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 115200);
    size(1600, 800);

}

int i=0;

void draw()
{
  if ( myPort.available() > 0) 
  {  // If data is available,
  val = myPort.readStringUntil('\n');         // read it and store it in val
      
      
      i=i+1;
      
      //println(val[2:val.length()]);
      String list = "";
      
      try{
        
        list = split( val, ':' )[1];
        list = split( list , ',' )[0];
        println(float(list));
        line(2*i,400, 2*i, 400-float(list)*20);
        
      }
      catch (Exception e)
      {}
      
}
  //line(i,0, i, float(val.substring(3,val.length()-2))); 
}
