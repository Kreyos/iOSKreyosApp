//
//  KreyosHomeViewController.m
//  KreyosIosApp
//
//  Created by KrisJulio on 3/6/14.
//  Copyright (c) 2014 KrisJulio. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "KreyosFacebookController.h"
#import "KreyosHomeViewController.h"
#import "KreyosUtility.h"
#import "AppDelegate.h"
#import "SVGFactoryManager.h"
#import "BadgeSystemManager.h"
#import "KreyosBluetoothViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "LkDiscovery.h"

@interface KreyosHomeViewController ()<KreyosDiscoveryDelegate, KreyosProtocol, UITableViewDataSource, UITableViewDelegate>
{
    CGPoint point;
    CGPoint movePoint;
    
    SVGKLayeredImageView *inFrontBadge;
    NSMutableArray *badgeItems;
    NSMutableArray *items;
    
}

@property (retain, nonatomic) NSMutableArray            *connectedServices;
@property (retain, nonatomic) CBPeripheral              *connectedperipheral;
@property (retain, nonatomic) UILabel                   *currentlyConnectedSensor;
@property (retain, nonatomic) LKreyosService            *currentlyDisplayingService;

@end

@implementation KreyosHomeViewController

@synthesize GoalTab;
@synthesize goalView;
@synthesize badgeImageHolder;
@synthesize carouselView;
@synthesize currentlyDisplayingService;
@synthesize connectedServices;
@synthesize connectedperipheral;
@synthesize currentlyConnectedSensor;
@synthesize bluetoothTable;

static KreyosHomeViewController *sharedInstance = nil;

+ (KreyosHomeViewController *)sharedInstance
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
        // Custom initialization
        
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setUp];
    }
    return self;
}

- (void)initializeBluetooth
{
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Bluetooth Devices" message:@"Choose to connect" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    av.delegate = self;
    
    bluetoothTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 250, 150)];
    
    bluetoothTable.backgroundColor = [UIColor clearColor];
    
    bluetoothTable.delegate = self;
    bluetoothTable.dataSource = self;
    
    [av setValue:bluetoothTable forKey:@"accessoryView"];
    [av show];}

- (void)setUp
{
	//set up data
	items = [NSMutableArray array];
	for (int i = 0; i < 1000; i++)
	{
		[items addObject:@(i)];
	}
    
    badgeItems = [[NSMutableArray alloc] init];
    badgeItems = [[BadgeSystemManager sharedInstance] getBadges];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeBluetooth];
    
    //Customize Tab
    [self CustomizeGoalTab];
    [self SetGoalTab];
}


#pragma mark CUSTOMIZATIONS
-(void)SetGoalTab
{
    carouselView.type = iCarouselTypeRotary;
    carouselView.scrollSpeed = 0.5f;
}

#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [badgeItems count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[SVGFactoryManager sharedInstance] createSVGImage:[badgeItems[index] objectForKey:@"image"]];
        view.contentMode = UIViewContentModeCenter;
    }
    else
    {
        
    }
    return view;
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 3.05f;
        }
        default:
        {
            return value;
        }
    }
}

- (void)CustomizeGoalTab
{
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont boldSystemFontOfSize:14], NSFontAttributeName,
                                [UIColor blackColor], NSForegroundColorAttributeName,
                                nil];
    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor grayColor] forKey:NSForegroundColorAttributeName];
    
    [GoalTab setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [GoalTab setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    [GoalTab setTintColor:KREYOS_GRAY];
    [GoalTab setSelectedSegmentIndex:0];
    
    [GoalTab setFrame:CGRectMake(GoalTab.frame.origin.x, GoalTab.frame.origin.y, GoalTab.frame.size.width, GoalTab.frame.size.height * 1.8f)];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
    
    [self segmentedControlCallback:GoalTab];
}


- (IBAction) segmentedControlCallback:(UISegmentedControl*)sender
{
    for (int i=0; i<[sender.subviews count]; i++)
    {
        if ([[sender.subviews objectAtIndex:i]isSelected] )
        {
            UIColor *tintcolor= KREYOS_GRAY;
           [[sender.subviews objectAtIndex:i] setTintColor:tintcolor];
        }
        else
        {
            
            UIColor *tintcolor= [UIColor whiteColor];
            [[sender.subviews objectAtIndex:i] setTintColor:tintcolor];
        }
    }
}

#pragma mark SWIPE METHODS

-(void)handlePan:(UIPanGestureRecognizer *)gesture
{
    if ( gesture.view != inFrontBadge ) return;
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        //NSLog(@"Received a pan gesture");
        point = [gesture locationInView:gesture.view];
        
    }
    
    CGPoint newCoord = [gesture locationInView:gesture.view];
    float dX = newCoord.x-point.x;
    
    
    gesture.view.frame = CGRectMake(gesture.view.frame.origin.x+dX, gesture.view.frame.origin.y, gesture.view.frame.size.width, gesture.view.frame.size.height);
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell	*cell;
	CBPeripheral	*peripheral;
	NSArray			*devices;
	NSInteger		row	= [indexPath row];
    static NSString *cellID = @"DeviceList";
    
	cell = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (!cell)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    
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
        
        
        currentlyDisplayingService = [[KreyosBluetoothViewController sharedInstance] serviceForPeripheral:peripheral];
        connectedperipheral=peripheral;
        
        [currentlyConnectedSensor setText:[NSString stringWithFormat: @"{%@}",[peripheral name]]];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
