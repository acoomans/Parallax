//
//  ACParallaxView.m
//  ParallaxDemo
//
//  Created by Arnaud Coomans on 6/11/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import "ACParallaxView.h"
#import <math.h>
#import <QuartzCore/QuartzCore.h>

static CGFloat const parallaxRefocusDivider = 1000;
static CGFloat const parallaxPerspectiveFactor = 1.0/-2000.0;
static CGFloat const parallaxZPosition = -500.0;
static CGFloat const parallaxScale = 1.25;
static CGFloat const parallaxMotionPitchMinimumTreshold = 0.001;

static CMMotionManager *sharedMotionManager;


@interface ACParallaxView ()
@property (nonatomic, assign) ACAttitude relativeAttitude;
@end

@implementation ACParallaxView


#pragma mark - accessors

- (void)setParallax:(BOOL)parallax {
    _parallax = parallax;
    if (parallax) {
        
        // Apply perspective; must be done at parent layer :(
        CATransform3D perspective = CATransform3DIdentity;
        perspective.m34 = parallaxPerspectiveFactor;
        self.superview.layer.sublayerTransform = perspective;
        
        self.layer.zPosition = parallaxZPosition;
        
        [self beginParallaxUpdates];
    } else {
        [self endParallaxUpdates];
    }
}

- (void)setRelativeAttitude:(ACAttitude)relativeAttitude {
    _relativeAttitude = relativeAttitude;
    
    if ([self.parallaxDelegate respondsToSelector:@selector(parallaxView:didChangeRelativeAttitude:)]) {
        [self.parallaxDelegate parallaxView:self didChangeRelativeAttitude:relativeAttitude];
    }
}


#pragma mark - motion

+ (CMMotionManager*)sharedMotionManager {
    if (!sharedMotionManager) {
        sharedMotionManager = [[CMMotionManager alloc] init];
    }
    return sharedMotionManager;
}

+ (void)setSharedMotionManager:(CMMotionManager*)motionManager {
    sharedMotionManager = motionManager;
}


- (void)beginParallaxUpdates {
    
    self.referenceAttitude = ACAttitudeInvalid;
    
    CMMotionManager *motionManager = [self.class sharedMotionManager];
    
    if (motionManager.deviceMotionAvailable) {
        
        if ([self.parallaxDelegate respondsToSelector:@selector(parallaxViewWillBeginParallax:)]) {
            [self.parallaxDelegate parallaxViewWillBeginParallax:self];
        }
        
        [motionManager
         startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
         withHandler: ^(CMDeviceMotion *motion, NSError *error) {
             
             if (
                 ACAttitudeIsInvalid(self.referenceAttitude) &&
                 fabs(motion.attitude.pitch) > parallaxMotionPitchMinimumTreshold // discard the first wrong values returned by motion manager
                 ) {
                 self.referenceAttitude = ACAttitudeWithCMAttitude(motion.attitude);
                 
                 if ([self.parallaxDelegate respondsToSelector:@selector(parallaxViewDidBeginParallax:)]) {
                     [self.parallaxDelegate parallaxViewDidBeginParallax:self];
                 }
                 
             } else {
                 
                 if (self.refocusParallax) {
                     self.referenceAttitude = ACAttitudeOffset(self.referenceAttitude,
                                                               (motion.attitude.pitch - self.referenceAttitude.pitch) / parallaxRefocusDivider,
                                                               (motion.attitude.roll - self.referenceAttitude.roll) / parallaxRefocusDivider,
                                                               (motion.attitude.yaw - self.referenceAttitude.yaw) / parallaxRefocusDivider
                                                               );
                 }
             }
             
             if (!ACAttitudeIsInvalid(self.referenceAttitude)) {
                 ACAttitude attitude = ACAttitudeDifference(ACAttitudeWithCMAttitude(motion.attitude), self.referenceAttitude);

                 attitude = ACAttitudeClamp(attitude,
                                            M_PI/3.0,
                                            M_PI/3.0,
                                            1.0);
                 
                 self.relativeAttitude = attitude;
                 
                 if (attitude.pitch>0.6) {
                     attitude.pitch = 0.6;
                 }
                 
                 if (attitude.pitch<=-0.6f) {
                     attitude.pitch = -0.6f;
                 }
                 
                 if (attitude.roll>0.6) {
                     attitude.roll = 0.6;
                 }
                 
                 if (attitude.roll<=-0.6f) {
                     attitude.roll = -0.6f;
                 }
                 
                 CATransform3D transform = CATransform3DIdentity;

                 // compensate for zPosition
                 transform = CATransform3DScale(transform,
                                                parallaxScale, parallaxScale, parallaxScale);
                 
                 transform = CATransform3DTranslate(transform,
                                                    0, -tan(attitude.pitch)*30, 0);
                 transform = CATransform3DTranslate(transform,
                                                    -tan(attitude.roll)*30, 0, 0);

                 transform = CATransform3DRotate(transform,
                                                 attitude.pitch/2, 1, 0, 0);
                 transform = CATransform3DRotate(transform,
                                                 attitude.roll/2, 0, 1, 0);
                 
                 self.layer.transform = transform;
             }
         }];
    }
}

- (void)endParallaxUpdates {
    CMMotionManager *motionManager = [self.class sharedMotionManager];
    if ([motionManager isDeviceMotionActive] == YES) {
        
        if ([self.parallaxDelegate respondsToSelector:@selector(parallaxViewWillEndParallax:)]) {
            [self.parallaxDelegate parallaxViewWillEndParallax:self];
        }
        
        [motionManager stopDeviceMotionUpdates];
        
        if ([self.parallaxDelegate respondsToSelector:@selector(parallaxViewDidEndParallax:)]) {
            [self.parallaxDelegate parallaxViewDidEndParallax:self];
        }
    }
}

@end
