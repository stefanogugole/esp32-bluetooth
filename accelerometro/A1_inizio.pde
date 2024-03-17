import processing.serial.*;                       
import controlP5.*; //tipi di controlli https://github.com/sojamo/controlp5   
import java.util.*;

/* DA FARE:
- sistemare cercamax al primo clic etichetta
- sistemare Dt salto
- creare le funzioni dirette e inverse per rappresentare su grafico ogni riga tabella

*/


//funzionamento accelerometro https://lastminuteengineers.com/mpu6050-accel-gyro-arduino-tutorial/

//https://forum.processing.org/two/discussion/1576/controlp5-basic-example-text-input-field.html

// controlp5 addcallback https://forum.processing.org/one/topic/controlp5-button-using-if-pressed-and-if-released.html
//ScrollableList porteCom;

ControlP5 cp5;
String url1;


//String nameFile="data/falco2.csv";

Serial myPort;  // Create object from Serial class


int xInizio=400;
int i=xInizio;
float accXInizio=9.81;
float time = 0;
float accX = 0;
float v=0;
float h=0;

JSONObject json=null;

String nomeVal()
{
  String nomeVal="";
  if (cp5.get(Textfield.class,"textInputVariable1").getText()!="")
        {
          nomeVal=cp5.get(Textfield.class,"textInputVariable1").getText();
        }
  else
  {
    nomeVal="ax";
  }
  return nomeVal;
}

String nomeVal2()
{
  String nomeVal="";
  if (cp5.get(Textfield.class,"textInputVariable2").getText()!="")
        {
          nomeVal=cp5.get(Textfield.class,"textInputVariable2").getText();
        }
  else
  {
    nomeVal="h";
  }
  return nomeVal;
}
  

int yInizio=400;
int yInizioCine=250;
int passoX=4;
int passoY=13;
int passoYLoad=10;
int passoV=50;
int passoH=100;

float lastx=xInizio;  //era int per il contatore
int lasty=yInizio;


float lastV=0;
float lastH=0;
float lastT=0;
float lastTA3=0;
float timeInizio=0;



Table table;
Table tableLoad;

int isCom=0; //è presente la porta seriale? Farei isCom=1 sei in finestra campionamento, 2 sei in Load, 3 in loadCinematiche
int verde=0; //è stato premuto il bottone campiona





void setup()
{
  size(1600, 800);
  
  try{
      printArray(Serial.list());

        myPort = new Serial(this, Serial.list()[0], 115200);  //metto in bottone "Campiona"

        isCom=1;

        //println("trovata COM");
        }
        catch (Exception e)
        {
          //println(" non c'è porta COM: "+e);
          isCom=0;
         
        }
  
  
  
  cp5 = new ControlP5(this);
  cp5.addTextfield("textInput_1").setPosition(10, 20).setSize(200, 50).setAutoClear(false).setColorBackground(0xffffffff).setFont(createFont("arial", 30)).setColor(0xff000000).setText("Gugole");
  //cp5.addBang("Submit").setPosition(240, 170).setSize(80, 40);         //non dovrebbe servire a nulla questo bottone
  cp5.addTextfield("textInputVariable1").setPosition(10, 80).setSize(50, 50).setAutoClear(false).setColorBackground(0xffffffff).setFont(createFont("arial", 30)).setColor(0xff000000).setText("ay");
  cp5.addTextfield("textInputVariable2").setPosition(60, 80).setSize(50, 50).setAutoClear(false).setColorBackground(0xffffffff).setFont(createFont("arial", 30)).setColor(0xff000000).setText("h");
  //cp5.addTextfield("textInputVariable3").setPosition(110, 130).setSize(100, 50).setAutoClear(false).setColorBackground(0xffffffff).setFont(createFont("arial", 30)).setColor(0xff000000);
  
  
  
  
  //DT
  cp5.addTextfield("textInputDT").setPosition(10, 160).setSize(70, 50).setAutoClear(false).setColorBackground(0xffffffff).setFont(createFont("arial", 30)).setColor(0xff000000).setText("DT: ");;
  cp5.addTextfield("textInputVariable3").setPosition(80, 160).setSize(100, 50).setAutoClear(false).setColorBackground(0xffffffff).setFont(createFont("arial", 30)).setColor(0xff000000);
  
  //
  //AxMAX
  cp5.addTextfield("textInputMaxAx").setPosition(10, 240).setSize(120, 50).setAutoClear(false).setColorBackground(0xffffffff).setFont(createFont("arial", 30)).setColor(0xff000000).setText("Max Ax: ");;
  cp5.addTextfield("textInputVariableMax").setPosition(130, 240).setSize(100, 50).setAutoClear(false).setColorBackground(0xffffffff).setFont(createFont("arial", 30)).setColor(0xff000000);
  
  //doce c'è ax o accX dobbiamo mettere il textInputVariable o default se vuoto!
  
  
  
  //
  
  
  Button b1 = cp5.addButton("Campiona").setPosition(210,20).setSize(100,50); 
  Button b2 = cp5.addButton("Stop").setPosition(310,20).setSize(100,50);
  Button b3 = cp5.addButton("Load").setPosition(410,20).setSize(100,50);
  Button b4 = cp5.addButton("Salva").setPosition(610,20).setSize(100,50);
  Button b5 = cp5.addButton("Load Cinematiche").setPosition(510,20).setSize(100,50);
 
  
  
  b1.addCallback(new CallbackListener() {  //start
    public void controlEvent(CallbackEvent theEvent) {
      if (theEvent.getAction()==ControlP5.ACTION_CLICK) {
        //cp5.get(Textfield.class,"textInput_1").setText("start");
        
        grafico();
        verde=1;    //premuto start
        isCom=1;
        i=xInizio;                             //si parte dall'inizio
        
        
        table = new Table();                  //tabella nuova ad ogni pressione
        table.addColumn("i",Table.INT);
        table.addColumn("time",Table.FLOAT);
        table.addColumn(nomeVal(),Table.FLOAT);    //Arduino spara ax?
        table.addColumn(nomeVal2(),Table.FLOAT);  //Arduino spara h?
      }
    }
  }
  );
  
  b2.addCallback(new CallbackListener() {  //stop
    public void controlEvent(CallbackEvent theEvent) {
      if (theEvent.getAction()==ControlP5.ACTION_CLICK) {
        verde=0;
        isCom=2;  //la table c'è, è come un load
      }
    }
  }
  );
  
  b3.addCallback(new CallbackListener() {  //Load    TOGLI "i" da table e files, non serve
    public void controlEvent(CallbackEvent theEvent) {
      if (theEvent.getAction()==ControlP5.ACTION_CLICK) {
          
          contatoreClick=0;  //usato in A4 per scrivere il max tra RIGHE ROSSE
          contatore=0;
          contatore2=0;
          
          cp5.get(Textfield.class,"textInputVariable3").setText("");  //azzero label con Dt RIGHE ROSSE
          cp5.get(Textfield.class,"textInputVariableMax").setText("");  //azzero label con MaxAx RIGHE ROSSE

          verde=0;
          isCom=2;  //stato load
          table = new Table();                  //tabella nuova ad ogni pressione
          //table = loadTable(nameFile, "header");  //servirebbe PATH automatico
          //cp5.get(Textfield.class,"textInput_1").getText(); 
          url1 = cp5.get(Textfield.class,"textInput_1").getText();
          try
          {
              table = loadTable("data/"+url1+".csv", "header");
              grafico();
              i=xInizio;
              for (TableRow row : table.rows()) 
              {
                
                //int i = row.getInt("i");  //non serve
                float time = row.getFloat("time");
                float accX = row.getFloat(nomeVal());
                //float h = row.getFloat("h");  //non serve
                //println(i + " tempo " + time + " a " + accX);
                
                
                if (i==xInizio)  //setto Dt iniziale per le "x" del grafico
                {
                  timeInizio=time;
                  lastx=xInizio;
                  lasty=yInizio;    
                }
                //se non è il primo loop, allora setto dopo lastx e last y
                
                strokeWeight(2);  // Thicker
                stroke(0);
                //line(i,yInizio, i, yInizio-accX*passoY); //istogramma
                int xAttuale=xInizio + int((time-timeInizio)/10);              //e se x troppo in là?
                line(xAttuale,yInizio, xAttuale, int(yInizio-accX*passoY)); //istogramma
                blu();
                line(lastx,lasty,xAttuale,int(yInizio-accX*passoY));
                //lastx=i;                      //memorizzo scorso punto in lastx e lasty
                lastx=xAttuale;
                lasty=int(yInizio-accX*passoY);
                grigio();   
                i=i+passoX;
              }   
          }
           catch (Exception e)
             {
             }
             
      }
    }
  }
  );
  
  b4.addCallback(new CallbackListener() {  //save
    public void controlEvent(CallbackEvent theEvent) {
      if (theEvent.getAction()==ControlP5.ACTION_CLICK) {
        verde=0;
        isCom=2;
        //saveTable(table, nameFile);    //il salva deve essere su un altro bottone
        url1 = cp5.get(Textfield.class,"textInput_1").getText();
        saveTable(table,"data/"+url1+".csv");
      }
    }
  }
  );
  
  b5.addCallback(new CallbackListener() {  //LoadCinematiche  
    public void controlEvent(CallbackEvent theEvent) {
      if (theEvent.getAction()==ControlP5.ACTION_CLICK) 
        {
          
          contatoreClick=0;  //usato in A4 per scrivere il max tra RIGHE ROSSE
          contatore=0;
          contatore2=0;
          
          cp5.get(Textfield.class,"textInputVariable3").setText("");  //azzero label con Dt RIGHE ROSSE
          cp5.get(Textfield.class,"textInputVariableMax").setText("");  //azzero label con MaxAx RIGHE ROSSE

          verde=0;
          isCom=3;  //stato loadCinematiche
          table = new Table();                  //tabella nuova ad ogni pressione
          //table = loadTable(nameFile, "header");  //servirebbe PATH automatico
          //cp5.get(Textfield.class,"textInput_1").getText(); 
          url1 = cp5.get(Textfield.class,"textInput_1").getText();
          try
          {
              table = loadTable("data/"+url1+".csv", "header");
              graficoCinematiche();
              i=xInizio;
              for (TableRow row : table.rows()) 
              {
                
                //int i = row.getInt("i");  //non serve
                float time = row.getFloat("time");
                float accX = row.getFloat(nomeVal());
                if (abs(accX)<0.4)          //elimino rumori
                {
                  accX=0;
                }
                
                //float h = row.getFloat("h");  //non serve
                //println(i + " tempo " + time + " a " + accX);
                
                
                if (i==xInizio)  //setto Dt iniziale per le "x" del grafico
                {
                  timeInizio=time;
                  lastx=xInizio;
                  lasty=yInizioCine;    
                }
                //se non è il primo loop, allora setto dopo lastx e last y
                
                strokeWeight(2);  // Thicker
                stroke(0);
                
                
                //plot acc
                
                int xAttuale=xInizio + int((time-timeInizio)/10);              //e se x troppo in là?
                line(xAttuale,yInizioCine, xAttuale, int(yInizioCine-accX*passoYLoad)); //istogramma
                blu();
                line(lastx,lasty,xAttuale,int(yInizioCine-accX*passoYLoad));
                //lastx=i;                      //memorizzo scorso punto in lastx e lasty
                lastx=xAttuale;
                lasty=int(yInizioCine-accX*passoYLoad);
                //!
                
                
                grigio();   
                i=i+passoX;
              }   
          }
           catch (Exception e)
             {
             }
             
      }
      
      
      
      
      
      /*{
        
          verde=0;
          isCom=3;  // stato loadCinematiche
          table = new Table();                  //tabella nuova ad ogni pressione
          //table = loadTable(nameFile, "header");  //servirebbe PATH automatico
          //cp5.get(Textfield.class,"textInput_1").getText(); 
          url1 = cp5.get(Textfield.class,"textInput_1").getText();
          try
          {
              table = loadTable("data/"+url1+".csv", "header");
              graficoCinematiche();
              
              //contorno iniziale
              int posizione=0;
              lastV=0;
              int lastx=xInizio;
              lasty=yInizio;
              lastV=0;
              lastH=0;
              lastT=0;
              timeInizio=0;
              //fine contorno          
              
              for (TableRow row : table.rows()) 
              {
                
                int i = row.getInt("i");
                float time = row.getFloat("time");
                float accX = row.getFloat(nomeVal());
                float h = row.getFloat(nomeVal2());

                if (abs(accX)<0.4)          //elimino rumori
                {
                  accX=0;
                }
                posizione=posizione + 1;
                if (posizione==1)
                {
                  timeInizio=time;    //al momento non serve
                  lastT=time;
                  lasty=500;
                  v=0;
                }
                println(i + " tempo " + time + " a " + accX);
                
                strokeWeight(2);  // Thicker
                stroke(0);
                v=lastV+round(accX)*(time-lastT)/1000;
                h=lastH+lastV*(time-lastT)/1000+0.5*round(accX)*(time-lastT)/1000*(time-lastT)/1000;
                println("velocità "+v+" dt "+(time-lastT));
                line(i,250, i, int(250-accX*passoYLoad)); //istogramma
                line(i,500,i,500 - round(v*passoV));
                line(i,750,i,750-round(h*passoH));
                
                blu();
                line(lastx,lasty,i,int(250-accX*passoYLoad));
                line(lastx,500-round(lastV*passoV),i,500-round(v*passoV));
                line(lastx,750-round(passoH*lastH),i,750-round(h*passoH));
                
                lastx=i;                      //memorizzo scorso punto in lastx e lasty
                lasty=int(250-accX*passoYLoad);
                lastV=v;
                lastH=h;
                println("velocità v"+v);
                lastT=time;
                grigio();        
              }   
          }
           catch (Exception e)
             {
               println("Errore in loadcinematiche : "+e);
             }
      }*/
    }
  }
  );
  
  
 background(255);
  
  /*
  ButtonBar b = cp5.addButtonBar("menu")
     .setPosition(0, 0)
     .setSize(400, 20)
     .addItem("Load",b1).addItem("Prova",b1);;
     //.addItems(split("a b c d e f g h i j"," "));
*/
  
  
  //url1 = cp5.get(Textfield.class,"textInput_1").getText();    dove serve
  
  //grafico();  //serve per inizializzare i pulsanti
}






void draw()  //questo è un loop come in Arduino, aggiorna solo per "Campiona" in tempo diretto e tiene il buffer "vuoto"
{
  

  try { 
        if ( isCom>0 && myPort.available() > 0)  //questo viene fatto sempre per scaricare il buffer
          { 
            
            //json=parseJSONObject(myPort.readStringUntil('\n'));  
            
            
            String val2=myPort.readStringUntil('\n');
            println(val2);
            if (val2!=null)
            {
             
              json = parseJSONObject(val2);      // read it and store it in json. Va fatto sempre se c'è dato, sennò riempie il buffer!!!
              
            }
            
            
          }
          else{
            //println("iscom 0 o non dati available");
          }
      }
      catch (Exception e)
      {
        //println("no dati o myport not available: "+ e);
      }

  /* le cose in tempo diretto/sincrone meglio farle qui al volo. Le cose asincrone le chiamiamo con eventi dai bottoni con i callback!! */
  
  if ( isCom==1 && verde==1 ) //bottone verde premuto e porta COM rilevata
  {    
      
      Campiona();    // -> A3 plotting
      //println("invocato campiona()");
      
   }
    
}
   
