class Data { //turns the csv files into a form that's easier to work with
  Table raw;
  TableRow year;
  TableRow month;
  TableRow date;
  TableRow altitude;
  TableRow summary;
  TableRow extra_1;
  TableRow extra_2;
  
  float[][] da_array;
  
  int altmax = 0;
  int hash = 0;
  
  Data(String source) {
    raw = loadTable(source); //csv is formatted prior into an appropriate format
    year = raw.getRow(1);
    month = raw.getRow(2);
    date = raw.getRow(3);
    altitude = raw.getRow(4);
    summary = raw.getRow(5);
    extra_1 = raw.getRow(6);
    extra_2 = raw.getRow(7);
    
    da_array = new float[2][300]; //array that stores the alt recrod in a certain year (i.e. max alt attained so far by this mode of transport) - used to graph static points
    for (int i=0;i<300;i++) {
      if ((i+1750)==(year.getInt(hash))) {
        if ((altitude.getInt(hash))>altmax) {
          altmax = altitude.getInt(hash); //the altitude associated with the year changes each time a record-breaking year is reached
        }
        hash++;
      }
      da_array[0][i] = i+1750;//stores the year
      da_array[1][i] = altmax;//and the altitude (with default 0)
    }
  }
  
  TableRow getYear() { //if many rows, then instead of getting row by name, get row by index number
    return year;
  }
  
  TableRow getMonth() {
    return month;
  }
  
  TableRow getDate() {
    return date;
  }
  
  TableRow getAltitude() {
    return altitude;
  }
  
  TableRow getSummary() {
    return summary;
  }
  
  TableRow getExtra_1() {
    return extra_1;
  }
  
  TableRow getExtra_2() {
    return extra_2;
  }
  
  float[][] getDa() {
    return da_array;
  }
}