//
//  KreyosHomeViewController.h
//  KreyosIosApp
//
//  Created by KrisJulio on 3/6/14.
//  Copyright (c) 2014 KrisJulio. All rights reserved.
//

#import "KreyosUIViewBaseViewController.h"
#import "AMSlideMenuMainViewController.h"

@interface KreyosHomeViewController : KreyosUIViewBaseViewController
{
    IBOutlet UIView *goalView;
}

@property (nonatomic) IBOutlet UISegmentedControl *GoalTab;
@property (nonatomic) IBOutlet UIView *goalView;

- (IBAction) segmentedControlCallback:(UISegmentedControl*)sender;

//Badge View
@property (weak, nonatomic) IBOutlet UILabel *badgeTitle;
@property (weak, nonatomic) IBOutlet UILabel *badgeDescription;

//First PanelView
@property (weak, nonatomic) IBOutlet UILabel *activeOrInativeLabel;

//Second PanelView
@property (weak, nonatomic) IBOutlet UILabel *hrsLabel;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@end
