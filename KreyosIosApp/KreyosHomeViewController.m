//
//  KreyosHomeViewController.m
//  KreyosIosApp
//
//  Created by KrisJulio on 3/6/14.
//  Copyright (c) 2014 KrisJulio. All rights reserved.
//

#import "KreyosHomeViewController.h"
#import "KreyosUtility.h"

@interface KreyosHomeViewController ()

@end

@implementation KreyosHomeViewController

@synthesize GoalTab;
@synthesize goalView;

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
    [super hideNavigationItem:self];
    
    
    //Customize Tab
    [self CustomizeGoalTab];
    
}

#pragma mark CUSTOMIZATIONS
- (void)CustomizeGoalTab
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont boldSystemFontOfSize:14], NSFontAttributeName,
                                [UIColor blackColor], NSForegroundColorAttributeName,
                                nil];
    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    [GoalTab setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [GoalTab setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    [GoalTab setTintColor:WHITE];
    [GoalTab setSelectedSegmentIndex:0];
    
    [GoalTab setFrame:CGRectMake(GoalTab.frame.origin.x, GoalTab.frame.origin.y, GoalTab.frame.size.width, GoalTab.frame.size.height * 1.8f)];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
    
    [self segmentedControlCallback:GoalTab];
}


- (IBAction) segmentedControlCallback:(UISegmentedControl*)sender
{
    for (int i=0; i<[sender.subviews count]; i++)
    {
        if ([[sender.subviews objectAtIndex:i]isSelected] )
        {
            UIColor *tintcolor= [UIColor grayColor];
            [[sender.subviews objectAtIndex:i] setTintColor:tintcolor];
        }
        else
        {
            [[sender.subviews objectAtIndex:i] setTintColor:nil];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
