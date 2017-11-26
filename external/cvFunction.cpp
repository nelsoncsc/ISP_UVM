#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <iostream>
#include <sstream>
#include "definitions.h"

#include "svdpi.h"
#include <math.h>
#include <stdio.h>
#include <cv.h>
#include <highgui.h> 

#include <stdlib.h>
#include "vpi_user.h"

using namespace cv;
using namespace std;

extern "C" unsigned long long allocateFrame(){
  static Mat image(HEIGHT,WIDTH, CV_8UC3);
  void *frame_data = malloc(image.total()*image.elemSize());
  // verificar frame_data != NULL
  cout << "allocateFrame: " << image.total()*image.elemSize() << "bytes frame_data=" <<  (unsigned long long)frame_data << endl;
  return (unsigned long long)frame_data;
}
   
extern "C" unsigned long long readframe()
{
  const char* filename = "index.jpg";
  Mat image;
  image = imread(filename, 1);
  if(!image.data)
    cout <<"No image data" <<endl;
  
  cout << "readframe after imread: rows=" << image.rows <<" cols=" << image.cols << " data=" << (unsigned long long)image.data  << endl;

  Vec3b intensity = image.at<Vec3b>(0, 0);
  cout << "readframe: image at 0,0 b=" << (int)intensity.val[0] << " g=" << (int)intensity.val[1] << " r=" << (int)intensity.val[2] << endl; 
  intensity = image.at<Vec3b>(0, 1);
  cout << "readframe: image at 0,1 b=" << (int)intensity.val[0] << " g=" << (int)intensity.val[1] << " r=" << (int)intensity.val[2] << endl; 
  intensity = image.at<Vec3b>(1, 0);
  cout << "readframe: image at 1,0 b=" << (int)intensity.val[0] << " g=" << (int)intensity.val[1] << " r=" << (int)intensity.val[2] << endl; 

  unsigned long long pp = allocateFrame();
  Mat frame(HEIGHT,WIDTH, CV_8UC3, (void *)pp);
  cout << endl << "readframe: frame.data=" << (unsigned long long)frame.data << endl;
  memcpy(frame.data, image.data, image.total()*image.elemSize());

  intensity = frame.at<Vec3b>(0, 0);
  cout << "readframe: frame at 0,0 b=" << (int)intensity.val[0] << " g=" << (int)intensity.val[1] << " r=" << (int)intensity.val[2] << endl; 
  intensity = frame.at<Vec3b>(0, 1);
  cout << "readframe: frame at 0,1 b=" << (int)intensity.val[0] << " g=" << (int)intensity.val[1] << " r=" << (int)intensity.val[2] << endl; 
  intensity = frame.at<Vec3b>(1, 0);
  cout << "readframe: frame at 1,0 b=" << (int)intensity.val[0] << " g=" << (int)intensity.val[1] << " r=" << (int)intensity.val[2] << endl; 

  return (unsigned long long)frame.data;
}

extern "C" int frameCompare (unsigned long long pp1, unsigned long long pp2){
  bool flag = 1;
  cout << "frameCompare: inicio pp1=" << pp1 << " pp2=" << pp2 << endl;
  Mat frame1(HEIGHT,WIDTH, CV_8UC3, (void *)pp1);
  Mat frame2(HEIGHT,WIDTH, CV_8UC3, (void *)pp1);
  for(int i = 0; i < HEIGHT; i++)
    for(int j = 0; j < WIDTH; j++) {
      cout << "frameCompare: i=" << i << " j=" << j << endl;
      Vec3b intensity1 = frame1.at<Vec3b>(i, j);
      Vec3b intensity2 = frame2.at<Vec3b>(i, j);
      for(int c = 0; c < CHANNELS; c++) {
        if(abs(intensity1.val[c] - intensity2.val[c]) > 1) { // tolerance of 1
	  flag = 0;
	  cout << "MISMATCH!"<<" from refmod: " << (int)intensity1.val[c] <<" from dut: " << (int)intensity1.val[c];
        }
	else cout << "MATCH!" <<" from refmod: " << (int)intensity1.val[c] <<" from dut: " << (int)intensity1.val[c];
        cout << endl;
      }
  }
  return flag;
}

extern "C" int getChannel(unsigned long long pp, int i, int j, int c){
    cout << "getChannel: pp=" << pp << " i=" << i << " j=" << j << " c=" << c;
    Mat image(HEIGHT,WIDTH, CV_8UC3, (void *)pp);
    cout << endl << "getChannel: image.data=" << (unsigned long long)image.data << endl;
    Vec3b intensity = image.at<Vec3b>(i, j);
    cout << " val=" << (int)intensity.val[c] << endl;
    return intensity.val[c];
}

extern "C"void setPixel(unsigned long long pp, int i, int j, int r, int g, int b){
     cout << "setPixel: pp=" << pp << " i=" << i << " j=" << j << " r=" << r << " g=" << g << " b =" << b << endl;
     Mat image(HEIGHT,WIDTH, CV_8UC3, (void *)pp);
     cout << "setPixel: at=" << (unsigned long long)&(image.at<Vec3b>(i, j)) << endl;
     image.at<Vec3b>(i, j) = Vec3b(b, g, r);
}

ostream& os_pixel (ostream& os, const Vec3b& intensity, int rgb_ycbcr) {
  if(rgb_ycbcr) 
      os << " R=" << (uint8_t)intensity.val[2] << " G=" << (uint8_t)intensity.val[1] << " B=" << (uint8_t)intensity.val[0] << endl;
  else 
      os << " Y=" << (uint8_t)intensity.val[0] << " Cb=" << (int8_t)intensity.val[1] << " Cr=" << (int8_t)intensity.val[2] << endl;
  return os;
}

extern "C"  const char* frame_tr_convert2string (unsigned long long pp, int rgb_ycbcr){
     std::stringstream os;
     Mat image(HEIGHT,WIDTH, CV_8UC3, (void *)pp);
     Vec3b intensity = image.at<Vec3b>(0, 0);
     os << "first pixel " << os_pixel(os, intensity, rgb_ycbcr) << endl;
     intensity = image.at<Vec3b>(image.rows-1, image.cols-1);
     os << "last pixel"  << os_pixel(os, intensity, rgb_ycbcr) << endl;  
     string str(os.str());
     return str.c_str();
}


