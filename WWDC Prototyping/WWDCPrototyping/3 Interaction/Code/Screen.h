/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  The entry point to our project where we setup all layers / pictures (see setup function).
  Screen is also the base layer and parent layer to most other layers (pictures).
  The dimensions of the screen layer correspond to the dimensions of the real screen.
  
 */

#import "ToastKit.h"

@interface Screen : Layer

// all layers and pictures are setup in here
- (void) setup;

// called by app delegate to setup layers
+ (void) initWithWindow:(UIWindow*)window;

// class method for global access of screen layer
+ (Screen*) layer;

@end
