//
//  FirmwareUpdateViewController.m
//  KreyosIosApp
//
//  Created by KrisJulio on 3/14/14.
//  Copyright (c) 2014 KrisJulio. All rights reserved.
//

#import "FirmwareUpdateViewController.h"
#import "KreyosBluetoothViewController.h"
#import "LKreyosService.h"

@interface FirmwareUpdateViewController ()

@end

@implementation FirmwareUpdateViewController
@synthesize firmwareUpdateBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)updateWatchFirmware:(id)sender
{
    NSData *fileDesc = [[KreyosBluetoothViewController sharedInstance] currentlyDisplayingService].readFileDesc;
    NSString* data32[20];
    
    [fileDesc getBytes:&data32 length:sizeof(data32)];
    
    
    NSLog(@"FILE DESC %@", [NSString stringWithFormat:@"%@", data32[0] ]);
    
    
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
