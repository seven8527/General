//
//  PBJVisionUtilities.h
//
//
//  Created by WangBo on 15/8/10.
//  Copyright (c) 2015年 ToMoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface PBJVisionUtilities : NSObject

+ (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates inFrame:(CGRect)frame;

+ (AVCaptureDevice *)captureDeviceForPosition:(AVCaptureDevicePosition)position;
+ (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections;
+ (AVCaptureDevice *)audioDevice;

+ (CGFloat)angleOffsetFromPortraitOrientationToOrientation:(AVCaptureVideoOrientation)orientation;

+ (uint64_t)availableDiskSpaceInBytes;

@end
