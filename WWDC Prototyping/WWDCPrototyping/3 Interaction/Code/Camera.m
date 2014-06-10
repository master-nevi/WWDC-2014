/*
 Copyright (C) 2014 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 
  Live camera preview layer.
  
 */

#import "Camera.h"
#import "Screen.h"
#import <AVFoundation/AVFoundation.h>

@implementation Camera

- (instancetype) initWithParent:(Layer*)parent
{
    self = [super initWithParent:parent];
    if (self == nil) { return nil; }
    
    CALayer* _preview = [self cameraLayer];
    if(_preview != nil){
        // arrange camera preview
        [self.layer addSublayer:_preview];
        _preview.position = CGPointMake(160, 309);
        _preview.bounds = CGRectMake(_preview.bounds.origin.x, _preview.bounds.origin.y, 320, 320.*16/9);
        _preview.transform = CATransform3DRotate( CATransform3DIdentity, M_PI, 0, 1, 0 );

        // mask camera preview to be square
        CALayer* _previewMask = [[CALayer alloc]init];
        [self.layer addSublayer:_previewMask];
        _previewMask.position = CGPointMake(160, 260);
        _previewMask.bounds = CGRectMake(_previewMask.bounds.origin.x, _previewMask.bounds.origin.y, 320, 320);
        _previewMask.backgroundColor = RGBA( 0, 0, 0, 255 );
        _preview.mask = _previewMask;
        
    } else {
        // camera is not working, let's use a fake toast image
        Layer* _fakePreview = [Layer layerWithParent:self];
        [_fakePreview loadImage:@"toast.jpg"];
        _fakePreview.width = _fakePreview.height = 320;
        _fakePreview.y = [Screen layer].height * .5 - _fakePreview.height * .5;
    }
    
    return self;
}

- (AVCaptureVideoPreviewLayer*) cameraLayer
{
    NSError* error;
    
    AVCaptureDevice* defaultDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ( !defaultDevice )
    {
        NSLog( @"No camera available" );
        return nil;
    }
    
    AVCaptureDevice* device = defaultDevice;
    AVCaptureDeviceInput* captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    //if ((captureDeviceInput == nil) || (error != nil)) { LCLog(@"captureSession: error opening input device"); return (id)nil; }
    
    AVCaptureSession* session = [[AVCaptureSession alloc] init];
    
    [session beginConfiguration];
    
    session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    [session addInput:captureDeviceInput];
    
    [session commitConfiguration];
    
    [session startRunning];
    
    AVCaptureVideoPreviewLayer* cam = [AVCaptureVideoPreviewLayer layerWithSession:session];
    cam.opaque = YES;
    cam.connection.automaticallyAdjustsVideoMirroring = NO;  // this doesn't seem to help us
    cam.connection.videoMirrored = YES;
    
    return cam;
}

@end
