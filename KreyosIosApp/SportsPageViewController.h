//
//  SportsPageViewController.h
//  KreyosIosApp
//
//  Created by KrisJulio on 3/7/14.
//  Copyright (c) 2014 KrisJulio. All rights reserved.
//

#import "KreyosUIViewBaseViewController.h"


@interface SportsPageViewController : KreyosUIViewBaseViewController
{
    IBOutlet UIView *dataHolder;
}

@property (nonatomic) IBOutlet UIView *dataHolder;
@property (weak, nonatomic) IBOutlet UILabel *activeOrInactiveLabel;
@property (weak, nonatomic) IBOutlet UIView *cell_1;
@property (weak, nonatomic) IBOutlet UIView *cell_2;
@property (weak, nonatomic) IBOutlet UIView *cell_3;
@property (weak, nonatomic) IBOutlet UIView *cell_4;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *resumeBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UIView *addBtn;
@property (weak, nonatomic) IBOutlet UIView *badgeChosen;
@property (strong, nonatomic) IBOutlet UILabel *sportsTimer;

-(void)updateTimer:(int)p_timerState;
-(IBAction) updateTimerWithButton:(UIButton*) sender;
-(IBAction)testing:(id)sender;
-(void) updateWorkOutData:(int32_t[5])p_data;
-(void) changeAndUpdateGrid:(int)p_count;

+ (SportsPageViewController *)sharedInstance;

@end
