



ArrayList <Mountains> mountains=new ArrayList<Mountains>();

import controlP5.*;

ControlP5 cp5;
int beans = 1;
int col = color(255);

boolean toggleValue = false;

//snow code
int snowNo= 200; //snow flakes on screen
int [] snowSize= new int[snowNo];
float [] xsnow= new float[snowNo];
float [] ysnow= new float[snowNo];

String[] mountainsArr = {       //Array for the mountain names
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

  loadMountains(); //loads Mountain class

    cp5 = new ControlP5(this);//setup() code for toggle function


  cp5.addToggle("click_2_John")
    .setPosition(width-(width/5), height/10)
      .setSize(50, 20)
        .setValue(true)
          .setMode(ControlP5.SWITCH);



  //setup() code for snow
  for (int i = 0; i < snowNo; i++) //Global snow loop for all snow
  {
    snowSize[i] = round(random(1, 6)); //selects random size, then rounds to closest whole number
    xsnow[i] = random(0, width);//random snow size
    ysnow[i] = random(0, height);
  }
}
float CircleThird=0; //used later to change angle of circles in menu
float CircleAngle=0;
int option=1;
String[] options= { 
  "0", 
  "Line Graph", "Radar", "Mountain Range" //array for graph options names
};
void drawMenu()                              //-----MENU-----
{

  //background(0);
  //Need 3 separate push/popMatrix to ensure circles rotate correctly
  //Circle 1
  pushMatrix();
  translate(width/2, height/2); //circles rotate around centre of screen
  rotate(radians(CircleAngle)); //rotates by 'Circle Angle'
  fill(128, 255, 0);
  noStroke();
  ellipse(CircleThird, height/4, width/5, height/5);
  fill(0);
  ellipse(CircleThird, height/4, width/6, height/6);
  fill(128, 255, 0);
  ellipse(CircleThird, height/4, width/7, height/7);
  fill(255);
  stroke(255);
  popMatrix();
  //Circle 2
  pushMatrix();
  translate(width/2, height/2);
  rotate(radians(CircleAngle+120));
  fill(128, 255, 0);
  noStroke();
  ellipse(CircleThird, height/4, width/5, height/5);
  fill(0);
  ellipse(CircleThird, height/4, width/6, height/6);
  popMatrix();
  //Circle 3
  pushMatrix();
  translate(width/2, height/2);
  rotate(radians(CircleAngle+240));
  fill(128, 255, 0);
  noStroke();
  ellipse(CircleThird, height/4, width/5, height/5);
  fill(0);
  ellipse(CircleThird, height/4, width/6, height/6);
  popMatrix();

  //menu text
  textSize(16);
  fill(255);
  String s="Select desired version with spacebar\n then press y to select.\nPress r to return to menu:";
  fill(255);
  textSize(24);
  textAlign(CENTER);
  text(option, width/2, height/2);
  text(s, width/2, 30);
  text(options[option], width/2, height-height/15);
}


void loadMountains() //loading in data from .csv file for use in graphs
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
  frameRate(60);
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

  for (int i = 1; i < mountains.size (); i++)//draws graph line according to data
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


  int textS=8;

  for (int i=0; i<16; i++)//'No of deaths, vertical axis numbers
  {
    float mY=map(i, 0, 15, height-border, border);
    textSize(textS);

    if (i<=9) //vertical numbers
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
  for (int i=1; i<14; i++)  //staggers mountain names to ensure all fit on screen
  {
    float mX=map(i, 0, 14, border, width-border);

    line(mX, height-border, mX, (height-border)+10);

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
      textSize(12);
      text("Mountains", mX, height-border/5);
    }
  }
}

boolean CircleShow=false;
float opacity;
int beepdiameter=0;
float xBar=width/2;
float yBar=height/2;


void drawSonarGraph()                                      //------2 Graph-------//
{
  frameRate(60);
  int radarDia=450;
  int radius=radarDia/2;



  noStroke();
  for (int i=radarDia; i>0; i-=100) //draws radar circles
  {
    int inner=i/30;
    fill(0, 200, 0);
    ellipse(250, 250, i, i);
    fill(0);
    ellipse(250, 250, i-inner, i-inner);
  }

  stroke(0, 200, 0);
  float gline=(width-450)/2;
  line(gline, height/2, width-gline, height/2); //radar lines
  line(width/2, gline, width/2, height-gline);


  fill(255);
  ellipse(250, 250, 10, 10);


  int x=270;
  for (int i=2; i<16; i+=2) //number of deaths measure on radar
  { 

    fill(255);
    textSize(16);
    text(i, x, x);
    x+=20;
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

  for (Mountains mountain : mountains)//find the maximum amount 
  {
    if (mountain.amount > dataRange)
    {
      dataRange = mountain.amount;
    }
  }

  float lineWidth = graphRange / (float) (mountains.size() );

  int timer= round(random(1, 13)); //randomizes order mountains come in


  stroke(255);



  for (int i = 1; i < mountains.size (); i++)
  {

    Mountains mountain = mountains.get(i);




    float mountMap=map(timer, 0, 14, height/2, mountains.size()); //maps mountain diagram to fit on screen


    for (int w=0; w<width; w+=10)
    {

      stroke(255);
      line(width/2, mountMap, w, height/2);     //draws mountain
    }
  }

  for (int m=height/2; m<height; m*=1.01)
  {
    int groundc=255;
    stroke(groundc);
    line(0, m, width, m);//draws ground
    groundc-=25;
  }


  fill(0);
  rect(-5, 300, width+10, 100);

  textSize(32);
  fill(255);
  text(timer, (width/2), (height/2)+100); //displays number of deaths for displayed mountain
  textSize(16);
  text("Deaths:", (width/2)-50, (height/2)+80);

  textSize(textS+8);
  fill(255);
  text(mountainsArr[timer], width/2, height/2+140); //displays mountain name

  fill(0);
  rect(-5, height-25, width+100, 50);
}

void click_2_John(boolean theFlag) {
  if (theFlag==true) {

    //println("toggled the yoke");
    beans = 0;
    println("john who?");
  } else 
  {
    beans = 1;
    col = color(100);
    println("john snow!");
  }
  //println("a toggle ");
}

void snow()
{
  for (int i = 0; i < xsnow.length; i++) 
  {
    ellipse(xsnow[i], ysnow[i], snowSize[i], snowSize[i]);

    ysnow[i] += snowSize[i] ; //size of the snowflake effects the speed of it

    if (ysnow[i] > height + snowSize[i])  
    {
      ysnow[i] = snowSize[i];
    }
  }
}

int which= 0;
float angle;

int counter=0;


float angledivide=360/14;
float angledividecount=angledivide;


void draw()
{
background(0);

  //draw() calls snow
  if (beans == 1)
  {
    snow();
  }

  textAlign(CENTER);
  textSize(18);
  fill(255, 0, 0);
  if(which!=0)
  {
  text("R to Return:", width-100, 25);
  }

  if (keyPressed) //controls to navigate through graphs
  {
    if (key == 'r')
    {
      which = 0;
    }
    if (key == 'y'&&option==1)
    {
      which = 1;
    }
    if (key=='y'&&option==2)
    {
      which = 2;
    }
    if (key=='y'&&option==3)
    {
      which = 3;
    }
  }
  if (which == 0)//                             ---------MENU SCREEN----------
  {
    drawMenu();
    frameRate(60);
  }
  if (which == 1)//                             ---------FIRST GRAPH DRAW----------
  {
    Mountains mountain3 =  mountains.get(3); 
    Mountains mountain4 =  mountains.get(8); 
    //background(225);

    drawLineGraph();
  }
  if (which==3)//                                     --------THIRD GRAPH DRAW---------
  {
    drawFunGraph();
  }
  if (which==2)//                                     --------SECOND GRAPH DRAW---------
  {
    drawSonarGraph();

    float radius =450/2;

    float lineX=250 + cos(radians(angle))*(radius);//
    float lineY=250 + sin(radians(angle))*(radius);// changes radar line to move around the circle

    float radarMap=round(map(counter, 0, 14, height/2, mountains.size()));

    strokeWeight(2);
    stroke(0, 255, 0);
    line(250, 250, lineX, lineY);//moving line
    stroke(0, 255, 0, 50);
    line(250, 250, lineX-8, lineY-8);// moving line shadow (not very noticable/ useful! :D
    angle+=.5;//updates moving line's position
    textSize(12);
    text(angle, width/10, height-(height/10)-30);//gives location of line

    //----



    if (angle==angledividecount)//ensures mountain beep happens when line is in right position
    {
      CircleShow=true;
      counter++;
      angledividecount+=angledivide;
      if (counter==14)
      {
        counter=0;
      }
    }



    noStroke();
    fill(255);

    if (CircleShow) //the beep
    {

      int[] mountNum =new int[13];

      for (int i=0; i<13; i++)
      {
        mountNum[i]=i++;
      }

      float locationMap=map(counter, 0, 14, 0, 360);//divides radar into amount of mountains

      text(locationMap, (width/10)+10, height-(height/10)+20);
      text(mountainsArr[counter], width-50, height-50);
      text(counter, width-50,height-25);
      pushMatrix();//used to allow beep to orbit the radar
      translate(250, 250);
      rotate(radians(locationMap));//moves beep to next location
      fill(255, 2, 2, opacity);
      ellipse(radarMap, 0, beepdiameter, beepdiameter);//the beep
      text(radarMap, width/10, height-(height/10)+10);

      //            Beep beep=new Beep();
      //            beep.sound();




      fill(0);
      beepdiameter +=2;//makes beep 'grow'
      opacity-=4;// makes beep 'fade out'
      if (opacity<=0) //'refreshes' beep when invisible
      {
        CircleShow=false; // end
        opacity=255;
        beepdiameter=0;
      }
      popMatrix();
    }
    //    if (lineX==xBar)
    //    {
    //      CircleShow=true;
    //    }
    textSize(12);
    fill(255);
    text(lineX, width/10, height-(height/10));
    text(lineY, width/10, height-(height/10)-20);
  }
}



void keyPressed()
{

  if (key==' ')//for menu, rotates to next option
  {


    CircleAngle+=120;
    option++;


    if (CircleAngle==360)//ensures menu can 'loop' (would continue adding to degrees making it only able to go through the options once
    {
      CircleAngle=0;
    }
    if (option==4)//centre option indicator stays accurate
    {
      option=1;
    }
  }
}

