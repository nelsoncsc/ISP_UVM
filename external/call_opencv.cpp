#include <stdio.h>
#include <cv.h>
#include <highgui.h>  
#include "definitions.h"
using namespace cv;

void rgb2ycbcr(unsigned long long pp){
  Mat image(HEIGHT,WIDTH, CV_8UC3, (void *)pp);
  cvtColor(image, image, CV_BGR2YCrCb);
}

