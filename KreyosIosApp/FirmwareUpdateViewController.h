//
//  FirmwareUpdateViewController.h
//  KreyosIosApp
//
//  Created by KrisJulio on 3/14/14.
//  Copyright (c) 2014 KrisJulio. All rights reserved.
//

#import "KreyosUIViewBaseViewController.h"

@interface FirmwareUpdateViewController : KreyosUIViewBaseViewController
@property (strong, nonatomic) IBOutlet UIButton *firmwareUpdateBtn;


-(IBAction)updateWatchFirmware:(id)sender;

@end
