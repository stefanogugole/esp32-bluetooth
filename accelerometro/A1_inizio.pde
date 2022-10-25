import processing.serial.*;                        //da gestire TABLE e iLast... che succede alla table dopo stop e start?

String nameFile="data/falco.csv";

Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port
int verde=0;
int xInizio=400;
int i=xInizio;

int yInizio=400;
int passoX=2;
int passoY=13;
int lastx=xInizio;
int lasty=yInizio;
Table table;
Table tableLoad;
int isCom=0; //è presente la porta seriale?





void setup()
{
  size(1600, 800);
  grafico();  //serve per inizializzare i pulsanti
}




void draw()
{
  
  cercaCom();  //ad ogni giro cerco di settare la porta COM seriale, se c'è
  
  
  if ( verde==1 && isCom==1 ) //bottone verde premuto e porta COM rilevata
  {    
      
      i=i+passoX;  //la i è la x sul grafico, che avanza nel tempo
      
      if ( i>=1550 )    //finito il grafico si reinizia e cancello la tabella
      {
        grafico();  //ri-inizializzo 
        table.clearRows();
      }
      
      parseAccData();
      
 
        
        
   }
    
}
   
