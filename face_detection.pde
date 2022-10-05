import processing.video.*;
import gab.opencv.*;
import java.awt.Rectangle;

OpenCV opencv;
Rectangle[] faces;
Capture cam;

void setup() {
  //size(640, 480);
  fullScreen();
  
  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 640, 480);
  } else if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    printArray(cameras);

    cam = new Capture(this, cameras[0]);
    
    opencv = new OpenCV(this, cam.width, cam.height);
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
 
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);
    
    // Start capturing the images from the camera
    cam.start();
  }
  
  background(0);
  noFill();
  noStroke();
  imageMode(CENTER);
  //strokeWeight(3); 
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  opencv.loadImage(cam);
  faces = opencv.detect();
  
  if(faces.length > 0){
    for (int i = 0; i < faces.length; i++) {
      rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
      PImage tempFace = cam.get(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
      image(tempFace, width/2, height/2, 320, 240);
      //image(tempFace, faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    }
  }
  
  
  // The following does the same as the above image() line, but 
  // is faster when just drawing the image without any additional 
  // resizing, transformations, or tint.
  //set(0, 0, cam);
}
