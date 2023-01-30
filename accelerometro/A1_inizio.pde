import processing.serial.*;                        //da gestire TABLE e iLast... che succede alla table dopo stop e start?
import controlP5.*; //tipi di controlli https://github.com/sojamo/controlp5   

//https://forum.processing.org/two/discussion/1576/controlp5-basic-example-text-input-field.html

// controlp5 addcallback https://forum.processing.org/one/topic/controlp5-button-using-if-pressed-and-if-released.html
ControlP5 cp5;
String url1;


String nameFile="data/falco2.csv";

Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port

int xInizio=400;
int i=xInizio;
float accXInizio=9.81;
float time = 0;
float accX = 0;

int yInizio=400;
int passoX=2;
int passoY=13;
int lastx=xInizio;
int lasty=yInizio;
float lastV=0;
float lastH=0;
float lastT=0;
float timeInizio=0;
Table table;
Table tableLoad;

int isCom=0; //è presente la porta seriale?
int verde=0;



void setup()
{
  size(1600, 800);
  cp5 = new ControlP5(this);
  cp5.addTextfield("textInput_1").setPosition(10, 20).setSize(200, 50).setAutoClear(false).setColorBackground(0xffffffff).setFont(createFont("arial", 30)).setColor(0xff000000);
  //cp5.addBang("Submit").setPosition(240, 170).setSize(80, 40);         //non dovrebbe servire a nulla questo bottone
  

  Button b1 = cp5.addButton("Campiona").setPosition(210,20).setSize(100,50); 
  Button b2 = cp5.addButton("Stop").setPosition(310,20).setSize(100,50);
  Button b3 = cp5.addButton("Load").setPosition(410,20).setSize(100,50);
  Button b4 = cp5.addButton("Salva").setPosition(610,20).setSize(100,50);
  Button b5 = cp5.addButton("Load Cinematiche").setPosition(510,20).setSize(100,50);
  
  /*
  b1.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      switch(theEvent.getAction()) {
        case(ControlP5.ACTION_PRESSED): cp5.get(Textfield.class,"textInput_1").setText("start"); break;  //ACTION_CLICK
        case(ControlP5.ACTION_RELEASED): cp5.get(Textfield.class,"textInput_1").setText("stop"); break;
      }
    }
  }
  );
  */
  
  b1.addCallback(new CallbackListener() {  //start
    public void controlEvent(CallbackEvent theEvent) {
      if (theEvent.getAction()==ControlP5.ACTION_CLICK) {
        //cp5.get(Textfield.class,"textInput_1").setText("start");
        grafico();
        verde=1;    //premuto tasto verde
        i=xInizio;                             //si parte dall'inizio
        table = new Table();                  //tabella nuova ad ogni pressione
        table.addColumn("i",Table.INT);
        table.addColumn("time",Table.FLOAT);
        table.addColumn("ax",Table.FLOAT);
      }
    }
  }
  );
  
  b2.addCallback(new CallbackListener() {  //stop
    public void controlEvent(CallbackEvent theEvent) {
      if (theEvent.getAction()==ControlP5.ACTION_CLICK) {
        verde=0;
      }
    }
  }
  );
  
  b3.addCallback(new CallbackListener() {  //Load
    public void controlEvent(CallbackEvent theEvent) {
      if (theEvent.getAction()==ControlP5.ACTION_CLICK) {
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
    }
  }
  );
  
  b4.addCallback(new CallbackListener() {  //stop
    public void controlEvent(CallbackEvent theEvent) {
      if (theEvent.getAction()==ControlP5.ACTION_CLICK) {
        verde=0;
        //saveTable(table, nameFile);    //il salva deve essere su un altro bottone
        url1 = cp5.get(Textfield.class,"textInput_1").getText();
        saveTable(table,"data/"+url1+".csv");
      }
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




void draw()
{
  
  cercaCom();  //ad ogni giro cerco di settare la porta COM seriale, se c'è
  
  
  
  /* le cose in tempo diretto/sincrone meglio farle qui al volo. Le cose asincrone le chiamiamo con eventi dai bottoni con i callback!! */
  
  if ( verde==1 && isCom==1 ) //bottone verde premuto e porta COM rilevata
  {    
      
      i=i+passoX;  //la i è la x sul grafico, che avanza nel tempo
      
      if ( i>=1550 )    //finito il grafico si reinizia e cancello la tabella
      {
        grafico();  //ri-inizializzo 
        table.clearRows();
      }
      
      
      
      
      
      parseAccData();
      /*
      try{
        
    
    val = split(val , ':' )[1];
    accX=float(splitTokens(val)[0])-accXInizio;  //(round)
    TableRow newRow = table.addRow();
    newRow.setInt("i",i);
    newRow.setFloat("time", time);
    newRow.setFloat("ax",accX);    //se premi stop salvi il file
    println(accX);
    //plotGraficoAx(i,yInizio,accX);
    
    if (abs(accX) < 10000)
    {
      strokeWeight(2);  // Thicker
      line(i,yInizio, i, yInizio-accX*passoY); //istogramma
      blu();
      line(lastx,lasty,i,int(yInizio-accX*passoY));
      lastx=i;                      //memorizzo scorso punto in lastx e lasty
      lasty=int(yInizio-accX*passoY);
      float tmp=0;
      tmp=lastH+lastV*(0.103)+0.5*(round(accX))*0.103*0.103;  //tempi diversi!! 0.103 non va bene
      //point(i,yInizio-tmp*20);  //da sistemare quei 103 millisecondi
      lastV=lastV+(round(accX))*0.103;
      point(i,yInizio-lastV*100);
      lastH=tmp;
      
      grigio();
    }
  }
  catch (Exception e)
  {
    //println("errore parsing "+e);
  }
      
      
      
      */
      
      
      
      
 
        
        
   }
    
}
   