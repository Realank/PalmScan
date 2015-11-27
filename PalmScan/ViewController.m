//
//  ViewController.m
//  PalmScan
//
//  Created by Realank on 15/11/25.
//  Copyright © 2015年 Realank. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *palmView;
@property (weak, nonatomic) IBOutlet UIImageView *lightView;
@property (assign, nonatomic) BOOL shouldScan;
@property (assign, nonatomic) BOOL animating;
@property (strong, nonatomic) NSDate *lastSwipeTime;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lightView.hidden = YES;
    self.shouldScan = NO;
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction)];
    recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:recognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeBackgound)
                                                 name:@"becomeBackgound" object:nil];
}

- (void) becomeBackgound {
    self.shouldScan = NO;
    self.animating = NO;
}


- (void)swipeAction {
    if (self.lastSwipeTime) {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.lastSwipeTime];
        self.lastSwipeTime = nil;
        NSLog(@"%lf",interval);
        if (interval < 1) {
            self.shouldScan = NO;
        }
    } else {
        self.lastSwipeTime = [NSDate date];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.shouldScan) {
        self.shouldScan = YES;
    }

}
- (void)setShouldScan:(BOOL)shouldScan {
    _shouldScan = shouldScan;
    self.lightView.hidden = !shouldScan;
    self.lightView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 60);
    if (shouldScan) {
        if (!self.animating) {
            [self animateLight];
        }
        
    }
}

- (void)animateLight {

    self.animating = YES;
    self.lightView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 60);
    __block CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, 60);
     __weak __typeof(self) weakSelf = self;
    if (!self.shouldScan) {
        return;
    }
    [UIView animateWithDuration:3.0 animations:^{
        frame.origin.y = weakSelf.view.frame.size.height;
        weakSelf.lightView.frame = frame;
    } completion:^(BOOL finished) {
        if (weakSelf.shouldScan && finished) {
            [self animateLight];
        }else {
            self.animating = NO;
        }
    }];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
@end
