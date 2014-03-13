//
//  KreyosBluetoothViewController.m
//  KreyosIosApp
//
//  Created by KrisJulio on 3/7/14.
//  Copyright (c) 2014 KrisJulio. All rights reserved.
//


#import "KreyosBluetoothViewController.h"
#import "KreyosHomeViewController.h"
#import "LkDiscovery.h"
#import "LKreyosService.h"
#import "KreyosUtility.h"
#import "SportsPageViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>


@interface KreyosBluetoothViewController ()<KreyosDiscoveryDelegate, KreyosProtocol, UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) NSMutableArray            *connectedServices;
@property (retain, nonatomic) CBPeripheral              *connectedperipheral;
@property (retain, nonatomic) UILabel                   *currentlyConnectedSensor;
@property (retain, nonatomic) LKreyosService            *currentlyDisplayingService;


@end

@implementation KreyosBluetoothViewController

@synthesize currentlyDisplayingService;
@synthesize connectedServices;
@synthesize connectedperipheral;
@synthesize currentlyConnectedSensor;
@synthesize sensorsTable;

static KreyosBluetoothViewController *sharedInstance = nil;

+ (KreyosBluetoothViewController *)sharedInstance
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    
    if (self) {
        
       
    }
    return self;
}

#pragma mark - LOAD - UNLOAD - INITIALIZE - DEALLOC
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
}

- (void) viewDidUnload
{
    [self setCurrentlyConnectedSensor:nil];
    [self setConnectedServices:nil];
    [self setCurrentlyDisplayingService:nil];
    [self setConnectedperipheral:nil];
    
    [[LkDiscovery sharedInstance] stopScanning];
    
    [super viewDidUnload];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) initialize
{
    
    //Connected Services
    connectedServices = [NSMutableArray new];
    
    [[LkDiscovery sharedInstance] setDiscoveryDelegate:self];
    [[LkDiscovery sharedInstance] setPeripheralDelegate:self];
    [[LkDiscovery sharedInstance] startScanningForUUIDString:kKreyosServiceUUIDString];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackgroundNotification:) name:kServiceEnteredBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterForegroundNotification:) name:kServiceEnteredForegroundNotification object:nil];
    
    sharedInstance = self;
    
    
    [[LkDiscovery sharedInstance] setDiscoveryDelegate:self];
    [[LkDiscovery sharedInstance] setPeripheralDelegate:self];
    
    [[LkDiscovery sharedInstance] startScanningForUUIDString:kKreyosServiceUUIDString];
    
    
    //m_userdef = [NSUserDefaults standardUserDefaults];
    
    UIColor *fontClr = [UIColor grayColor];
    
    //Currently connected label
    currentlyConnectedSensor = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 300, 35)];
    currentlyConnectedSensor.font = REGULAR_FONT_WITH_SIZE(35);
    currentlyConnectedSensor.textColor = fontClr;
    currentlyConnectedSensor.text = @"";
    currentlyConnectedSensor.textAlignment = UITextAlignmentCenter;
    
    //Gesture Control Allocation
    /*UILabel *bluetoothLbl = [[[UILabel alloc] initWithFrame:CGRectMake(10, 45, 200, 50)] autorelease];
     bluetoothLbl.text = @"Bluetooth Enable";
     bluetoothLbl.font = REGULAR_FONT_WITH_SIZE(20);
     bluetoothLbl.textColor = fontClr;
     
     IASKSwitch *toggle = [[[IASKSwitch alloc] initWithFrame:CGRectMake(shadowWidth - 70, 50, 60, 27)] autorelease];
     [toggle addTarget:self action:@selector(Toggle:) forControlEvents:UIControlEventValueChanged];
     toggle.on = NO;*/
    
    //Add found devices list table
   
    sensorsTable.backgroundColor = [UIColor clearColor];
    sensorsTable.layer.opacity = 0.5f;
    sensorsTable.dataSource = self;
    sensorsTable.delegate = self;
    
    
    //Add Scan Btn
    /*m_scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    m_scanBtn.frame = CGRectMake(10, shadowHeight - 130, shadowWidth - 25, 50);
    [m_scanBtn setTitle:@"Scan" forState:UIControlStateNormal];
    [m_scanBtn addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchDown];
    m_scanBtn.titleLabel.font = PRIMARY_BUTTON_FONT;
    
    [m_scanBtn setBackgroundImage:[[UIImage imageNamed:@"btn_primary_blue"] resizableImageWithCapInsets:UIEdgeInsetsMake(6,6,6,6)] forState:UIControlStateNormal];
    [m_scanBtn setBackgroundImage:[[UIImage imageNamed:@"btn_primary_blue_highlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(6,6,6,6)] forState:UIControlStateHighlighted];
    [m_scanBtn setHighlighted:false];
    
    
    //DIsconnect label btn
    m_disconnectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    m_disconnectBtn.frame = CGRectMake(10, shadowHeight - 70, shadowWidth - 25, 50);
    [m_disconnectBtn setTitle:@"Disconnect" forState:UIControlStateNormal];
    [m_disconnectBtn addTarget:self action:@selector(disconnectToDevice:) forControlEvents:UIControlEventTouchDown];
    m_disconnectBtn.titleLabel.font = PRIMARY_BUTTON_FONT;
    
    [m_disconnectBtn setBackgroundImage:[[UIImage imageNamed:@"btn_primary_blue"] resizableImageWithCapInsets:UIEdgeInsetsMake(6,6,6,6)] forState:UIControlStateNormal];
    [m_disconnectBtn setBackgroundImage:[[UIImage imageNamed:@"btn_primary_blue_highlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(6,6,6,6)] forState:UIControlStateHighlighted];
    [m_disconnectBtn setHighlighted:false];
    
    //int bluetoothVal = [m_userdef integerForKey:@"bluetooth"];
    
    //toggle.on = bluetoothVal == 1 ? YES : NO;
    
    [m_userdef synchronize];
    
    [m_shadowView addSubview:m_scanBtn];
    [m_shadowView addSubview:m_disconnectBtn];
    [m_shadowView addSubview:currentlyConnectedSensor];
    //[m_shadowView addSubview:bluetoothLbl];
    //[m_shadowView addSubview:toggle];
   
    ADD_TO_ROOT_VIEW2(m_shadowView);
    ADD_TO_ROOT_VIEW2(sensorsTable);
      */
}


- (void) dealloc
{
    [[LkDiscovery sharedInstance] stopScanning];
}

#pragma mark - BUTTON CALLBACKS
-(IBAction)Toggle:(id)sender
{
    
}

-(IBAction)disconnectToDevice:(id)sender
{
    [self disconnect:self];
}

-(void)SetThisButton:(UIButton*)p_btn setTruFalse:(BOOL)p_b
{
    p_btn.enabled = p_b;
    p_btn.alpha = p_b == true ? 1.0f : 0.5f;
}

#pragma mark -
#pragma mark Lkreyos Interactions
/****************************************************************************/
/*                  Lkreyos Interactions                                    */
/****************************************************************************/
- (LKreyosService*) serviceForPeripheral:(CBPeripheral *)peripheral
{
    for (LKreyosService *service in connectedServices) {
        if ( [[service peripheral] isEqual:peripheral] ) {
            return service;
        }
    }
    
    return nil;
}

- (void)didEnterBackgroundNotification:(NSNotification*)notification
{
    NSLog(@"Entered background notification called.");
    for (LKreyosService *service in self.connectedServices) {
        [service enteredBackground];
    }
}

- (void)didEnterForegroundNotification:(NSNotification*)notificationuu
{
    NSLog(@"Entered foreground notification called.");
    for (LKreyosService *service in self.connectedServices) {
        [service enteredForeground];
    }
}

#pragma mark -
#pragma mark KreyosProtocol Delegate Methods
/****************************************************************************/
/*				KreyosProtocol Delegate Methods                             */
/****************************************************************************/
// Do what you need to do with returned value
- (void) valueChanged:(NSData*)value fromCharacteristic:(NSString *)characteristic
{
    if ([characteristic isEqual:BLE_HANDLE_TEST_READ]) {
        int8_t i;
        [value getBytes: &i length: sizeof(i)];
        NSString *showValue=[NSString stringWithFormat:@"form <%@>:%d",characteristic,i];
        /*[_showReadValue setText:showValue];
        [_wbutton setEnabled:YES];
        [_rbutton setEnabled:YES];*/
    }
    else if ([characteristic isEqual:BLE_HANDLE_DATETIME]) {
        int8_t i[6];
        [value getBytes: &i length: sizeof(i)];
    }
    else if ([characteristic isEqual:BLE_HANDLE_ALARM_0]) {
        int8_t i[3];
        [value getBytes: &i length: sizeof(i)];
    }
    else if ([characteristic isEqual:BLE_HANDLE_ALARM_1]) {
        int8_t i[3];
        [value getBytes: &i length: sizeof(i)];
    }
    else if ([characteristic isEqual:BLE_HANDLE_ALARM_2]) {
        int8_t i[3];
        [value getBytes: &i length: sizeof(i)];
    }
    else if ([characteristic isEqual:BLE_HANDLE_SPORTS_GRID]) {
        int8_t i[4];
        [value getBytes: &i length: sizeof(i)];
        NSLog(@"GRID DATA : <%@>:%d", characteristic, i[0] );
        NSLog(@"GRID DATA : <%@>:%d", characteristic, i[1] );
        NSLog(@"GRID DATA : <%@>:%d", characteristic, i[2] );
        NSLog(@"GRID DATA : <%@>:%d", characteristic, i[3] );
    }
    else if ([characteristic isEqual:BLE_HANDLE_SPORTS_DATA]) {
        int32_t i[5];
        [value getBytes: &i length: sizeof(i)];
        // NSLog(@"SPORTS DATA : <%@>:%d", characteristic, i[0] );
        // NSLog(@"SPORTS DATA : <%@>:%d", characteristic, i[1] );
        // NSLog(@"SPORTS DATA : <%@>:%d", characteristic, i[2] );
        // NSLog(@"SPORTS DATA : <%@>:%d", characteristic, i[3] );
        // NSLog(@"SPORTS DATA : <%@>:%d", characteristic, i[4] );
    }
    else if ([characteristic isEqual:BLE_HANDLE_SPORTS_DESC]) {
        int32_t i[2];
        [value getBytes: &i length: sizeof(i)];
        NSLog(@"SPORTS DESC : <%@>:%d", characteristic, i[0] );
        NSLog(@"SPORTS DESC : <%@>:%d", characteristic, i[1] );
    }
    else if ([characteristic isEqual:BLE_HANDLE_DEVICE_ID]) {
        int32_t i;
        [value getBytes: &i length: sizeof(i)];
    }
    else if ([characteristic isEqual:BLE_HANDLE_FILE_DESC]) {
        NSString* i;
        [value getBytes: &i length: sizeof(i)];
    }
    else if ([characteristic isEqual:BLE_HANDLE_FILE_DATA]) {
        int8_t i[80];
        [value getBytes: &i length: sizeof(i)];
    }
    else if ([characteristic isEqual:BLE_HANDLE_GPS_INFO]) {
        short i[4];
        [value getBytes: &i length: sizeof(i)];
        
        NSLog(@"SPORTS GPS INFO : <%@>:%d", characteristic, i[0]  );
        //[[KreyosHomeViewController sharedInstance] updateCurrentData: i];
    }
    else if ([characteristic isEqual:BLE_HANDLE_CONF_GESTURE]) {
        int8_t i[5];
        [value getBytes: &i length: sizeof(i)];
    }
    else if ([characteristic isEqual:BLE_HANDLE_CONF_WORLDCLOCK_0]) {
        NSString *i[10];
        [value getBytes: &i length: sizeof(i)];
    }
    else if ([characteristic isEqual:BLE_HANDLE_CONF_WORLDCLOCK_1]) {
        NSString *i[10];
        [value getBytes: &i length: sizeof(i)];
    }
    else if ([characteristic isEqual:BLE_HANDLE_CONF_WORLDCLOCK_2]) {
        NSString *i[10];
        [value getBytes: &i length: sizeof(i)];
    }
    else if ([characteristic isEqual:BLE_HANDLE_CONF_WORLDCLOCK_3]) {
        NSString *i[10];
        [value getBytes: &i length: sizeof(i)];
    }
    else if ([characteristic isEqual:BLE_HANDLE_CONF_WORLDCLOCK_4]) {
        NSString *i[10];
        [value getBytes: &i length: sizeof(i)];
    }
    else if ([characteristic isEqual:BLE_HANDLE_CONF_WORLDCLOCK_5]) {
        NSString *i[10];
        [value getBytes: &i length: sizeof(i)];
    }
    else if ([characteristic isEqual:BLE_HANDLE_CONF_WATCHFACE]) {
        int8_t *i[2];
        [value getBytes: &i length: sizeof(i)];
    }
    else if ([characteristic isEqual:BLE_HANDLE_CONF_GOALS]) {
        short i[3];
        [value getBytes: &i length: sizeof(i)];
    }
    else if ([characteristic isEqual:BLE_HANDLE_CONF_USER_PROFILE]) {
        int8_t i[2];
        [value getBytes: &i length: sizeof(i)];
    }
}


/** Peripheral connected or disconnected */
- (void) kreyosServiceDidChangeStatus:(LKreyosService*)service
{
    if ( [[service peripheral] isConnected] ) {
        NSLog(@"Service (%@) connectedx", service.peripheral.name);
        if (![connectedServices containsObject:service]) {
            [connectedServices addObject:service];
            connectedperipheral = service.peripheral;
            
        }
        
        double delayInSeconds = 5.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            
            [[SportsPageViewController sharedInstance] changeAndUpdateGrid:5];
            
        });
        
        //fire interval checking for bluetooth data
        [self startTimer];
        
        //UpdateTime
        [self updateTime];
        
        //[self SetThisButton:m_disconnectBtn setTruFalse:true];
    }
    
    else {
        NSLog(@"Service (%@) disconnected", service.peripheral.name);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Kreyos Disconnected!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        if ([connectedServices containsObject:service]) {
            [connectedServices removeObject:service];
        }
        
        [[SportsPageViewController sharedInstance] updateTimer:1];
        //[self SetThisButton:m_disconnectBtn setTruFalse:false];
    }
}

/** Central Manager reset */
- (void) kreyosServiceDidReset
{
    [connectedServices removeAllObjects];
}

#pragma mark -
#pragma mark TableView Delegates
/****************************************************************************/
/*							TableView Delegates								*/
/****************************************************************************/
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell	*cell;
	CBPeripheral	*peripheral;
	NSArray			*devices;
	NSInteger		row	= [indexPath row];
    static NSString *cellID = @"DeviceList";
    
	cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (!cell)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    
	if ([indexPath section] == 0) {
		devices = [[LkDiscovery sharedInstance] connectedServices];
        peripheral = [(LKreyosService*)[devices objectAtIndex:row] peripheral];
        
	} else {
		devices = [[LkDiscovery sharedInstance] foundPeripherals];
        peripheral = (CBPeripheral*)[devices objectAtIndex:row];
	}
    
    if ([[peripheral name] length])
        [[cell textLabel] setText:[peripheral name]];
    else
        [[cell textLabel] setText:@"Peripheral"];
    
    [[cell detailTextLabel] setText: [peripheral isConnected] ? @"Connected" : @"Not connected"];
    
   /* if( [peripheral isConnected] )
        [self SetThisButton:m_disconnectBtn setTruFalse:TRUE];
    */
	return cell;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSInteger	res = 0;
    
	if (section == 0)
		res = [[[LkDiscovery sharedInstance] connectedServices] count];
	else
		res = [[[LkDiscovery sharedInstance] foundPeripherals] count];
    
	return res;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	CBPeripheral	*peripheral;
	NSArray			*devices;
	NSInteger		row	= [indexPath row];
	
	if ([indexPath section] == 0) {
		devices = [[LkDiscovery sharedInstance] connectedServices];
        peripheral = [(LKreyosService*)[devices objectAtIndex:row] peripheral];
        
	} else {
		devices = [[LkDiscovery sharedInstance] foundPeripherals];
    	peripheral = (CBPeripheral*)[devices objectAtIndex:row];
	}
    
	if (![peripheral isConnected]) {
		[[LkDiscovery sharedInstance] connectPeripheral:peripheral];
         [currentlyConnectedSensor setText:[NSString stringWithFormat: @"{%@}",[peripheral name]]];
        
        [currentlyConnectedSensor setEnabled:NO];
    }
    
	else {
        
        if ( currentlyDisplayingService != nil ) {
            currentlyDisplayingService = nil;
        }
        
        currentlyDisplayingService = [self serviceForPeripheral:peripheral];
        connectedperipheral=peripheral;
        
        [currentlyConnectedSensor setText:[NSString stringWithFormat: @"{%@}",[peripheral name]]];
        
    }
    
}

#pragma mark -
#pragma mark KreyosDiscoveryDelegate
/****************************************************************************/
/*                       KreyosDiscoveryDelegate Methods                    */
/****************************************************************************/
- (void) discoveryDidRefresh
{
    NSLog(@"refish!");
    [sensorsTable reloadData];
    
    [[[KreyosHomeViewController sharedInstance] bluetoothTable] reloadData];
}

- (void) discoveryStatePoweredOff
{
    NSString *title     = @"Bluetooth Power";
    NSString *message   = @"You must turn on Bluetooth in Settings in order to use LE";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}




#pragma mark -
#pragma mark App IO
/****************************************************************************/
/*                              App IO Methods                              */
/****************************************************************************/
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /*if (![_hour isExclusiveTouch]) {
        [_hour resignFirstResponder];
    }*/
}

- (IBAction)disconnect:(id)sender {
    if (connectedperipheral!=nil) {
        NSLog(@"Trying to disconnect this Kreyos");
        [[LkDiscovery sharedInstance] disconnectPeripheral:connectedperipheral];
        //[self SetThisButton:m_disconnectBtn setTruFalse:false];
    }
}

#pragma mark - Read / Write
-(void) doWrite:(NSData*)dataValue forCharacteristics:(NSString*)characteristic
{
    //*** Sample of wirte some thing to charactristic "BLE_HANDLE_TEST_READ" ***//
    /*
     NSString *setting=[[self hour] text];
     NSLog(@"sample of writing data to the peripheral %@",setting);
     
     NSData  *data	= nil;
     int8_t value    = (int8_t)[setting intValue];
     
     //Note: You should do some data validations here
     
     data = [NSData dataWithBytes:&value length:sizeof (value)];
     [currentlyDisplayingService writeKreyos:data toCharacteristic:p_bleKey];
     
     int8_t i;
     [value getBytes: &i length: sizeof(i)];
     NSString *showValue=[NSString stringWithFormat:@"form <%@>:%d",characteristic,i];
     [_showReadValue setText:showValue];
     */
    if ( connectedperipheral == nil) return;
    
    NSLog(@"Characteristices %@", characteristic);
    
    NSData  *data	= nil;
    
    if ([characteristic isEqual:BLE_HANDLE_TEST_READ]) {
        
        int8_t value = (int8_t)dataValue;
        data = [NSData dataWithBytes:&value length:sizeof (value)];
    }
    else if ([characteristic isEqual:BLE_HANDLE_DATETIME]) {
        
        int32_t value = (int32_t) dataValue;
        NSLog(@"VAL : %i", value);
        data = [NSData dataWithBytes:&value length:sizeof (value)];
        
    }
    else if ([characteristic isEqual:BLE_HANDLE_ALARM_0]) {
    }
    else if ([characteristic isEqual:BLE_HANDLE_ALARM_1]) {
    }
    else if ([characteristic isEqual:BLE_HANDLE_ALARM_2]) {
    }
    else if ([characteristic isEqual:BLE_HANDLE_SPORTS_GRID]) {
        
        data = dataValue;
    }
    else if ([characteristic isEqual:BLE_HANDLE_SPORTS_DATA]) {
    }
    else if ([characteristic isEqual:BLE_HANDLE_SPORTS_DESC]) {
    }
    else if ([characteristic isEqual:BLE_HANDLE_DEVICE_ID]) {
    }
    else if ([characteristic isEqual:BLE_HANDLE_FILE_DESC]) {
    }
    else if ([characteristic isEqual:BLE_HANDLE_FILE_DATA]) {
    }
    else if ([characteristic isEqual:BLE_HANDLE_GPS_INFO]) {
    }
    else if ([characteristic isEqual:BLE_HANDLE_CONF_GESTURE]) {
    }
    else if ([characteristic isEqual:BLE_HANDLE_CONF_WORLDCLOCK_0]) {
    }
    else if ([characteristic isEqual:BLE_HANDLE_CONF_WORLDCLOCK_1]) {
    }
    else if ([characteristic isEqual:BLE_HANDLE_CONF_WORLDCLOCK_2]) {
    }
    else if ([characteristic isEqual:BLE_HANDLE_CONF_WORLDCLOCK_3]) {
    }
    else if ([characteristic isEqual:BLE_HANDLE_CONF_WORLDCLOCK_4]) {
    }
    else if ([characteristic isEqual:BLE_HANDLE_CONF_WORLDCLOCK_5]) {
    }
    else if ([characteristic isEqual:BLE_HANDLE_CONF_WATCHFACE]) {
    }
    else if ([characteristic isEqual:BLE_HANDLE_CONF_GOALS]) {
    }
    else if ([characteristic isEqual:BLE_HANDLE_CONF_USER_PROFILE]) {
    }
    //***End***//
    
    [currentlyDisplayingService writeKreyos:data toCharacteristic:characteristic];
}

/*
 -(void) doRead:(NSString*)p_bleKey
 {
 [currentlyDisplayingService readKreyosfrom:p_bleKey];
 }*/
-(void) updateTime
{
    CFGregorianDate currentDate = CFAbsoluteTimeGetGregorianDate(CFAbsoluteTimeGetCurrent(), CFTimeZoneCopySystem());
    
    NSLog(@"CURRENTDATE %d", (int8_t)currentDate.year);
    NSLog(@"CURRENTDATE %d", (int8_t)currentDate.month);
    NSLog(@"CURRENTDATE %d", (int8_t)currentDate.day);
    
    [currentlyDisplayingService writeDateTime:(int8_t)currentDate.year
                                        month:(int8_t)currentDate.month
                                          day:(int8_t)currentDate.day
                                         hour:(int8_t)currentDate.hour
                                      minutes:(int8_t)currentDate.minute
                                      seconds:(int8_t)currentDate.second];
    
}

-(NSData*) doRead:(NSString*)p_bleKey
{
    [currentlyDisplayingService readKreyosfrom:p_bleKey];
    
    /*
    if ( [p_bleKey isEqualToString:BLE_HANDLE_FILE_DESC ])
    {
        return [currentlyDisplayingService readFileDescInfo];
    }*/
    
    return  nil;
}

- (IBAction)scan:(id)sender {
    
    
#ifdef __i386__
    NSLog(@"SIMULATOR MODE");
#else
    [[LkDiscovery sharedInstance] startScanningForUUIDString:kKreyosServiceUUIDString];
#endif
}

-(void) startTimer
{
    
    if (fetchTimer)
        [fetchTimer fire];
    else{
        
        fetchTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(fetchSportsDataFromWatch:) userInfo:nil repeats:YES];
        
    }
    
}


-(BOOL)isDeviceConnectedToBT
{
    return connectedperipheral.state == CBPeripheralStateConnected ? TRUE : FALSE;
}

#pragma mark FETCH_DATA
-(void)fetchSportsDataFromWatch:(NSTimer *) timer
{
    if ( currentlyDisplayingService == nil)
    {
        currentlyDisplayingService = [self serviceForPeripheral:connectedperipheral];
    }
    
    NSData *desc = [currentlyDisplayingService readSportsData];
    
    //Read Phone Datas
    [currentlyDisplayingService readGPSInfo];
    [currentlyDisplayingService readSportsGrid];
    
    if ( desc == nil)
    {
        return;
    }
    
    int32_t data32[5];
    [desc getBytes:&data32[0] length:sizeof(data32)];
    
    //Set values for sports data
    [[SportsPageViewController sharedInstance] updateWorkOutData:data32];
    
    
    if(data32[0] == -1)
    {
        [fetchTimer invalidate];
        [fetchTimer fire];
    }
    else
    {
        //[sprotsdescTimer invalidate];
        NSData* desc = [currentlyDisplayingService readSportsDesc];
        
        int32_t data32desc[2];
        [desc getBytes:&data32desc[0] length:sizeof(data32desc)];
        
        //THIS IS FOR SPORTS_DESC
        if(data32desc[0] == 0)
        {
            //StopTimer
            [[SportsPageViewController sharedInstance] updateTimer:1];
            NSString* temps = [NSString stringWithFormat:@"%d %d %d %d %d", data32[0], data32[1], data32[2], data32[3], data32[4]];
            
            NSLog(@"sports data2: %@", temps);
        }
        else if(data32desc[0] == 1)
        {
            
            //Start the timer
            
            [[SportsPageViewController sharedInstance] updateTimer:0];
            
        }
        else if(data32desc[0] == 2)
        {
            NSString* temps = [NSString stringWithFormat:@"%d %d %d %d %d", data32[0], data32[1], data32[2], data32[3], data32[4]];
            
            NSLog(@"sports data2: %@", temps);
        }
        
        else
        {
            NSLog(@"error data32desc[0]: %d", data32desc[0]);
        }
        
    }
    
}



@end
