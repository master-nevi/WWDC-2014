/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  Interactive share squence where we fake taking a picture of your toast and typing some information related to your toast.
  
 */

#import "Share.h"
#import "Screen.h"
#import "Camera.h"
#import "KeyboardTyping.h"

@implementation Share

- (instancetype) initWithParent:(Layer*)parent
{
    self = [super initWithParent:parent];
    if (self == nil) { return nil; }
    
    Layer* screen = [Screen layer];
    
    // position at bottom edge of screen
    self.y = screen.height;
    
    [self loadImage:@"camera.png"];

    // create camera (see Camera.m for camera preview implementation)
    [Camera layerWithParent:self];
    
    // this is the white circle above the camera preview to align your toast plate
    Layer* _stencil = [Layer layerWithParent:self];
    _stencil.width = _stencil.height = 300;
    _stencil.layer.cornerRadius = _stencil.width/2;
    _stencil.layer.borderColor = RGBA( 255, 255, 255, 255 );
    _stencil.layer.borderWidth = 4;
    _stencil.layer.shadowColor = RGBA( 0, 0, 0, 255 );
    _stencil.layer.shadowOpacity = 1;
    _stencil.layer.shadowRadius = 1;
    _stencil.layer.shadowOffset = CGSizeZero;
    _stencil.x = self.width/2 - _stencil.width/2;
    _stencil.y = self.height/2 - _stencil.height/2;
    
    // we'll use another black layer to cover up the camera preview when transitioning to the keyboard view
    Layer* _cover = [Layer layerWithParent:self];
    _cover.width = _cover.height = 330;
    _cover.layer.backgroundColor = RGBA(0, 0, 0, 255);
    _cover.x = self.width/2 - _cover.width/2;
    _cover.y = self.height/2 - _cover.height/2;
    _cover.hidden = YES;
    
    // create toast image used for share sequence
    Layer* toast = [Layer layerWithParent:self];
    [toast loadImage:@"toast.jpg"];
    toast.width = toast.height = screen.width;
    toast.y = screen.height/2 - toast.height/2;
    toast.layer.opacity = 0;
    
    // create keyboard image that slides in from bottom in the share sequence
    Layer* keyboard = [Layer layerWithParent:screen];
    [keyboard loadImage:@"keyboard.png"];
    keyboard.y = screen.height;
    
    // create keyboard typing sequence (see KeyboardTyping.m)
    KeyboardTyping* keyboardTyping = [KeyboardTyping layerWithParent:screen];
    keyboardTyping.hidden = YES;
    
    // create navigation bar for share sequence
    Layer* postNavBar = [Layer layerWithParent:screen];
    [postNavBar loadImage: @"postNavBar.png"];
    postNavBar.y = -postNavBar.height;
    
    // setup up interactions to go through share sequence
    Layer* share = self;
    self.onTouchUp = ^(NSSet* touches){
        
        // get position of touch
        UITouch* touch = [touches anyObject];
        CGPoint touchPos = [touch locationInView:screen];
        
        // if touch is roughly in cancel button area
        if ( touchPos.x < 100 && touchPos.y > screen.height-100 )
        {
            // slide camera back to bottom edge of screen
            [UIView animateWithDuration:0.5 animations:^(void){
                share.y = screen.height;
            }];
            
            // else if touch is roughly over shutter button
        } else if (touchPos.x > 100 && touchPos.y > screen.height-100) {
            
            // cover up camera preview
            [UIView performWithoutAnimation:^(void){
                _cover.hidden = NO;
            }];
            
            // fade in fake toast image
            [UIView animateWithDuration:.5 animations:^(void){
                toast.layer.opacity = 1;
                
            } completion:^(BOOL finished){
                
                // once the fake toast image is displayed
                // slide in post navigation bar from top
                // and keyboard from bottom
                [UIView animateWithDuration:0.5 animations:^(void)
                 {
                     toast.y = 48;
                     postNavBar.y = 0;
                     keyboard.y = screen.height - keyboard.height;
                 } completion:^(BOOL finished) {
                     
                     Layer* firstKeyboardTypingFrame = keyboardTyping.subviews[0];
                     
                     // fade in first keyboard typing screenshot
                     [UIView performWithoutAnimation:^(void){
                         keyboardTyping.hidden = NO;
                         firstKeyboardTypingFrame.layer.opacity = 0;
                     }];
                     
                     [UIView animateWithDuration:.5 animations:^(void){
                         firstKeyboardTypingFrame.layer.opacity = 1;
                     }];
                     
                 }];
            }];
        }
    };
    
    // "tap" behaviour hack on navigation bar in share sequence
    Layer* _postNavBar = postNavBar;
    postNavBar.onTouchUp = ^(NSSet* touches)
    {
        // hide keyboard typing screen and reset to map list view
        keyboardTyping.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^(void)
         {
             share.y = screen.height;
             toast.y = screen.height/2 - toast.height/2;
             toast.layer.opacity = 0;
             _postNavBar.y = - _postNavBar.height;
             keyboard.y = screen.height;
         } completion:^(BOOL finished){
             _cover.hidden = YES;
         }];
    };
    
    return self;
}

@end
