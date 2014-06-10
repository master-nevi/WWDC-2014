/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  The entry point to our project where we setup all layers / pictures (see setup function).
  Screen is also the base layer and parent layer to most other layers (pictures).
  The dimensions of the screen layer correspond to the dimensions of the real screen.
  
  The commented out code in the setup function corresponds to the code snippets that we showed in our presentation.
  Uncommenting these code snippets requires commenting out the other parts in the setup function.
  
 */

#import "ToastKit.h"
#import "Screen.h"
#import "Map.h"
#import "List.h"
#import "Share.h"

@implementation Screen
{
}

//====================================================================================
//
//  setup your own picture layers here
//

- (void) setup {

    /*
    //------------------------------------------------------------------
    //
    // 1. Get the picture on the device
     
    Layer* screen = [Screen layer];
    Layer* picture = [Layer layerWithParent:screen];
    [picture loadImage:@"mapListView.png"];
    */
    
    /*
    //------------------------------------------------------------------
    //
    // 2. Break up the picture
     
    Layer* screen = [Screen layer];
    
    Layer* map = [Layer layerWithParent: screen];
    [map loadImage:@"map.png"];
    map.x = -100;
    map.y = -50;
    
    Layer* list = [Layer layerWithParent:screen];
    [list loadImage:@"list.png"];
    list.y = 284;
    
    Layer* navBar = [Layer layerWithParent: screen];
    [navBar loadImage:@"navBar.png"];
    
    // 3. Move the pictures when you touch them
    
    // simple drag behaviour on map
    Layer* _map = map;
    map.onTouchMove = ^(NSSet* touches)
    {
        UITouch* touch = [touches anyObject];
        CGPoint current = [touch locationInView:screen];
        CGPoint previous = [touch previousLocationInView:screen];
        
        CGPoint delta;
        delta.x = current.x - previous.x;
        delta.y = current.y - previous.y;
        
        [UIView performWithoutAnimation:^(void){
            _map.x = _map.x + delta.x;
            _map.y = _map.y + delta.y;
        }];
    };
    
    // tap to slide in camera view
    Layer* camera = [Layer layerWithParent:screen];
    [camera loadImage:@"camera.png"];
    
    camera.y = screen.height;
    
    navBar.onTouchUp = ^(NSSet* touches)
    {
        [UIView animateWithDuration:0.5 animations:^(void){
            camera.y = 0;
        }];
    };
    */
    
    //------------------------------------------------------------------
    //
    // Complete Toast Modern Prototype
     
    Layer* screen = [Screen layer];
    
    // create map (see Map.m for map related code)
    Map* map = [Map layerWithParent:screen];
    [map loadImage:@"map.png"];
    
    // create map cover (masks map behind the list)
    Layer* mapCover = [Layer layerWithParent:screen];
    mapCover.width = 320;
    mapCover.height = screen.height - 400;
    mapCover.y = 400;
    mapCover.layer.backgroundColor = RGBA( 220, 220, 220, 255 );
    
    // create list (see List.m for list related code)
    List* list = [List layerWithParent:screen];
    [list loadImage:@"list.png"];
    list.y = 300;
    
    // create navigation bar
    Layer* navBar = [Layer layerWithParent:screen];
    [navBar loadImage:@"navBar.png"];
    
    // create share sequence (see Share.m)
    Layer* share = [Share layerWithParent:screen];
    
    // share (plus) button "tap"
    navBar.onTouchUp = ^(NSSet* touches)
    {
        // slide camera image to top of screen
        [UIView animateWithDuration:0.5 animations:^(void)
         {
             share.y = 0;
         }];
    };
    
}

//====================================================================================
//
// screen initialization
//

static Screen* gScreen; // global screen layer

+ (void) initWithWindow:(UIWindow*)window
{
    gScreen = [Screen layerWithParent:window];
    gScreen.size = window.frame.size;
    [gScreen setup];
}

+ (Layer*) layer {
    return gScreen;
}

@end
