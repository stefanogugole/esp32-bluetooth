void parseData()
{
  float time = 0;
  float accX = 0.0;
  
  try{
    time = float(split(val , ':' )[0]);
    val = split(val , ':' )[1];
    accX=float(splitTokens(val)[0]);
    TableRow newRow = table.addRow();
    newRow.setInt("i",i);
    newRow.setFloat("time", time);
    newRow.setFloat("ax",accX);    //se premi stop salvi il file
    println(accX);
    plotGraficoAx(i,yInizio,accX);
  }
  catch (Exception e)
  {
    //println("errore parsing "+e);
  }
    
}

void plotGraficoAx(int i,int yInizio, float accX)
{
  strokeWeight(2);  // Thicker
  line(i,yInizio, i, yInizio-accX*passoY); //istogramma
  lineaGraf();
  line(lastx,lasty,i,int(yInizio-accX*passoY));
  lastx=i;                      //memorizzo scorso punto in lastx e lasty
  lasty=int(yInizio-accX*passoY);
  lineaGrigia();
}
