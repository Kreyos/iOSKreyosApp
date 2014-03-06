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
	
    
    //Customize Tab
    [self CustomizeGoalTab];
}

- (void)CustomizeGoalTab
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont boldSystemFontOfSize:14], NSFontAttributeName,
                                [UIColor blackColor], NSForegroundColorAttributeName,
                                nil];
    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    [GoalTab setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [GoalTab setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    GoalTab.tintColor = [UIColor grayColor];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];

}

-(void)onSegmentedControlChanged:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
