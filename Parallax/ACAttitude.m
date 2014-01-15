//
//  ACAttitude.m
//  ParallaxDemo
//
//  Created by Arnaud Coomans on 6/15/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import "ACAttitude.h"
#import <float.h>

// NOTE: fixes a bug with float.h not being correctly imported on first build (xcode bug?)
// This bug happens only on first build attempt.
// Subsequent attempts work, the library probably being cached by xcode.
// To reproduce the bug, remove the following lines and clean temporary files in /var/folders/*
#ifndef DBL_MAX
#define DBL_MAX __DBL_MAX__
#endif


ACAttitude const ACAttitudeZero = (ACAttitude){.pitch = 0, .roll = 0, .yaw = 0};
ACAttitude const ACAttitudeInvalid = (ACAttitude){.pitch = DBL_MAX, .roll = DBL_MAX, .yaw = DBL_MAX};


ACAttitude ACAttitudeWithCMAttitude(CMAttitude *attitude) {
    return (ACAttitude){.pitch = attitude.pitch, .roll = attitude.roll, .yaw = attitude.yaw};
}

NSString *NSStringFromACAttitude(ACAttitude attitude) {
    //TODO put in same format as CMAttitude (degrees instead of radians, isn't?)
    return [NSString stringWithFormat:@"ACAttitude Pitch: %f, Roll: %f, Yaw: %f", attitude.pitch, attitude.roll, attitude.yaw];
}


ACAttitude ACAttitudeDifference(ACAttitude attitude1, ACAttitude attitude2) {
    return (ACAttitude){
        .pitch = attitude1.pitch - attitude2.pitch,
        .roll = attitude1.roll - attitude2.roll,
        .yaw = attitude1.yaw - attitude2.yaw
    };
}

ACAttitude ACAttitudeClamp(ACAttitude attitude, double pitchMax, double rollMax, double yawMax) {
    return (ACAttitude){
        .pitch = MAX(-pitchMax, MIN(attitude.pitch , pitchMax)),
        .roll = MAX(-rollMax, MIN(attitude.roll , rollMax)),
        .yaw = MAX(-yawMax, MIN(attitude.yaw , yawMax))
    };
}

ACAttitude ACAttitudeOffset(ACAttitude attitude, double pitchOffset, double rollOffset, double yawOffset) {
    return (ACAttitude){
        .pitch = attitude.pitch + pitchOffset,
        .roll = attitude.roll + rollOffset,
        .yaw = attitude.yaw + yawOffset
    };
}


BOOL ACAttitudeEqualToAttitude(ACAttitude attitude1, ACAttitude attitude2) {
    return (
            attitude1.pitch == attitude2.pitch &&
            attitude1.roll == attitude2.roll &&
            attitude1.yaw == attitude2.yaw
            );
}

BOOL ACAttitudeIsInvalid(ACAttitude attitude) {
    //TODO check for values out of acceptable ranges; not only ACAttitudeInvalid
    return ACAttitudeEqualToAttitude(attitude, ACAttitudeInvalid);
}
