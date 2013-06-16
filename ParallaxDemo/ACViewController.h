//
//  ACViewController.h
//  ParallaxDemo
//
//  Created by Arnaud Coomans on 6/11/13.
//  Copyright (c) 2013 acoomans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACParallaxView.h"

@interface ACViewController : UIViewController <ACParallaxViewDelegate>
@property (nonatomic, strong) IBOutlet ACParallaxView *parallaxView;
@property (nonatomic, strong) IBOutlet UILabel *label;
@end
