/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  Convenience classes and functions that we use all over the project.
  Includes the Layer class that we use for moving pictures around in response to touches.
  
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//====================================================================================
//
//  Touches block used for onTouchDown, onTouchMove & onTouchUp events on Layer class
//

typedef void(^TouchesActionBlock)(NSSet* touches);

//====================================================================================
//
//  Layer
//

@interface Layer : UIImageView

// creation
- (instancetype) initWithParent:(UIView*)parent;
+ (instancetype) layerWithParent:(UIView*)parent;

// position of the top-left corner in superview's coordinates
@property CGPoint position;
@property CGFloat x;
@property CGFloat y;

// setting size keeps the position (top-left corner) constant
@property CGSize size;
@property CGFloat width;
@property CGFloat height;

// image loading
- (void)loadImage:(NSString*)filename;

// touch blocks
@property (copy) TouchesActionBlock onTouchDown;
@property (copy) TouchesActionBlock onTouchMove;
@property (copy) TouchesActionBlock onTouchUp;

@end


//====================================================================================
//
//  Color
//

CGColorRef RGBA(int red, int green, int blue, int alpha);

//====================================================================================
//
//  Spring
//

@interface Spring : NSObject

@property double position;
@property double damping;
@property double strength;
@property double length;
@property double velocity;

- (void) tick;

@end
