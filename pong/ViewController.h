//
//  ViewController.h
//  pong
//
//  Created by Andrew Hoyer on 12-06-01.
//  Copyright (c) 2012 Andrew Hoyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIGestureRecognizerDelegate> {
    
    // Main timer used for ball animation.
    NSTimer *timer;
    
    // Variables to manage the interface.
    UIImageView *ball;
    UIImageView *paddle1;
    UIImageView *paddle2;
    
    UILabel *scorelabel1;
    UILabel *scorelabel2;
    
    // Variables to manage the direction of the ball.
    float dirx;
    float diry;
    
    // Variables to track the score for each player.
    int score1;
    int score2;
    
}

@property (nonatomic,retain) IBOutlet UIImageView *ball;
@property (nonatomic,retain) IBOutlet UIImageView *paddle1;
@property (nonatomic,retain) IBOutlet UIImageView *paddle2;
@property (nonatomic,retain) IBOutlet UILabel *scorelabel1;
@property (nonatomic,retain) IBOutlet UILabel *scorelabel2;


@end
