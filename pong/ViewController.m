//
//  ViewController.m
//  pong
//
//  Created by Andrew Hoyer on 12-06-01.
//  Copyright (c) 2012 Andrew Hoyer. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize ball, paddle1, paddle2, scorelabel1, scorelabel2;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Initial setup. Set ball's direction, and zero the scores.
    dirx = 15.0;
    diry = 10.0;
    
    score1 = 0;
    score2 = 0;
    
    scorelabel1.text = [NSString stringWithFormat:@"%i", score1];
    scorelabel2.text = [NSString stringWithFormat:@"%i", score2];
    

    // Create two gesture recognizers for the paddles.  Both recognizers make use of the
    // same function.
    
    UIPanGestureRecognizer *pan1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [pan1 setDelegate:self];
    pan1.minimumNumberOfTouches = 1;
    pan1.maximumNumberOfTouches = 1;
    [paddle1 addGestureRecognizer:pan1]; 
    
    UIPanGestureRecognizer *pan2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [pan2 setDelegate:self];
    pan2.minimumNumberOfTouches = 1;
    pan2.maximumNumberOfTouches = 1;
    [paddle2 addGestureRecognizer:pan2];
    
    // Start the timer.
    timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(trigger) userInfo:nil repeats:YES];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    } else {
        return NO;
    }
}

// The trigger function is called each time the timer is fired.  It handles the animation of
// the ball and determines when a player scores, etc.

// Note that some values are hard coded based on the image size (for collision detection) and will 
// need to be adjusted if a different image is used.

- (void)trigger {

    // Gather details about the ball and paddles.
    
    CGPoint center = ball.center;
    
    CGRect ballrect = ball.frame;
    CGRect paddle1rect = paddle1.frame;
    CGRect paddle2rect = paddle2.frame;
    
    
    // Adjust our variables for the ball according to the current speed.
    center.x += dirx;
    center.y += diry;
    
    ballrect.origin.x += dirx;
    ballrect.origin.y += dirx;
    
    
    // Check to see if the ball is hitting one of the side walls. 
    // When a wall is hit, the direction reverses.
    
    if (center.x < 12.0) {
        center.x = 12.0;
        dirx = dirx * -1;
    } else if (center.x > 756.0) {
        center.x = 756.0;
        dirx = dirx * -1;
    }
    
    
    // Check if the ball is going to hit a paddle.  The check makes use of the current
    // "y" velocity to make sure the calculation keeps up with the changing speed.
    
    if (diry < 0.0) {
        // Ball is moving up.
        
        if (center.x > paddle1rect.origin.x && 
            center.x < (paddle1rect.origin.x + paddle1rect.size.width) &&
            center.y <= (paddle1rect.origin.y + paddle1rect.size.height + fabs(diry)) &&
            center.y > (paddle1rect.origin.y + paddle1rect.size.height)
            ) {
            
            // The ball will hit the paddle, so only make it move to the paddle's edge.
            center.y = paddle1rect.origin.y + paddle1rect.size.height + 12.0;
            
            // Reverse direction of the ball.
            diry *= -1;
            
            // Increase y-axis motion by 2%.
            diry *= 1.12;

            // Increase x-axis motion by 1%.
            dirx *= 1.01;
        }
        
        
    } else {
        // Ball is moving down
      
        if (center.x > paddle2rect.origin.x && 
            center.x < (paddle2rect.origin.x + paddle2rect.size.width) &&
            center.y >= (paddle2rect.origin.y - fabs(diry)) &&
            center.y < (paddle2rect.origin.y)
            
            ) {
            
            // The ball will hit the paddle, so only make it move to the paddle's edge.
            center.y = paddle2rect.origin.y - 12.0;
            
            // Reverse direction of the ball.
            diry *= -1;
            
            // Increase y-axis motion by 2%.
            diry *= 1.12;
            
            // Increase x-axis motion by 1%.
            dirx *= 1.01;
        }
        
        
    }
    
    
    // Check to see if a player has scored.
    bool scored = false;
    
    if (center.y < 12.0) {
        center.y = 12.0;
        
        scored = YES;
        score2++;
        
        // Stop the timer! It will be started again once the animation is complete.
        [timer invalidate];
        
    } else if (center.y > 1012.0) {
        center.y = 1012.0;
        
        scored = YES;
        score1++;

        // Stop the timer! It will be started again once the animation is complete.
        [timer invalidate];
    }
    

    // Display the animation.  On completion, if one player has scored, the ball is reset
    // to the center, the score labels are updated, and the timer is started again.
    
    [UIView animateWithDuration:0.05
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^(void) {
                         ball.center = center;
                     }
                     completion:^(BOOL finished) {
                         if (scored) {
                             
                             CGPoint newCenter = ball.center;
                             
                             newCenter.x = 384.0;
                             newCenter.y = 512.0;
                             
                             ball.center = newCenter;
                             
                             scorelabel1.text = [NSString stringWithFormat:@"%i", score1];
                             scorelabel2.text = [NSString stringWithFormat:@"%i", score2];
                             
                             // Reverse the direction of the ball in both directions.
                             dirx = 15.0 * (dirx / fabs(dirx) * -1);
                             diry = 10.0 * (diry / fabs(diry) * -1);
                             
                             timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(trigger) userInfo:nil repeats:YES];
                         }
                     }
     ];

}

// The pan function is called anytime a pan gesture is detected for one of the paddles.

- (void)pan:(UIPanGestureRecognizer*)sender {

    switch([sender state]) {
        case UIGestureRecognizerStateBegan: {
            // If anything should happen when the paddle is first moved, add code here.
        }
        break;
            
        case UIGestureRecognizerStateChanged: {
                        
            CGPoint translation = [sender translationInView:[[sender view] superview]];
            
            // Ensure the paddle doesn't move off the screen.
            
            float newX = [[sender view] center].x + translation.x;
            
            if (newX < 75.0) {
                newX = 75.0;
            } else if (newX > 693.0) {
                newX = 693.0;
            }
            
            [[sender view] setCenter:CGPointMake(newX, [[sender view] center].y)];
            [sender setTranslation:CGPointZero inView:[[sender view] superview]];
            
        }
        break;
            
        case UIGestureRecognizerStateEnded: {
            // If anything should happen when the paddle is released, add code here.
        }
        break;
            
        default:
        break;
    }    
}



// Allow multiple gestures to happen at once.  Required for two players with separate paddles.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
    
}


@end
