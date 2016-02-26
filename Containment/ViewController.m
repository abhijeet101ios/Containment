//
//  ViewController.m
//  Containment
//
//  Created by Abhijeet Mishra on 16/02/16.
//  Copyright © 2016 Abhijeet Mishra. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (nonatomic, strong) UIViewController* yellowChildViewController;
@property (nonatomic, strong) UIViewController* greenChildViewController;
@property (weak, nonatomic) IBOutlet UIView *animationVictim;
@property (nonatomic, strong) UIButton* callingButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [UIApplication sharedApplication].delegate.window.backgroundColor = [UIColor whiteColor];
 
    self.yellowChildViewController = [UIViewController new];
    self.yellowChildViewController.view.backgroundColor = [UIColor yellowColor];
    [self addChildViewController:self.yellowChildViewController];
    [self.view addSubview:self.yellowChildViewController.view];
    [self.yellowChildViewController didMoveToParentViewController:self];
    self.yellowChildViewController = self.yellowChildViewController;
 
    UIButton* changeToGreenButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [changeToGreenButton setTitle:@"Change" forState:UIControlStateNormal];
    [changeToGreenButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [changeToGreenButton sizeToFit];
    [changeToGreenButton addTarget:self action:@selector(changeToGreen:) forControlEvents:UIControlEventTouchUpInside];
    changeToGreenButton.center = CGPointMake(self.yellowChildViewController.view.frame.size.width/2, self.yellowChildViewController.view.frame.size.height/2);
    [self.yellowChildViewController.view addSubview:changeToGreenButton];
}

- (void) changeToGreen:(UIButton*) greenButton {
   
    if (!self.greenChildViewController) {
        self.greenChildViewController = [UIViewController new];
        self.greenChildViewController.view.backgroundColor = [UIColor greenColor];
    }
    [self addChildViewController:self.greenChildViewController];
    [self.yellowChildViewController willMoveToParentViewController:nil];
     self.greenChildViewController.view.transform = CGAffineTransformMakeScale(0, 0);
    
    [self transitionFromViewController:self.yellowChildViewController toViewController:self.greenChildViewController duration:3 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
    } completion:^(BOOL finished) {
        [self.yellowChildViewController removeFromParentViewController];
        [self.greenChildViewController didMoveToParentViewController:self];
    }];
    
    UIButton* changeToYellowButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [changeToYellowButton setTitle:@"Change" forState:UIControlStateNormal];
    [changeToYellowButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [changeToYellowButton sizeToFit];
    [changeToYellowButton addTarget:self action:@selector(changeToYellow:) forControlEvents:UIControlEventTouchUpInside];
    changeToYellowButton.center = CGPointMake(self.greenChildViewController.view.frame.size.width/2, self.greenChildViewController.view.frame.size.height/2);
    [self.greenChildViewController.view addSubview:changeToYellowButton];
    
    //add the fall animation to the button
//    CABasicAnimation* yellowButtonFallAnimation = [CABasicAnimation animation];
//    yellowButtonFallAnimation.keyPath = @"position.y";
//    yellowButtonFallAnimation.byValue = @"77";
//    yellowButtonFallAnimation.duration = 1.5;
   // [self.yellowChildViewController.view.layer addAnimation:yellowButtonFallAnimation forKey:@"basic"];
}

- (void) changeToYellow:(UIButton*) yellowButton {
    if (!self.yellowChildViewController) {
        self.yellowChildViewController = [UIViewController new];
        self.yellowChildViewController.view.backgroundColor = [UIColor yellowColor];
    }
    
    [self addChildViewController:self.yellowChildViewController];
    [self.greenChildViewController willMoveToParentViewController:nil];
    
    [self transitionFromViewController:self.greenChildViewController toViewController:self.yellowChildViewController duration:3 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        
    } completion:^(BOOL finished) {
        [self.greenChildViewController removeFromParentViewController];
        [self.yellowChildViewController didMoveToParentViewController:self];
    }];
    
    UIButton* changeToGreenButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [changeToGreenButton setTitle:@"Change" forState:UIControlStateNormal];
    [changeToGreenButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [changeToGreenButton sizeToFit];
    [changeToGreenButton addTarget:self action:@selector(changeToGreen:) forControlEvents:UIControlEventTouchUpInside];
    changeToGreenButton.center = CGPointMake(self.yellowChildViewController.view.frame.size.width/2, self.yellowChildViewController.view.frame.size.height/2);
    [self.yellowChildViewController.view addSubview:changeToGreenButton];
}

#pragma mark - Animation methods

- (IBAction)animatePressed:(id)sender {
    self.callingButton = sender;
    [self animationBeginsNow];
}

- (void) animationBeginsNow {
    // [self addMultiStageAnimation];
    // [self addRotationAnimation];
    // [self addTimedAnimation];
    [self addGroupedAnimation];
}

- (void) addSimpleAnimations {
    CABasicAnimation* basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath = @"position.y";
    basicAnimation.byValue = @200;
    basicAnimation.duration = 1;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [self.animationVictim.layer addAnimation:basicAnimation forKey:@"basic"];
    
    basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath = @"position.x";
    basicAnimation.byValue = @-100;
    basicAnimation.duration = 0.5;
    basicAnimation.beginTime = CACurrentMediaTime() + 0.5;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [self.callingButton.layer addAnimation:basicAnimation forKey:@"basic"];
}

- (void) addMultiStageAnimation {
    CAKeyframeAnimation* keyFrameAnimation = [CAKeyframeAnimation animation];
    keyFrameAnimation.keyPath = @"position.x";
    keyFrameAnimation.values = @[@0, @10, @-10, @10, @0];
    keyFrameAnimation.keyTimes = @[@0.0, @(1.0/6.0), @(3.0/6.0), @(5.0/6.0), @1.0];
    keyFrameAnimation.fillMode = kCAFillModeForwards;
    keyFrameAnimation.duration = 0.4;
    keyFrameAnimation.additive = YES;
    keyFrameAnimation.repeatCount = HUGE_VALF;
    [self.callingButton.layer addAnimation:keyFrameAnimation forKey:@"shake"];
}

- (void) addRotationAnimation {
    
    CGRect rotationRect = CGRectMake(- 100, - 100, 200, 200);
    CAKeyframeAnimation* rotationAnimation = [CAKeyframeAnimation animation];
    rotationAnimation.keyPath = @"position";
    rotationAnimation.path = CFAutorelease(CGPathCreateWithEllipseInRect(rotationRect, NULL));
    rotationAnimation.duration = 4;
    rotationAnimation.additive = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.calculationMode = kCAAnimationPaced;
    rotationAnimation.rotationMode = kCAAnimationRotateAuto;
    [self.animationVictim.layer addAnimation:rotationAnimation forKey:@"orbit"];
}

- (void) addTimedAnimation {
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position.y";
    animation.byValue = @50;
    animation.duration = 2;
    // animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:-0.5 :-0.5 :4.5 :4.5];
    animation.repeatCount = HUGE_VALF;
    [self.animationVictim.layer addAnimation:animation forKey:@"basic"];
    self.animationVictim.layer.position = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
}

- (void) addGroupedAnimation {
    //zPosition animation
    CABasicAnimation *zPositionAnimation = [CABasicAnimation animation];
    zPositionAnimation.keyPath = @"zPosition";
    zPositionAnimation.fromValue = @-1;
    zPositionAnimation.toValue = @1;
    zPositionAnimation.duration = 1.2;
    
    //rotation animation
    CAKeyframeAnimation* rotation = [CAKeyframeAnimation animation];
    rotation.keyPath = @"transform.rotation";
    rotation.duration = 1.2;
    rotation.values = @[@0.0, @14.0, @0.0];
    rotation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    //position animation
    CAKeyframeAnimation* positionAnimation = [CAKeyframeAnimation animation];
    positionAnimation.keyPath = @"position";
    positionAnimation.duration = 1.2;
    positionAnimation.additive = YES;
    positionAnimation.values = @[[NSValue valueWithCGPoint:CGPointZero],[NSValue valueWithCGPoint:CGPointMake(10, self.view.bounds.size.height/2)],[NSValue valueWithCGPoint:CGPointZero]];
    positionAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    CAAnimationGroup* animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[zPositionAnimation, rotation, positionAnimation];
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.duration = 1.2;
    // animationGroup.beginTime = 0.5;
    
    [self.callingButton.layer addAnimation:animationGroup forKey:@"shuffle"];
    self.animationVictim.layer.zPosition = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
