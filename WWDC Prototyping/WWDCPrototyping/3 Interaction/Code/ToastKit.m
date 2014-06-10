/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  Convenience classes and functions that we use all over the project.
  Includes the Layer class that we use for moving pictures around in response to touches.
  
 */

#import "ToastKit.h"

//====================================================================================
//
//  Layer
//

@implementation Layer

//------------------------------------------------------------------
//
//  creation

- (instancetype) initWithParent:(UIView*)parent
{
	self = [self initWithFrame:CGRectZero];
	if (self == nil) { return nil; }
    
	[parent addSubview:self];
	
    // make all layers receive touches
    self.userInteractionEnabled = YES;
    
	return self;
}

+ (instancetype) layerWithParent:(UIView*)parent
{
	return [[self alloc] initWithParent:parent];
}

//------------------------------------------------------------------
//
//  position

- (CGPoint) position
{
	CGPoint center = self.center;
	CGSize size = self.size;
	return CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5);
}

- (void) setPosition:(CGPoint)position
{
	CGSize size = self.size;
	self.center = CGPointMake(position.x + size.width * 0.5, position.y + size.height * 0.5);
}

- (CGFloat) x  { return self.position.x; }
- (CGFloat) y  { return self.position.y; }
- (void) setX:(CGFloat)x  { self.position = CGPointMake(x, self.position.y); }
- (void) setY:(CGFloat)y  { self.position = CGPointMake(self.position.x, y); }


//------------------------------------------------------------------
//
//  size

- (CGSize)  size   { return self.bounds.size; }
- (CGFloat) width  { return self.bounds.size.width; }
- (CGFloat) height { return self.bounds.size.height; }

- (void) setSize:(CGSize)size
{
	CGPoint position = self.position;
	CGPoint origin = self.bounds.origin;
    self.bounds = CGRectMake(origin.x, origin.y, size.width, size.height);
	self.position = position;
}

- (void) setWidth:(CGFloat)width   { [self setSize:CGSizeMake(width, self.bounds.size.height)]; }
- (void) setHeight:(CGFloat)height { [self setSize:CGSizeMake(self.bounds.size.width, height)]; }

//------------------------------------------------------------------
//
//  image loading

- (void)loadImage:(NSString*)filename
{
    self.image = [UIImage imageNamed:[NSString stringWithFormat:@"Images/%@",filename]];
	self.size = CGSizeMake(self.image.size.width*0.5, self.image.size.height*0.5);
}

//------------------------------------------------------------------
//
//  touch
//

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // trigger onTouchDown block if it exists
    if (self.onTouchDown) {
        self.onTouchDown(touches);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    // trigger onTouchMove block if it exists
    if (self.onTouchMove) {
        self.onTouchMove(touches);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    // trigger onTouchUp block if it exists
    if (self.onTouchUp) {
        self.onTouchUp(touches);
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    // trigger onTouchUp block if it exists
    if (self.onTouchUp) {
        self.onTouchUp(touches);
    }
}

@end

//====================================================================================
//
//  Color
//

CGColorRef RGBA(int red, int green, int blue, int alpha){
    CGColorSpaceRef	colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpace,(CGFloat[]){ red/255., green/255., blue/255., alpha/255. });
    CGColorSpaceRelease(colorSpace);
    return color;
}

//====================================================================================
//
//  Spring
//

@implementation Spring
{
    double _strength;
    double _position;
    double _velocity;
    double _damping;
    double _length;
}

- (instancetype) init
{
    self = [super init];
    
    _length = 0;
    _position = 0;
    _damping = 0.9;
    _velocity = 0;
    _strength = 10;
    
    return self;
}

@synthesize position = _position;
@synthesize strength = _strength;
@synthesize damping = _damping;
@synthesize length = _length;
@synthesize velocity = _velocity;

- (void) tick
{
    double force = -_strength*(_position - _length);
    _velocity += force;
    _velocity *= _damping;
    _position += _velocity;
}

@end

