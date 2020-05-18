import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// A list for all of our rectangles
ArrayList<Box> boxes;

Box2DProcessing box2d;  


void setup() 
{
  size(600,300);
  smooth();
  frameRate(5);
  
   // Initialize and create the Box2D world
  box2d = new Box2DProcessing(this);  
  
  box2d.createWorld();
  
  // Turn on collision listening!
  box2d.listenForCollisions();
  
  // Create ArrayLists
  boxes = new ArrayList<Box>();
  
  
  Box p = new Box(400,height-52,30,30,0);
  boxes.add(p);
  
  p.body.setAngularVelocity(-4);
  p.body.setLinearVelocity(new Vec2(-30, 10));
  
  p = new Box(40,height-52,30,30,0);
  boxes.add(p);
  
  p.body.setAngularVelocity(-4);
  p.body.setLinearVelocity(new Vec2(30, 10));
}

void draw()
{
  background(255);

  // We must always step through time!
  box2d.step(); 

  // Display all the boxes
  for (Box b: boxes) 
  {
    b.display();
  }
}



// A rectangular box
class Box 
{
  //  Instead of any of the usual variables, 
  //  we will store a reference to a Box2D Body
  Body body;      

  float w,h;

  Box(float x, float y, float w_,float h_, int type) 
  {
    w = w_;
    h = h_;

    // Build Body
    BodyDef bd = new BodyDef();      
    if(type==0)
    {
     bd.type = BodyType.DYNAMIC; // Was DYNAMIC
    }
    else
    {
      bd.type = BodyType.STATIC; 
    }
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    body = box2d.createBody(bd);


   // Define a polygon (this is what we use for a rectangle)
    PolygonShape sd = new PolygonShape();
    // Box2D considers the width and height of a
    // rectangle to be the distance from the
    // center to the edge (so half of what we
    // normally think of as width or height.)
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);  
    sd.setAsBox(box2dW, box2dH);            
                                                   
    // Define a fixture
    FixtureDef fd = new FixtureDef();
    fd.shape = sd;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.3;
    fd.restitution = 0.5;

    // Attach Fixture to Body               
    body.createFixture(fd);
  }

  void display() 
  {
    // We need the Body’s location and angle
    Vec2 pos = box2d.getBodyPixelCoord(body);    
    float a = body.getAngle();

    // Using the Vec2 position and float angle to
    // translate and rotate the rectangle
    pushMatrix();
    translate(pos.x,pos.y);    
    rotate(-a);                
    fill(175);
    stroke(0);
    rectMode(CENTER);
    rect(0,0,w,h);
    popMatrix();
  }
}  // End of the Box Class description
