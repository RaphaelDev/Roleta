//
//  ViewController.m
//  Momentum
//
//  Created by TOBE11 APPS on 4/24/12.
//  Copyright (c) 2012 ****. All rights reserved.
//  Developed by Raphael de Souza Oliveira
//  iOS Developer
//  rso.raphael@yahoo.com.br
//

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)
#define ROTATE_LEFT_TAG	 3
#define ROTATE_RIGHT_TAG 4
#define REFRESH_RATE 1/60.f

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize imgRoleta;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    imgRoleta = [[UIImageView alloc]initWithFrame:CGRectMake(200, 350, 335, 334)];
    imgRoleta.image = [UIImage imageNamed:@"roleta.png"];
    [self.view addSubview:imgRoleta];
    
    pixelsDrag = 0;
    Radianroleta = 0;
    angulo = 0;
    timer = 0;
    
    NSNumberFormatter *fmtCurrency = [[NSNumberFormatter alloc] init];
    [fmtCurrency setNumberStyle: NSNumberFormatterCurrencyStyle];
    [fmtCurrency setGeneratesDecimalNumbers:FALSE];
    [fmtCurrency setCurrencyCode:@"GBP"];
    [fmtCurrency setCurrencySymbol:@""];
    [fmtCurrency setMaximumFractionDigits:2];
    
    velocity = (CGFloat)[[fmtCurrency stringFromNumber:[NSNumber numberWithInt:velocity]] floatValue];
    NSLog(@"%@",[fmtCurrency stringFromNumber:[NSNumber numberWithInt:velocity]]);
    velocity = 0;
    NSLog(@"VELOCITY AO INICAR -> %f",velocity);
    imgRoleta.userInteractionEnabled = YES;
}


//============================
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touch began");

    UITouch *touch = [[event allTouches] anyObject];
    if ([touch view] == imgRoleta) {
        NSLog(@"toquei na roleta");
        isTouchRoleta = YES;

        [mainLoopTimer invalidate];
        mainLoopTimer = nil;
        angulo = 0;
        velocity = 0;
        timer = 0;
        pixelsDrag = 0;
        my_timer = [NSTimer scheduledTimerWithTimeInterval:(1.0)
                                                    target:self 
                                                  selector:@selector(autoTimerFired) 
                                                  userInfo:nil 
                                                   repeats:YES];
    }
    

 
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

    if (isTouchRoleta) {
        UITouch *touch = [touches anyObject];
        CGPoint currentLocation = [touch locationInView:self.view];
        CGPoint pastLocation = [touch previousLocationInView:self.view];
        
        pixelsDrag++;
        
        NSLog(@"pixels drag -> %i",pixelsDrag);
        
        CGPoint d1 = CGPointMake(currentLocation.x-self.view.center.x, currentLocation.y-self.view.center.y);
        CGPoint d2 = CGPointMake(pastLocation.x-self.view.center.x, pastLocation.y-self.view.center.y);
        
        CGFloat angle1 = atan2(d1.y, d1.x);
        CGFloat angle2 = atan2(d2.y, d2.x);
        
        NSLog(@"angle -> %f",(angle1-angle2));

        if (angle1-angle2 < 0) {
            isRollingEsquerda = TRUE;
        } else {
            isRollingEsquerda = FALSE;
        }
        
        imgRoleta.transform = CGAffineTransformRotate(imgRoleta.transform, angle1-angle2);
    }
    

}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (isTouchRoleta) {
        if (timer ==0) {
            timer=1;
        }
        velocity = ((pixelsDrag/timer)/10.0);
        
        NSLog(@"velocity -> %f",velocity);
        
        [my_timer invalidate];
        my_timer = nil;
        
        if (mainLoopTimer == nil) {
            
            mainLoopTimer = [NSTimer scheduledTimerWithTimeInterval:REFRESH_RATE 
                                                             target:self 
                                                           selector:@selector(loopRotation) 
                                                           userInfo:nil repeats:YES];
            
        }
        
        isTouchRoleta = FALSE;
    }
    

    
}
-(void)loopRotation{
    
    if (velocity >0.0001) {
        
        velocity = (velocity *0.98);
        angulo+= velocity;
        
    } else
        [self resetValues];
    
    imgRoleta.transform = CGAffineTransformRotate(imgRoleta.transform, isRollingEsquerda ? (velocity*-1) : velocity);

}
- (void)animationDidStart:(CAAnimation *)theAnimation {
    [CATransaction begin];
    { 
        NSLog(@"did Start");
    }
    [CATransaction commit];
}
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished {
    [CATransaction begin];
    {
        NSLog(@"did stop");
    }
    [CATransaction commit];
}

-(void)autoTimerFired{
    NSLog(@"timer");
    timer++;
}

-(void)resetValues{
    angulo = 0;
    velocity = 0;
    timer = 0;
    pixelsDrag = 0;
    isTouchRoleta = FALSE;
}

@end
