//
//  MainVC.m
//  KreyosIosApp
//
//  Created by KrisJulio on 3/6/14.
//  Copyright (c) 2014 KrisJulio. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

@end

@implementation MainVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


/*----------------------------------------------------*/
#pragma mark - Overriden Methods -
/*----------------------------------------------------*/

- (NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath
{
    NSString *identifier = @"";
    switch (indexPath.row) {
        case 0:
            identifier = @"home";
            break;
        case 1:
            identifier = @"setNewGoal";
            break;
    }
    
    return identifier;
}

- (NSString *)segueIdentifierForIndexPathInRightMenu:(NSIndexPath *)indexPath
{
    NSString *identifier = @"";
    switch (indexPath.row) {
        case 0:
            identifier = @"home";
            break;
        case 1:
            identifier = @"setNewGoal";
            break;
    }
    
    return identifier;
}

- (CGFloat)leftMenuWidth
{
    return 250;
}

- (CGFloat)rightMenuWidth
{
    return 250;
}

- (void)configureLeftMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame = CGRectMake(0, 0, 25, 13);
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"simpleMenuButton"] forState:UIControlStateNormal];
}

- (void)configureRightMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame = CGRectMake(0, 0, 25, 13);
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"simpleMenuButton"] forState:UIControlStateNormal];
}

- (void) configureSlideLayer:(CALayer *)layer
{
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 1;
    layer.shadowOffset = CGSizeMake(0, 0);
    layer.shadowRadius = 5;
    layer.masksToBounds = NO;
    layer.shadowPath =[UIBezierPath bezierPathWithRect:self.view.layer.bounds].CGPath;
}

- (AMPrimaryMenu)primaryMenu
{
    return AMPrimaryMenuLeft;
}


// Enabling Deepnes on left menu
- (BOOL)deepnessForLeftMenu
{
    return YES;
}

// Enabling Deepnes on left menu
- (BOOL)deepnessForRightMenu
{
    return YES;
}

// Enabling darkness while left menu is opening
- (CGFloat)maxDarknessWhileLeftMenu
{
    return 0.5;
}

// Enabling darkness while right menu is opening
- (CGFloat)maxDarknessWhileRightMenu
{
    return 0.5;
}

@end