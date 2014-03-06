
#import "LkDiscovery.h"


@interface LkDiscovery () <CBCentralManagerDelegate, CBPeripheralDelegate> {
	CBCentralManager    *centralManager;
	BOOL				pendingInit;
}
@end


@implementation LkDiscovery

@synthesize foundPeripherals;
@synthesize connectedServices;
@synthesize discoveryDelegate;
@synthesize peripheralDelegate;



#pragma mark -
#pragma mark Init
/****************************************************************************/
/*									Init									*/
/****************************************************************************/
+ (id) sharedInstance
{
	static LkDiscovery	*this	= nil;

	if (!this)
		this = [[LkDiscovery alloc] init];

	return this;
}


- (id) init
{
    self = [super init];
    if (self) {
		pendingInit = YES;
        centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

		foundPeripherals = [[NSMutableArray alloc] init];
		connectedServices = [[NSMutableArray alloc] init];
	}
    return self;
}


- (void) dealloc
{
    // We are a singleton and as such, dealloc shouldn't be called.
    assert(NO);
    [super dealloc];
}



#pragma mark -
#pragma mark Restoring
/****************************************************************************/
/*								Settings									*/
/****************************************************************************/
/* Reload from file. */
- (void) loadSavedDevices
{
	NSArray	*storedDevices	= [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];

	if (![storedDevices isKindOfClass:[NSArray class]]) {
        NSLog(@"No stored array to load");
        return;
    }
     
    for (id deviceUUIDString in storedDevices) {
        
        if (![deviceUUIDString isKindOfClass:[NSString class]])
            continue;
        
        CFUUIDRef uuid = CFUUIDCreateFromString(NULL, (CFStringRef)deviceUUIDString);
        if (!uuid)
            continue;
        
        [centralManager retrievePeripherals:[NSArray arrayWithObject:(id)uuid]];
        CFRelease(uuid);
    }

}


- (void) addSavedDevice:(CFUUIDRef) uuid
{
	NSArray			*storedDevices	= [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
	NSMutableArray	*newDevices		= nil;
	CFStringRef		uuidString		= NULL;

	if (![storedDevices isKindOfClass:[NSArray class]]) {
        NSLog(@"Can't find/create an array to store the uuid");
        return;
    }

    newDevices = [NSMutableArray arrayWithArray:storedDevices];
    
    uuidString = CFUUIDCreateString(NULL, uuid);
    if (uuidString) {
        [newDevices addObject:(NSString*)uuidString];
        CFRelease(uuidString);
    }
    /* Store */
    [[NSUserDefaults standardUserDefaults] setObject:newDevices forKey:@"StoredDevices"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void) removeSavedDevice:(CFUUIDRef) uuid
{
	NSArray			*storedDevices	= [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
	NSMutableArray	*newDevices		= nil;
	CFStringRef		uuidString		= NULL;

	if ([storedDevices isKindOfClass:[NSArray class]]) {
		newDevices = [NSMutableArray arrayWithArray:storedDevices];

		uuidString = CFUUIDCreateString(NULL, uuid);
		if (uuidString) {
			[newDevices removeObject:(NSString*)uuidString];
            CFRelease(uuidString);
        }
		/* Store */
		[[NSUserDefaults standardUserDefaults] setObject:newDevices forKey:@"StoredDevices"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}


- (void) centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
	NSLog(@"DidRetrieveConnectedPeripheral!");
    CBPeripheral	*peripheral;
	
	/* Add to list. */
	for (peripheral in peripherals) {
		[central connectPeripheral:peripheral options:nil];
	}
	[discoveryDelegate discoveryDidRefresh];
}


- (void) centralManager:(CBCentralManager *)central didRetrievePeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"DidRetrievePeripheral!");
	[central connectPeripheral:peripheral options:nil];
	[discoveryDelegate discoveryDidRefresh];
}


- (void) centralManager:(CBCentralManager *)central didFailToRetrievePeripheralForUUID:(CFUUIDRef)UUID error:(NSError *)error
{
	/* Nuke from plist. */
    NSLog(@"FailedToRetrievePeripheral!");
	[self removeSavedDevice:UUID];
}



#pragma mark -
#pragma mark Discovery
/****************************************************************************/
/*								Discovery                                   */
/****************************************************************************/
- (void) startScanningForUUIDString:(NSString *)uuidString
{
    NSLog(@"Star Scanning Peripherals with %@",uuidString);
    
    NSDictionary	*options	= [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [centralManager scanForPeripheralsWithServices:nil options:options];
    
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    
    switch (peripheral.state) {
            
        case CBPeripheralManagerStatePoweredOn:
            
            NSLog(@"Powered On!!!");
            
            break;
            
        default:
            
            NSLog(@"Peripheral Manager did change state");
            
            break;
            
    }
    
}



- (void) stopScanning
{
    NSLog(@"Stop Scanning peripherals");
	[centralManager stopScan];
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (![foundPeripherals containsObject:peripheral]) {
    
        //NSLog(@"[Discovered]: %@ , %@", peripheral.name, [peripheral identifier]);

		[foundPeripherals addObject:peripheral];
		[discoveryDelegate discoveryDidRefresh];
	}
}



#pragma mark -
#pragma mark Connection/Disconnection
/****************************************************************************/
/*						Connection/Disconnection                            */
/****************************************************************************/
- (void) connectPeripheral:(CBPeripheral*)peripheral
{
	if (![peripheral isConnected]) {
		[centralManager connectPeripheral:peripheral options:nil];
	}
}


- (void) disconnectPeripheral:(CBPeripheral*)peripheral
{
    if (![peripheral isConnected]) {
       	[centralManager cancelPeripheralConnection:peripheral];
    }
}


- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
	LKreyosService	*service	= nil;
	
	/* Create a service instance. */
	service = [[LKreyosService alloc] initWithPeripheral:peripheral controller:peripheralDelegate] ;
	[service start];

	if (![connectedServices containsObject:service])
		[connectedServices addObject:service];

	if ([foundPeripherals containsObject:peripheral])
		[foundPeripherals removeObject:peripheral];

    [peripheralDelegate kreyosServiceDidChangeStatus:service];
	[discoveryDelegate discoveryDidRefresh];
}


- (void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Attempted connection to peripheral %@ failed: %@", [peripheral name], [error localizedDescription]);
}


- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
	LKreyosService	*service	= nil;

	for (service in connectedServices) {
		if ([service peripheral] == peripheral) {
			[connectedServices removeObject:service];
            [peripheralDelegate kreyosServiceDidChangeStatus:service];
			break;
		}
	}

	[discoveryDelegate discoveryDidRefresh];
}


- (void) clearDevices
{
    LKreyosService	*service;
    [foundPeripherals removeAllObjects];
    
    for (service in connectedServices) {
        [service reset];
    }
    [connectedServices removeAllObjects];
}


- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    static CBCentralManagerState previousState = -1;
    
	switch ([centralManager state]) {
		case CBCentralManagerStatePoweredOff:
		{
            [self clearDevices];
            [discoveryDelegate discoveryDidRefresh];
            NSLog(@"S0 CentralManager powered off");
			/* Tell user to power ON BT for functionality, but not on first run - the Framework will alert in that instance. */
            [discoveryDelegate discoveryStatePoweredOff];
            break;
		}
            
		case CBCentralManagerStateUnauthorized:
		{
            NSLog(@"S1 This APP with CentralManager is not allowed");
			/* Tell user the app is not allowed. */
			break;
		}
            
		case CBCentralManagerStateUnknown:
		{
            NSLog(@"S2 State unknow and wait for anthoer event");
			/* Bad news, let's wait for another event. */
			break;
		}
            
		case CBCentralManagerStatePoweredOn:
		{
            NSLog(@"S3 Central Manager is powered on");
			break;
		}
            
		case CBCentralManagerStateResetting:
		{
            NSLog(@"S4 CentralManager reset state");
			[self clearDevices];
            [discoveryDelegate discoveryDidRefresh];
            [peripheralDelegate kreyosServiceDidReset];
			pendingInit = YES;
			break;
		}
            
        case CBCentralManagerStateUnsupported:
        {
            NSLog(@"S5 CentralManager in an unspoorted state");
			/* Bad news, let's wait for another event. */
			break;
        }
	}
    
    previousState = [centralManager state];
}
@end
