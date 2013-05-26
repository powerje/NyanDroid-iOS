//
//  NDViewController.m
//  Nyandroid
//
//  Created by James Power on 5/25/13.
//  Copyright (c) 2013 James Power. All rights reserved.
//

#import "NDViewController.h"
#import "OLImageView.h"
#import "OLImage.h"

@implementation NDViewController {
    CGFloat height, width;
    UIImage* star;
    NSMutableArray* rainbowViews;
}

- (UIImage*) imageByName:(NSString*)name {
    return [OLImage imageWithData:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:name withExtension:@"gif"]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    height = [[UIScreen mainScreen] bounds].size.height;
    width = [[UIScreen mainScreen] bounds].size.width;
    
    // setup nyandroid
    self.nyandroid.image = [self imageByName:@"nyandroid"];
    
    // setup rainbow
    int centerX = width / 2;
    int centerY = height / 2;

    UIImage* rainbow0 = [self imageByName:@"neapolitan0"];
    UIImage* rainbow1 = [self imageByName:@"neapolitan1"];
    float rainbowWidth = 40;

    int rainbowSegmentCount = centerX / rainbowWidth;
    for (int i = 0; i < rainbowSegmentCount; i++) {
        OLImageView* iv = [[OLImageView alloc] initWithFrame:CGRectMake(centerX - (rainbowWidth/2) - (i * rainbowWidth) - rainbowWidth/2,
                                                                        centerY - 45,
                                                                        40,
                                                                        60)];
        [iv setImage:i % 2 == 0 ? rainbow0 : rainbow1];
        [self.view addSubview:iv];
        [rainbowViews addObject:iv];
    }
    
    // setup starfield
    star = [self imageByName:@"star"];
    [NSTimer scheduledTimerWithTimeInterval:1.0/7.0 target:self selector:@selector(updateDisplay) userInfo:nil repeats:YES];
}


- (void) updateDisplay {

    int size;
    int speed;
    int type = arc4random() % 6;

    switch (type) {
        case 0:
            size = 32;
            speed = 2;
            break;
        case 1:
            size = 24;
            speed = 3;
            break;
        case 2:
            size = 16;
            speed = 3;
            break;
        default:
            size = 8;
            speed = 5;
            break;
    }
    
    OLImageView* iv = [[OLImageView alloc] initWithFrame:CGRectMake(width + star.size.width,
                                                                    arc4random() % ((int)height),
                                                                    size,
                                                                    size)];
    [iv setRandomImage:star];
    [self.view addSubview:iv];

    [UIView animateWithDuration:speed delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect frame = iv.frame;
        frame.origin.x = 0 - frame.size.width;
        iv.frame = frame;
    } completion:^(BOOL finished) {
        [iv removeFromSuperview];
    }];

    for (UIView* v in rainbowViews) {
            [self.view bringSubviewToFront:v];
    }
    [self.view bringSubviewToFront:self.nyandroid];
}

@end