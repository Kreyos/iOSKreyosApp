//
//  SportsPageViewController.m
//  KreyosIosApp
//
//  Created by KrisJulio on 3/7/14.
//  Copyright (c) 2014 KrisJulio. All rights reserved.
//
#define TRASH_BTN       1
#define REFRESH_BTN     2

#import "SportsPageViewController.h"
#import "KreyosUtility.h"
#import "KreyosBluetoothViewController.h"
#import "SVGFactoryManager.h"
#import "SVGKImage.h"
#import "LKreyosService.h"
#import "LkDiscovery.h"

@interface SportsPageViewController ()
{
    
}
@end

@implementation SportsPageViewController
{
    NSMutableDictionary *workoutStatus;
    NSMutableArray* m_cellValueStorage;
    
    NSArray *m_trackableObjects;
    NSArray *m_cellArray;
    int currentNumberOfTiles;
    
    NSTimer* watchTimer;

    //Timer
    int m_timeCounter;
    int m_recordedTime;
    int m_seconds;
    int m_minutes;
    int m_hours;
}

typedef enum TimerState
{
    TimeStart = 0,
    TimeStop,
    TimePause,
    TimeResume,
    
} TimerStates;
TimerStates timerState;

@synthesize dataHolder;
@synthesize sportsTimer;
@synthesize activeOrInactiveLabel;
@synthesize cell_1;
@synthesize cell_2;
@synthesize cell_3;
@synthesize cell_4;
@synthesize pauseBtn;
@synthesize startBtn;
@synthesize resumeBtn;
@synthesize stopBtn;
@synthesize addBtn;

static SportsPageViewController *sharedInstance = nil;

+ (SportsPageViewController *)sharedInstance
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
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    sharedInstance = self;
    
    dataHolder.layer.cornerRadius = 10;
    timerState = TimeStop;
    
    m_cellArray = [NSArray arrayWithObjects:cell_1, cell_2, cell_3, cell_4, nil];
    
    [self setTileCountTo:5];
    [self setUpSportsButtons];
    [self setStatus];
    
    for (UIView *cell in m_cellArray) {
        [self setUpCellButtons:cell];
    }
    
}

- (void) setUpSportsButtons
{
    //Set Up ADD CELL BUTTON
    SVGKFastImageView *addImage = [[SVGFactoryManager sharedInstance] createSVGImage:@"add_button"];
    addImage.layer.anchorPoint = CGPointMake(1, 1);
    addImage.transform = CGAffineTransformScale(addImage.transform, 0.4f, 0.4f);
    [addBtn addSubview: (SVGKFastImageView*)addImage];
    addBtn.contentMode = UIViewContentModeCenter;
    
    currentNumberOfTiles;
    pauseBtn.hidden = TRUE;
    resumeBtn.hidden = TRUE;
    stopBtn.hidden = TRUE;
}

- (void) setUpCellButtons:(UIView*)cellView
{
    cellView.layer.borderColor = [UIColor grayColor].CGColor;
    cellView.layer.borderWidth = 0.5f;
    //cellView
    for (UIView *vCell in [cellView subviews]) {
        
        //1 is REFRESH 2 is DELETE
        switch (vCell.tag) {
            case 1:
                
                [vCell addSubview: (SVGKFastImageView*)[[SVGFactoryManager sharedInstance] createSVGImage:@"trashcan_icon"]];
                vCell.contentMode = UIViewContentModeCenter;
                
                break;
            case 2:
                
                [vCell addSubview: (SVGKFastImageView*)[[SVGFactoryManager sharedInstance] createSVGImage:@"trashcan_icon"]];
                vCell.contentMode = UIViewContentModeCenter;
                
                break;
            default:
                break;
        }
        
    }
}

#pragma mark TIMER
-(IBAction) updateTimerWithButton:(UIButton*) sender
{
    [self updateTimer:[sender tag]];
}

-(void)updateTimer:(int)p_timerState
{
    switch(p_timerState)
    {
        case TimeStart: //Timer start
            
            /*if ( ![[KreyosBluetoothViewController sharedInstance] isDeviceConnectedToBT] )
            {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Device Detected" message:@"Please connect your Kreyos" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alertView show];
                return;
            }*/

            
            if (timerState == TimeStart) return;
            
            m_timeCounter = 0;
            
            //Set State to start
            timerState = TimeStart;
            
            watchTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(fireTimer:) userInfo:nil repeats:YES];
            
            [watchTimer fire];
            
            //Show pause and hide start button
            startBtn.hidden = YES;
            pauseBtn.hidden = NO;
            
            
            break;
            
        case TimePause: //Timer pause
            
            timerState = TimePause;
            
            resumeBtn.hidden = stopBtn.hidden = startBtn.hidden = NO;
            
            pauseBtn.hidden = YES;
            
            break;
            
        case TimeResume: //Timer resume
            
            timerState = TimeResume;
            
            resumeBtn.hidden = stopBtn.hidden = startBtn.hidden = YES;
            startBtn.hidden = NO;
            
            //Show pause and hide start button
            startBtn.hidden = YES;
            pauseBtn.hidden = NO;
            
            break;
            
        case TimeStop: //Timer stop
            
            if(timerState == TimeStop) return;
            
            timerState = TimeStop;
            [watchTimer invalidate];
            [self resetTimer];
            
            resumeBtn.hidden = stopBtn.hidden = YES;
            startBtn.hidden = NO;
            
            /*
            if(viewMapGps)
            {
                KreyosGPSMapViewController *mapView = (KreyosGPSMapViewController*)viewMapGps;
                [mapView resetValues];
            }
            */
            //[self showSummaryPage];
            
            break;
    }
}

-(void)fireTimer:(NSTimer *)timer {
    
    if(timerState == TimePause) return;
    
    m_timeCounter ++ ;
    [self populateLabelwithTime:m_timeCounter];
    
}

-(void) populateLabelwithTime:(int)milliseconds
{
    
    NSString *time_string;
    
    m_seconds = milliseconds;
    m_minutes = m_seconds / 60;
    m_hours = m_minutes / 60;
    
    m_seconds -= m_minutes * 60;
    m_minutes -= m_hours * 60;
    
    time_string = [NSString stringWithFormat:@"%02d:%02d:%02d", m_hours, m_minutes, m_seconds];
    
    if ( sportsTimer )
        sportsTimer.text = time_string;
    
    /*
    if(viewMapGps)
    {
        KreyosGPSMapViewController *mapView = (KreyosGPSMapViewController*)viewMapGps;
        [mapView setTime:time_string];
    }
     */
}


#pragma mark BUTTON CALLBACKS

-(IBAction)testing:(id)sender
{
    [self setTileCountTo:--currentNumberOfTiles];
}

#pragma mark SET TILES

- (void) setTileCountTo:(int)count
{
    float yPos = 192;
    float xPos = 0;
    
    CGSize fiveGridSize = CGSizeMake(140, 99);
    CGSize fourGridSize = CGSizeMake(280, 66.66f);
    CGSize threeGridSize = CGSizeMake(280, 99);
    
    
    [UIView animateWithDuration: 0.2f animations:^{
        
        switch (count) {
            case 3:
                
                cell_1.frame = CGRectMake(xPos,
                                          yPos,
                                          threeGridSize.width,
                                          threeGridSize.height);
                
                cell_2.frame = CGRectMake(xPos,
                                          yPos + cell_1.frame.size.height,
                                          threeGridSize.width,
                                          threeGridSize.height);
                
                cell_3.transform = CGAffineTransformMakeScale(0, 0);
                cell_4.transform = CGAffineTransformMakeScale(0, 0);
                
                break;
                
            case 4:
                
                cell_1.frame = CGRectMake(xPos,
                                          yPos,
                                          fourGridSize.width,
                                          fourGridSize.height);
                
                cell_2.frame = CGRectMake(xPos,
                                          yPos + cell_1.frame.size.height,
                                          fourGridSize.width,
                                          fourGridSize.height);
                
                cell_3.frame = CGRectMake(xPos,
                                          cell_2.frame.origin.y + cell_2.frame.size.height,
                                          fourGridSize.width,
                                          fourGridSize.height);
                
                cell_4.transform = CGAffineTransformMakeScale(0, 0);
                
                break;
            case 5:
                
                cell_1.frame = CGRectMake(xPos,
                                          yPos,
                                          fiveGridSize.width,
                                          fiveGridSize.height);
                
                cell_2.frame = CGRectMake(fiveGridSize.width,
                                          yPos,
                                          fiveGridSize.width,
                                          fiveGridSize.height);
                
                cell_3.frame = CGRectMake(xPos,
                                          cell_2.frame.origin.y + cell_2.frame.size.height,
                                          fiveGridSize.width,
                                          fiveGridSize.height);
                
                cell_4.frame = CGRectMake(fiveGridSize.width,
                                          yPos + cell_1.frame.size.height,
                                          fiveGridSize.width,
                                          fiveGridSize.height);
                
                break;
                
            default:
                break;
        }
        
    } completion:^(BOOL finished) {
        
        //set current tile num
        currentNumberOfTiles = count;
    }];
    
}


#pragma mark SET STATUS

-(void) updateWorkOutData:(int32_t[5])p_data
{
    for (UIView *cell in m_cellArray) {
        for (UILabel *dataLbl in [cell subviews]) {
            if ( dataLbl.tag == 4 )
            {
                NSLog(@"DATA LABEL : %d", p_data[[m_cellArray indexOfObject:cell] + 1]);
                dataLbl.text = [NSString stringWithFormat:@"%d", p_data[[m_cellArray indexOfObject:cell] + 1]];
            }
        }
    }
}

-(void) updateStatus:(NSString*)p_key cellNum: (UIView*) p_cell
{
    // IF CELL VALUE EXISTS ON CELLS
    if ( [m_cellValueStorage containsObject:p_key] ) return;
    
    // REPLACE VALUE ON INDEX
    [m_cellValueStorage replaceObjectAtIndex:p_cell.tag - 1 withObject:p_key];
    
    if (p_cell != nil) {
        NSString* statusTitle   = [workoutStatus valueForKey:p_key];
        
        NSString* path          = [p_key stringByAppendingString:@"Icon"];
        NSString* measurement   = [p_key stringByAppendingString:@"Measure"];
        
        NSString* statusIconPath        = [workoutStatus valueForKey:path];
        NSString* statusUnitMeasurement = [workoutStatus valueForKey:measurement];
    }
}

-(void) changeAndUpdateGrid:(int)p_count
{
    int8_t passedVal[4];
    
    switch (p_count) {
        case 3:
            
            passedVal[0] = [self getByteValue:m_cellValueStorage[0]];
            passedVal[1] = [self getByteValue:m_cellValueStorage[2]];
            passedVal[2] = -1;
            passedVal[3] = -1;
            
            break;
        case 4:
            
            passedVal[0] = [self getByteValue:m_cellValueStorage[0]];
            passedVal[1] = [self getByteValue:m_cellValueStorage[1]];
            passedVal[2] = [self getByteValue:m_cellValueStorage[2]];
            passedVal[3] = -1;
            
            break;
        case 5:
            
            passedVal[0] = [self getByteValue:m_cellValueStorage[0]];
            passedVal[1] = [self getByteValue:m_cellValueStorage[1]];
            passedVal[2] = [self getByteValue:m_cellValueStorage[2]];
            passedVal[3] = [self getByteValue:m_cellValueStorage[3]];
            
            break;
            
        default:
            break;
    }
    
    NSData *valueToPass = [NSData dataWithBytes:&passedVal length:sizeof(passedVal)];
    
    [[KreyosBluetoothViewController sharedInstance] doWrite:valueToPass forCharacteristics:BLE_HANDLE_SPORTS_GRID];
    
}

-(void)setStatus
{
    workoutStatus = [[NSMutableDictionary alloc] init];
    /*
     Dictionary Contains :
     - Name
     - Icon
     - Unit of measurement
     */
    
    //Heart Rate
    [workoutStatus setObject:@"Heart Rate"              forKey:@"Heart"];
    [workoutStatus setObject:@"icon_sports_heart_rate"  forKey:@"HeartIcon"];
    [workoutStatus setObject:@"bpm"                     forKey:@"HeartMeasure"];
    
    //Avg Heart Rate
    [workoutStatus setObject:@"Avg Heart Rate"          forKey:@"AvgHeart"];
    [workoutStatus setObject:@"icon_sports_heart_rate"  forKey:@"AvgHeartIcon"];
    [workoutStatus setObject:@"bpm"                     forKey:@"AvgHeartMeasure"];
    
    //Max Heart Rate
    [workoutStatus setObject:@"Max Heart Rate"                  forKey:@"MaxHeart"];
    [workoutStatus setObject:@"icon_sports_heart_rate_max"      forKey:@"MaxHeartIcon"];
    [workoutStatus setObject:@"bpm"                             forKey:@"MaxHeartMeasure"];
    
    //Pace
    [workoutStatus setObject:@"Pace"                    forKey:@"Pace"];
    [workoutStatus setObject:@"icon_sports_pace"        forKey:@"PaceIcon"];
    [workoutStatus setObject:@"per mile"                forKey:@"PaceMeasure"];
    
    //Avg Pace
    [workoutStatus setObject:@"Avg Pace"                forKey:@"AvgPace"];
    [workoutStatus setObject:@"icon_sports_pace"        forKey:@"AvgPaceIcon"];
    [workoutStatus setObject:@"per mile"                forKey:@"AvgPaceMeasure"];
    
    //Current Lap
    [workoutStatus setObject:@"Current Lap"                   forKey:@"CurrentLap"];
    [workoutStatus setObject:@"icon_sports_lap_current"       forKey:@"CurrentLapIcon"];
    [workoutStatus setObject:@"per mile"                      forKey:@"CurrentLapMeasure"];
    
    //Avg Lap
    [workoutStatus setObject:@"Avg Lap"                   forKey:@"AvgLap"];
    [workoutStatus setObject:@"icon_sports_lap_average"   forKey:@"AvgLapIcon"];
    [workoutStatus setObject:@"per mile"                  forKey:@"AvgLapMeasure"];
    
    //BestLap
    [workoutStatus setObject:@"Best Lap"                 forKey:@"BestLap"];
    [workoutStatus setObject:@"icon_sports_lap_best"    forKey:@"BestLapIcon"];
    [workoutStatus setObject:@"mph"                     forKey:@"BestLapMeasure"];
    
    //Time of the Day
    [workoutStatus setObject:@"Time of the day"                 forKey:@"Totd"];
    [workoutStatus setObject:@"icon_sports_time_of_the_day"     forKey:@"TotdIcon"];
    [workoutStatus setObject:@""                                forKey:@"TotdMeasure"];
    
    //Speed
    [workoutStatus setObject:@"Speed"                       forKey:@"Speed"];
    [workoutStatus setObject:@"icon_sports_speed"           forKey:@"SpeedIcon"];
    [workoutStatus setObject:@"kph"                         forKey:@"SpeedMeasure"];
    
    //Avg speed
    [workoutStatus setObject:@"AvgSpeed"                    forKey:@"AvgSpeed"];
    [workoutStatus setObject:@"icon_sports_speed_average"   forKey:@"AvgSpeedIcon"];
    [workoutStatus setObject:@"kph"                         forKey:@"AvgSpeedMeasure"];
    //Top speed
    [workoutStatus setObject:@"Top Speed"                   forKey:@"TopSpeed"];
    [workoutStatus setObject:@"icon_sports_speed_top"       forKey:@"AvgSpeedIcon"];
    [workoutStatus setObject:@"kph"                         forKey:@"AvgSpeedMeasure"];
    
    //Calories
    [workoutStatus setObject:@"Calories"                   forKey:@"Calories"];
    [workoutStatus setObject:@"icon_sports_calories"       forKey:@"CaloriesIcon"];
    [workoutStatus setObject:@""                           forKey:@"CaloriesMeasure"];
    
    //Distance
    [workoutStatus setObject:@"Distance"                   forKey:@"Distance"];
    [workoutStatus setObject:@"icon_sports_distance"       forKey:@"DistanceIcon"];
    [workoutStatus setObject:@"km"                         forKey:@"DistanceMeasure"];
    
    
    //Altitude
    [workoutStatus setObject:@"Altitude"                   forKey:@"Altitude"];
    [workoutStatus setObject:@"icon_sports_altitude"       forKey:@"AltitudeIcon"];
    [workoutStatus setObject:@"ft"                         forKey:@"AltitudeMeasure"];
    
    //Elevation
    [workoutStatus setObject:@"Elevation"                   forKey:@"Elevation"];
    [workoutStatus setObject:@"icon_sports_elevation"       forKey:@"ElevationIcon"];
    [workoutStatus setObject:@"ft"                          forKey:@"ElevationMeasure"];
    
    
    m_trackableObjects = [[NSArray alloc] initWithObjects:@"Heart", @"AvgHeart", @"MaxHeart", @"Calories", @"Distance", @"Altitude", @"Elevation", @"Totd", @"Speed", @"AvgSpeed", @"TopSpeed", @"Pace", @"AvgPace", @"CurrentLap", @"AvgLap", @"BestLap", nil];
    
}

#pragma mark TIMER

-(void) resetTimer
{
    sportsTimer.text = [NSString stringWithFormat:@"00:00:00"];
}

#pragma mark UTILITY FUNCTIONS


-(int8_t)getByteValue:(NSString*)p_key
{
    if ( [p_key isEqualToString:@"---"] ) return (int8_t)0;
    else if ( [p_key isEqualToString:@"Speed"] ) return (int8_t)1;
    else if ( [p_key isEqualToString:@"Heart"] ) return (int8_t)2;
    else if ( [p_key isEqualToString:@"Calories"] ) return (int8_t)3;
    else if ( [p_key isEqualToString:@"Distance"] ) return (int8_t)4;
    else if ( [p_key isEqualToString:@"AvgSpeed"] ) return (int8_t)5;
    else if ( [p_key isEqualToString:@"Altitude"] ) return (int8_t)6;
    else if ( [p_key isEqualToString:@"Totd"] ) return (int8_t)7;
    else if ( [p_key isEqualToString:@"Top Speed"] ) return (int8_t)8;
    else if ( [p_key isEqualToString:@"Cadence"] ) return (int8_t)9;
    else if ( [p_key isEqualToString:@"Pace"] ) return (int8_t)10;
    else if ( [p_key isEqualToString:@"AvgHeart"] ) return (int8_t)11;
    else if ( [p_key isEqualToString:@"MaxHeart"] ) return (int8_t)12;
    else if ( [p_key isEqualToString:@"Elevation"] ) return (int8_t)13;
    else if ( [p_key isEqualToString:@"CurrentLap"] ) return (int8_t)14;
    else if ( [p_key isEqualToString:@"BestLap"] ) return (int8_t)15;
    else if ( [p_key isEqualToString:@"Floor"] ) return (int8_t)16;
    else if ( [p_key isEqualToString:@"Steps"] ) return (int8_t)17;
    else if ( [p_key isEqualToString:@"AvgPace"] ) return (int8_t)18;
    else if ( [p_key isEqualToString:@"AvgLap"] ) return (int8_t)19;
    else  return (int8_t)1;
}

- (UIImage *)imageNamed:(NSString *)p_name withColor:(UIColor *)p_color
{
    
    // load the image
    NSString *name = p_name;
    UIImage *img = [UIImage imageNamed:name];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [p_color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

#pragma mark TOUCH SECTION
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //Iterate through your subviews, or some other custom array of view
    
    UITouch *touch = [touches anyObject];
    
    if ( [touch.view isKindOfClass:[SVGKFastImageView class]])
    {
        SVGKFastImageView *tappedBtn = (SVGKFastImageView*)touch.view;
        
        switch ([tappedBtn.superview tag]) {
            case 1:
                //TRASHBTN
                [self setTileCountTo:currentNumberOfTiles <= 3 ? 3 : --currentNumberOfTiles];
                
                break;
            case 2:
                //REFRESHBTN
                
                break;
            case 3:
                //ADDBTN
                [self setTileCountTo:currentNumberOfTiles >= 5 ? 5 : ++currentNumberOfTiles];
                break;
            default:
                break;
        }
        
    }
    
    for (UIView *view in self.view.subviews)
        [view resignFirstResponder];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
