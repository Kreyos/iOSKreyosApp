//
//  KreyosUIViewBaseViewController.m
//  KreyosIosApp
//
//  Created by KrisJulio on 3/6/14.
//  Copyright (c) 2014 KrisJulio. All rights reserved.
//

#import "KreyosUIViewBaseViewController.h"

@interface KreyosUIViewBaseViewController ()

@end

@implementation KreyosUIViewBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //Iterate through your subviews, or some other custom array of views
    for (UIView *view in self.view.subviews)
        [view resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
