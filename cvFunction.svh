`ifndef CVFUNCTION
`define CVFUNCTION

`define CHANNELS 3
`define HEIGHT 1920//1080//3//10
`define WIDTH 1080//1920//4//10
`define SIZE CHANNELS*WIDTH*HEIGHT

import "DPI-C" context function longint unsigned setPixel (longint unsigned frame, int x, int y, int r, int g, int b);

import "DPI-C" context function longint unsigned allocateFrame();

import "DPI-C" context function longint unsigned readframe();

import "DPI-C" context function longint unsigned getChannel (longint unsigned frame, int x, int y, int c);

import "DPI-C" context function string frame_tr_convert2string(longint unsigned a_ptr, int rgb_ycbcr);

import "DPI-C" context function int frameCompare (longint unsigned pp1, longint unsigned pp2);

`endif

