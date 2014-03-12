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

@interface SportsPageViewController ()
{
    
}
@end

@implementation SportsPageViewController
{
    NSMutableDictionary *workoutStatus;
    NSMutableArray* m_cellValueStorage;
    
    NSArray *m_trackableObjects;
    
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
  
    dataHolder.layer.cornerRadius = 10;
    timerState = TimeStop;
    
    [self setTileCountTo:5];
    [self setUpSportsButtons];
    [self setStatus];
    
    [self setUpCellButtons:cell_1];
    [self setUpCellButtons:cell_2];
    [self setUpCellButtons:cell_3];
    [self setUpCellButtons:cell_4];
    
}

- (void) setUpSportsButtons
{
    //Set Up ADD CELL BUTTON
    SVGKFastImageView *addImage = [[SVGFactoryManager sharedInstance] createSVGImage:@"add_button"];
    addImage.layer.anchorPoint = CGPointMake(1, 1);
    addImage.transform = CGAffineTransformScale(addImage.transform, 0.4f, 0.5f);
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

-(IBAction)updateTimer:(UIButton*)sender
{
    switch([sender tag])
    {
        case TimeStart: //Timer start
            
            if ( ![[KreyosBluetoothViewController sharedInstance] isDeviceConnectedToBT] )
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Device Detected" message:@"Please connect first your Kreyos Watch" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                return;
            }
            
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
        
        int fSize = 0;
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
                
                fSize = 50;
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
                
                cell_3.transform = CGAffineTransformMakeScale(1, 1);
                cell_3.frame = CGRectMake(xPos,
                                          cell_2.frame.origin.y + cell_2.frame.size.height,
                                          fourGridSize.width,
                                          fourGridSize.height);
                
                cell_4.transform = CGAffineTransformMakeScale(0, 0);
                
                fSize = 30;
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
                
                cell_4.transform = CGAffineTransformMakeScale(1, 1);
                cell_4.frame = CGRectMake(fiveGridSize.width,
                                          yPos + cell_1.frame.size.height,
                                          fiveGridSize.width,
                                          fiveGridSize.height);
                
                
                fSize = 50;
                break;
                
            default:
                break;
                
        }
        [self updateTextScale:(fSize)];
       
        
    } completion:^(BOOL finished) {
        
        //set current tile num
        currentNumberOfTiles = count;
    }];
    
}

-(void) updateTextScale : (int) p_size
{
    NSArray *viewArray = [NSArray arrayWithObjects:cell_1, cell_2, cell_3, cell_4, nil];
    for( UIView *view in viewArray)
    {
        for ( UILabel *label in [view subviews] ) {
            if( [label isKindOfClass:[ UILabel class] ] && [label tag] == 4 )
            {
                [label setFont:REGULAR_FONT_WITH_SIZE(p_size)];
            }
        }
    }
}

-(void) resetTimer
{
    sportsTimer.text = [NSString stringWithFormat:@"00:00:00"];
}


#pragma SET STATUS

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

#pragma mark UTILITY FUNCTIONS

-(void) updateWorkOutData:(int32_t[5])p_data
{
    
    for (UILabel *lbl  in [cell_1 subviews]) {
        UILabel *label = (UILabel*)lbl;
        if ( label.tag == CATEG_DATA_TAG )
        {
            label.text = [NSString stringWithFormat:@"%d", p_data[1]];
        }
    }
    for (UILabel *lbl  in [cell_2 subviews]) {
        UILabel *label = (UILabel*)lbl;
        if ( label.tag == CATEG_DATA_TAG )
        {
            label.text = [NSString stringWithFormat:@"%d", p_data[2]];
        }
    }
    for (UILabel *lbl  in [cell_3 subviews]) {
        UILabel *label = (UILabel*)lbl;
        if ( label.tag == CATEG_DATA_TAG )
        {
            label.text = [NSString stringWithFormat:@"%d", p_data[3]];
        }
    }
    for (UILabel *lbl  in [cell_4 subviews]) {
        UILabel *label = (UILabel*)lbl;
        if ( label.tag == CATEG_DATA_TAG )
        {
            label.text = [NSString stringWithFormat:@"%d", p_data[4]];
        }
    }
}

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
        NSLog(@"SVGKFASTIMAGE SPORTS!!");
        
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
