//
//  SetNewGoalViewController.m
//  KreyosIosApp
//
//  Created by KrisJulio on 3/7/14.
//  Copyright (c) 2014 KrisJulio. All rights reserved.
//

#import "SetNewGoalViewController.h"

@interface SetNewGoalViewController ()

@end

@implementation SetNewGoalViewController

@synthesize group_1_btn;
@synthesize group_2_btn;
@synthesize group_3_btn;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)dismissThisView:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
