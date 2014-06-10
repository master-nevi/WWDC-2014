/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  Fake keyboard typing using an image sequence.
  
 */

#import "KeyboardTyping.h"
#import "Screen.h"

@interface KeyboardTyping()
@property int keyboardTypingFrame;
@end

@implementation KeyboardTyping
{
    Layer* tapLayer;
}

- (instancetype) initWithParent:(Layer*)parent
{
    self = [super initWithParent:parent];
    if (self == nil) { return nil; }
    
    self.width = [Screen layer].width;
    self.height = [Screen layer].height;

    // load keyboard typing fraems
    for (int i = 1; i <= 18; i++)
    {
        Layer* frame = [Layer layerWithParent:self];
        if(i<10)
        {
            [frame loadImage:[NSString stringWithFormat:@"typing.00%i.png",i]];
        } else {
            [frame loadImage:[NSString stringWithFormat:@"typing.0%i.png",i]];
        }
        
        KeyboardTyping* _self = self;
        frame.onTouchDown = ^(NSSet* touches)
        {
            [_self nextFrame];
        };
        
        if(i == 1){
            frame.hidden = NO;
        } else {
            frame.hidden = YES;
        }
    }
    self.keyboardTypingFrame = 1;
    
    return self;
}

- (void) nextFrame
{
    if(self.keyboardTypingFrame < self.subviews.count)
    {
        [UIView performWithoutAnimation:^(void){
            Layer* frame = (Layer*)self.subviews[self.keyboardTypingFrame];
            frame.hidden = NO;
        }];
        self.keyboardTypingFrame++;
    }
}

- (void) setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    // reset frames on hiding
    if (hidden) {

        [UIView performWithoutAnimation:^(void){
            for (int i=0; i<self.subviews.count; i++) {
                Layer* frame = (Layer*)self.subviews[i];
                if(i==0){
                    frame.hidden = NO;
                } else {
                    frame.hidden = YES;
                }
            }
        }];
        self.keyboardTypingFrame = 1;
    }

}






@end
