ArrayList <Mountains> mountains=new ArrayList<Mountains>();

//snow code
int snowNo= 200; //snow flakes on screen
int [] snowSize= new int[snowNo];
float [] xsnow= new float[snowNo];
float [] ysnow= new float[snowNo];

String[] mountainsArr = { 
  "0", 
  "K2", "Kangchenjunga", "Lhotse", "Makalu", 
  "Cho Oyu", "Dhaulagiri", "Manaslu", "Nanga Parbat", 
  "Annapurna", "Gasherbrum 1", "Broad Peak", "Gasherbrum 2", 
  "Shishapangma"
};





void setup()
{

  size(500, 500);

  smooth();

  loadMountains();

  //setup() code for snow



  for (int i = 0; i < snowNo; i++) 
  {
    snowSize[i] = round(random(1, 6)); //selects random size, then rounds to closest whole number
    xsnow[i] = random(0, width);
    ysnow[i] = random(0, height);
  }
}

void loadMountains()
{
  String[] lines= loadStrings("8000s_Deaths_dataset.csv");

  for (int i=0; i<lines.length; i++)
  {
    Mountains mountain= new Mountains(lines[i]);
    mountains.add(mountain);
  }
  println("got here mountains size is " + mountains.size());
}

void drawLineGraph()                                            //-----0 Graph-----//
{
  //background(25);
  //make a border
  float border = width * 0.1f;


  fill(255);

  stroke(255);


  //set the graph constraints
  float graphRange =  (width - (border * 2.0f));
  float dataRange = Float.MIN_VALUE;
  //find the maximum amount 
  for (Mountains mountain : mountains)
  {
    if (mountain.amount > dataRange)
    {
      dataRange = mountain.amount;
    }
  }

  float lineWidth = graphRange / (float) (mountains.size() - 1);

  float scale = graphRange / dataRange;

  for (int i = 1; i < mountains.size (); i++)
  {
    Mountains mountain = mountains.get(i - 1);
    Mountains mountain1 = mountains.get(i);
    float x1 = border + ((i - 1) * lineWidth);
    float x2 = border + (i * lineWidth);
    float y1 = (height - border) - (mountain.amount) * scale;
    float y2 = (height - border) - (mountain1.amount) * scale;
    line(x1, y1, x2, y2);
  }

  Mountains mountain2 = mountains.get(0);
  stroke(240, 240, 255);
  //horizontal axis
  line(border, (height - border) - (mountain2.amount * scale), width - border, (height - border) - (mountain2.amount * scale));
  //vertical axis
  line(border, border, border, (height - border) - (mountain2.amount * scale) + 1);


  int textS=12; //Change Depending on screensize

  for (int i=0; i<16; i++)//'No of deaths, vertical axis numbers
  {
    float mY=map(i, 0, 15, height-border, border);
    textSize(textS);

    if (i<=9)
    {
      text("  "+i+" -", border/2, mY);
      fill(255);
    } else
    {
      text(i+" -", border/2, mY);
      fill(255);
    }
  }
  boolean MntName=true;
  for (int i=1; i<14; i++)
  {
    float mX=map(i, 0, 14, border, width-border);

    line(mX, height-border, mX, (height-border)+25);

    if (MntName==true)

    {
      textSize(textS); 
      text(mountainsArr[i], mX, height-border/2);
      textAlign(CENTER);
      fill(255);
      MntName=false;
    } else if (MntName==false)
    {
      textSize(textS); 
      text(mountainsArr[i], mX, height-border/3);
      textAlign(CENTER);
      fill(255);
      MntName=true;
    }

    if (i==6)
    {
      text("Mountains", mX, height-border/5);
    }
  }
}

void drawFunGraph()                                        //-----1 Graph-----//
{
  frameRate(1);
  float border = width * 0.1f;
  int textS=12;
  int mNo=1;


  fill(255);

  stroke(255);


  //set the graph constraints
  float graphRange =  (width - (border * 2.0f));
  float dataRange = Float.MIN_VALUE;
  //find the maximum amount 
  for (Mountains mountain : mountains)
  {
    if (mountain.amount > dataRange)
    {
      dataRange = mountain.amount;
    }
  }

  float lineWidth = graphRange / (float) (mountains.size() );

  //float scale = graphRange / dataRange;

  int timer= round(random(1, 13));
  
  
//  for(int i=1;i<13;i++)
//  {
//    mNo=i;
//    
//    if(mNo==12)
//    {
//      i=1;
//    }
//  }

  stroke(255);



  for (int i = 1; i < mountains.size (); i++)
  {

    Mountains mountain = mountains.get(i);



    float mountMap=map(timer, 0, 14, height/2, mountains.size());

    for (int w=0; w<width; w+=10)
    {
      stroke(255);
      line(width/2, mountMap, w, height/2);     //draws mountain
    }



    
  }

  for (int m=height/2; m<height; m*=1.01)
  {
    //stroke(0, 125, 0);
    line(0, m, width, m);//draws ground
  }


  fill(0);
  rect(-5, 300, width+10, 100);

  textSize(32);
  fill(255);
  text(timer, (width/2), (height/2)+100);
  textSize(16);
  text("Deaths:", (width/2)-50, (height/2)+80);
  
  textSize(textS+8);
    fill(255);
    text(mountainsArr[timer], width/2, height/2+140);

  fill(0);
  rect(-5, height-25, width+100, 50);
}

boolean which= true;

void draw()
{



  //  PImage img;
  //  img= loadImage("bg.jpg");
  //  background(img);
  background(0);

  if (keyPressed)
  {
    if (key == '0')
    {
      which = true;
    }
    if (key == '1')
    {
      which = false;
    }
  }
  if (which == true)//                             ---------FIRST GRAPH DRAW----------
  {
    Mountains mountain3 =  mountains.get(3); 
    Mountains mountain4 =  mountains.get(8); 
    //background(225);
    drawLineGraph();

    //draw() code for snow
    for (int i = 0; i < xsnow.length; i++) 
    {
      ellipse(xsnow[i], ysnow[i], snowSize[i], snowSize[i]);

      ysnow[i] += snowSize[i] ; //size of the snowflake effects the speed of it

      if (ysnow[i] > height + snowSize[i])  
      {
        ysnow[i] = snowSize[i];
      }
    }
  } else if (which==false)//                                     --------SECOND GRAPH DRAW---------
  {
    drawFunGraph();

    //draw() code for snow
    //    for (int i = 0; i < xsnow.length; i++) 
    //    {
    //      ellipse(xsnow[i], ysnow[i], snowSize[i], snowSize[i]);
    //
    //      ysnow[i] += snowSize[i]*5 ; //size of the snowflake effects the speed of it
    //
    //      if (ysnow[i] > height + snowSize[i])  
    //      {
    //        ysnow[i] = snowSize[i]*3;
    //      }
    //    }
  }


}

