// SHM
int N=10000;
float [] x_pts=new float[N];
float [] y_pts=new float[N];
int [] col=new int[N];

float min_x;
float max_x;
float min_y;
float max_y;

float mx=0;
float my=0;
  
float m=0.1;    // 100 grams
float D=0;
float k=-0.05;
float dt=0.05; //0.008; // Advance in steps of 5ms

float w=sqrt(abs(k/m));
  
float x=0.0;  // Pull string back to 10cm
float v=0.0;  // let go, initial velocity is 0
float t=0;    // time=0;

int  count=0;

void setup()
{  
  size(800, 600);
  background(255,255,255);
  strokeWeight(1);
  
  // Calculate the attractor and min max values once
  //float x=1,y=10,z=10;
 
  for(int i=0;i<N;i++)
  {

  float kick=100*abs(cos(0.236*w*t)); // float kick=0; for normal SHM
    v=v+(((D*v)+(k*x)+kick)/m)*dt;
    x=x+(v*dt);
   
  //https://judithcurry.com/2014/05/30/the-astonishing-math-of-michael-ghils-climate-sensitivity/
  // float P = 10, R = 28, B = 8/3;  // Lorentz Attractor
  // float dx=P*(y -x)*dt;
  // x=x+dx;
  
  // float  dy=((R*x)-y-(x*z))*dt;
  // y=y+dy;
 //  float  dz=((x*y)-(B*z))*dt;
  // z=z+dz;
    
   //x_pts[i]=y;
   //y_pts[i]=z;
   
   x_pts[i]=x;
   y_pts[i]=v;
   
   t=t+dt;
  }
  
  min_x=x_pts[0];  // Find max and min
  max_x=x_pts[0];
  min_y=y_pts[0];
  max_y=y_pts[0];
  for(int i=0;i<N;i++)
  {
    if(x_pts[i]>max_x) max_x=x_pts[i];
    if(x_pts[i]<min_x) min_x=x_pts[i];
    
    if(y_pts[i]>max_y) max_y=y_pts[i];
    if(y_pts[i]<min_y) min_y=y_pts[i];
  }
  
}

void draw()
{
  background(255,255,255);
  
  // Frame the plots
  stroke(0,0,255);
  noFill();
  strokeWeight(3);
  float fx=250,fy=20,fw=520,fh=520;
  rect(fx,fy,fw,fh);
  rect(20,fy,180,fh);
  textSize(20);
  text("Position",fx+(fw/2)-50,fy+fh+30);
  
  float x=fx-10;
  float y=60+fy+fh/2;
  pushMatrix();
  translate(x,y);
  rotate(-HALF_PI);
  translate(-x,-y);
  text("Velocity", x,y);
  popMatrix();
    
  strokeWeight(1);
  
  // When mouse is down highlight 100 iterations that pass through
  if(mousePressed)
  {
  mx=mouseX;
  my=mouseY;
  int flag=0;
  for(int i=0;i<N;i++)
  {
     col[i]=0;
     
     float screen_x=fx+(fw*(x_pts[i]-min_x)/(max_x-min_x));
     float screen_y=fy+(fh*(y_pts[i]-min_y)/(max_y-min_y));
     
     if ((pow(mx-screen_x,2)+pow(my-screen_y,2))<225) 
     {
       flag=100;
     }
     
     if(flag>0)
     {
      flag--;
      col[i]=1;
     }
  }
  
  }
  fill(0,255,0);
  ellipse(mx,my,30,30);

  
  for(int i=1;i<N;i++)
  {
    if(col[i]==0)
    {
       stroke(255,0,0);
      if(col[i-1]==1)
      {
          fill(0,255,0);
          ellipse(fx+(fw*(x_pts[i-1]-min_x)/(max_x-min_x)),fy+(fh*(y_pts[i-1]-min_y)/(max_y-min_y)),10,10);
      }
    }
    else
    {
      stroke(0,255,0);
    }
    line(fx+(fw*(x_pts[i-1]-min_x)/(max_x-min_x)),fy+(fh*(y_pts[i-1]-min_y)/(max_y-min_y)),fx+(fw*(x_pts[i]-min_x)/(max_x-min_x)),fy+(fh*(y_pts[i]-min_y)/(max_y-min_y)));
  }
  
  rect(90,fy+2+(fh-44)*(x_pts[count]-min_x)/(max_x-min_x),40,40);
 
  fill(0,0,255);
  ellipse(fx+(fw*(x_pts[count]-min_x)/(max_x-min_x)),fy+(fh*(y_pts[count]-min_y)/(max_y-min_y)),10,10);
  

  count++;
  if(count>=N) count=0;
}   //Redraw the new screen
