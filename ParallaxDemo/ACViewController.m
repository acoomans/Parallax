//
//  ACViewController.m
//  ParallaxDemo
//
//  Created by Arnaud Coomans on 6/11/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import "ACViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ACViewController ()

@end

@implementation ACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.parallaxView.parallax = YES;
    self.parallaxView.parallaxDelegate = self;
    self.parallaxView.refocusParallax = YES;
}

#pragma mark - ACParallaxViewDelegate

- (void)parallaxView:(ACParallaxView*)parallaxView didChangeRelativeAttitude:(ACAttitude)attitude {
    self.label.text = [NSString stringWithFormat:@"ACAttitude\nPitch: %f\nRoll: %f\nYaw: %f", attitude.pitch, attitude.roll, attitude.yaw];;
}


@end
