//
//  KreyosBluetoothViewController.h
//  KreyosIosApp
//
//  Created by KrisJulio on 3/7/14.
//  Copyright (c) 2014 KrisJulio. All rights reserved.
//

#import "KreyosUIViewBaseViewController.h"
#import "LKreyosService.h"

@interface KreyosBluetoothViewController : KreyosUIViewBaseViewController
{
    NSTimer *fetchTimer;
    NSTimer *reconnectionTimer;
}

@property (weak, nonatomic) IBOutlet UIButton *searchDevicesBtn;
@property (weak, nonatomic) IBOutlet UITableView *sensorsTable;
@property (retain, nonatomic) LKreyosService            *currentlyDisplayingService;


//Methods
+ (KreyosBluetoothViewController *)sharedInstance;

- (IBAction)scan:(id)sender;
- (BOOL)isDeviceConnectedToBT;
- (void) doWrite:(NSData*)dataValue forCharacteristics:(NSString*)characteristic;
- (void) initialize;
- (LKreyosService*) serviceForPeripheral:(CBPeripheral *)peripheral;
- (NSData*) doRead:(NSString*)p_bleKey;
@end
