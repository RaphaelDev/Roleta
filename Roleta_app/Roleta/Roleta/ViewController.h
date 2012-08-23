//
//  ViewController.h
//  Momentum
//
//  Created by TOBE11 APPS on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface ViewController : UIViewController <UIGestureRecognizerDelegate>{
    UIImageView* imgRoleta;
    int pixelsDrag;
    int timer;
    CGFloat velocity;
    NSTimer *my_timer,*mainLoopTimer;
    CALayer *logoLayer;
    
    CGFloat lastScale;
	CGFloat lastRotation;
    
	CGFloat firstX;
	CGFloat firstY;
    
    CGFloat previousRotation;
    int Radianroleta;
    int angulo;
    BOOL isRollingEsquerda,isTouchRoleta;
    
}

@property(nonatomic,retain) UIImageView* imgRoleta;

- (void)autoTimerFired;
- (void)resetValues;

@end
