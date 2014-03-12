//
//  KreyosBluetoothViewController.h
//  KreyosIosApp
//
//  Created by KrisJulio on 3/7/14.
//  Copyright (c) 2014 KrisJulio. All rights reserved.
//

#import "KreyosUIViewBaseViewController.h"

@interface KreyosBluetoothViewController : KreyosUIViewBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *searchDevicesBtn;
@property (weak, nonatomic) IBOutlet UITableView *sensorsTable;

//Methods
- (IBAction)scan:(id)sender;
-(BOOL)isDeviceConnectedToBT;
+ (KreyosBluetoothViewController *)sharedInstance;

@end
