/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  Fake list implementation using a picture.
  
 */

#import "List.h"
#import "Screen.h"

@implementation List
{
    double _lastTime;
    NSTimer* _inertiaTimer;
    BOOL _isInertiaing;
    
    CGPoint _currentPosition;
    CGPoint _lastPosition;
    
    double _velocity;
    
    Spring* _spring;
    BOOL _isSpringing;
}

- (instancetype) initWithParent:(Layer*)parent
{
    self = [super initWithParent:parent];
    if (self == nil) { return nil; }
    
    _inertiaTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    _isInertiaing = NO;
    _velocity = 0;
    _lastTime = [NSDate timeIntervalSinceReferenceDate];
    
    _spring = [[Spring alloc] init];

    // pretty good
    _spring.strength = 0.25;
    _spring.damping = 0.4;
 
    // springy
//    _spring.strength = 0.25;
//    _spring.damping = 0.8;
    
    _isSpringing = NO;
    
    return self;
}

- (double) min
{
    return -442;
}

- (double) max
{
    return 300;
}

- (void) clamp
{
    if ( self.y > 300 )
    {
        self.y = 300;
        _velocity = 0;
    }
    
    if ( self.y < -442 )
    {
        self.y = -442;
        _velocity = 0;
    }
}

- (void) tick
{
    if ( _isSpringing )
    {
        [_spring tick];
        [UIView performWithoutAnimation:^(void){
            self.y = _spring.position;
        }];
    }
    else if ( _isInertiaing )
    {
        [UIView performWithoutAnimation:^(void){
            self.y += _velocity/60;
        }];
        _velocity *= 0.98;
        
        if ( self.y < [self min] )
        {
            _spring.position = self.y;
            _spring.length = [self min];
            _spring.velocity = _velocity/60;
            
            _isInertiaing = NO;
            _isSpringing = YES;
        }
        else if ( self.y > [self max] )
        {
            _spring.position = self.y;
            _spring.length = [self max];
            _spring.velocity = _velocity/60;
            
            _isInertiaing = NO;
            _isSpringing = YES;
        }
    }
    else
    {
//        _velocity = _currentPosition.y - _lastPosition.y;
//        _lastPosition = _currentPosition;
//        NSLog( @"%f", _velocity );
    }
}

//------------------------------------------------------------------
//
//  overriding touch handlers in Layer
//

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isInertiaing = NO;
    _isSpringing = NO;
    _velocity = 0;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

    UITouch* touch = [touches anyObject];
    
    [UIView performWithoutAnimation:^(void)
    {
        if ( self.y < [self min] || self.y > [self max] )
        {
            self.y += 0.5*([touch locationInView:[Screen layer]].y - [touch previousLocationInView:[Screen layer]].y);
        }
        else
        {
            self.y += [touch locationInView:[Screen layer]].y - [touch previousLocationInView:[Screen layer]].y;
        }
    }];
    
    double dy = [touch locationInView:[Screen layer]].y - [touch previousLocationInView:[Screen layer]].y;
    double dt = (touch.timestamp - _lastTime);
    
    _velocity = _velocity*0.25 + 0.75*dy/dt;
    
    _currentPosition = [touch locationInView:[Screen layer]];
    
    _lastTime = touch.timestamp;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch* touch = [touches anyObject];
    
    double dy = [touch locationInView:[Screen layer]].y - [touch previousLocationInView:[Screen layer]].y;
    double dt = (touch.timestamp - _lastTime);
    _velocity = _velocity*0.5 + 0.5*dy/dt;
    
    _currentPosition = [touch locationInView:[Screen layer]];
    
    if ( self.y > [self max] )
    {
        _spring.length = [self max];
        _spring.position = self.y;
        _spring.velocity = _velocity/60;
        _isSpringing = YES;
    }
    else if ( self.y < [self min] )
    {
        _spring.length = [self min];
        _spring.position = self.y;
        _spring.velocity = _velocity/60;
        _isSpringing = YES;
    }
    else if ( fabs( _velocity ) > 100 )
    {
        _isInertiaing = YES;
    }
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesEnded:touches withEvent:event];
}


@end
