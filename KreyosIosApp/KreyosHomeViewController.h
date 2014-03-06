//
//  KreyosHomeViewController.h
//  KreyosIosApp
//
//  Created by KrisJulio on 3/6/14.
//  Copyright (c) 2014 KrisJulio. All rights reserved.
//

#import "KreyosUIViewBaseViewController.h"

@interface KreyosHomeViewController : KreyosUIViewBaseViewController
{
    IBOutlet UISegmentedControl *GoalTab;
    IBOutlet UIView *goalView;
}

@property (nonatomic) IBOutlet UISegmentedControl *GoalTab;
@property (nonatomic) IBOutlet UIView *goalView;

@end
