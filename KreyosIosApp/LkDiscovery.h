
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#import "LKreyosService.h"



/****************************************************************************/
/*							UI protocols									*/
/****************************************************************************/
@protocol KreyosDiscoveryDelegate <NSObject>
- (void) discoveryDidRefresh;
- (void) discoveryStatePoweredOff;
@end



/****************************************************************************/
/*							Discovery class									*/
/****************************************************************************/
@interface LkDiscovery : NSObject

+ (id) sharedInstance;


/****************************************************************************/
/*								UI controls									*/
/****************************************************************************/
@property (nonatomic, assign) id<KreyosDiscoveryDelegate>           discoveryDelegate;
@property (nonatomic, assign) id<KreyosProtocol>	peripheralDelegate;


/****************************************************************************/
/*								Actions										*/
/****************************************************************************/
- (void) startScanningForUUIDString:(NSString *)uuidString;
- (void) stopScanning;

- (void) connectPeripheral:(CBPeripheral*)peripheral;
- (void) disconnectPeripheral:(CBPeripheral*)peripheral;


/****************************************************************************/
/*							Access to the devices							*/
/****************************************************************************/
@property (retain, nonatomic) NSMutableArray    *foundPeripherals;
@property (retain, nonatomic) NSMutableArray	*connectedServices;	
@end
