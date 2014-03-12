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

@interface KreyosHomeViewController ()
{
    CGPoint point;
    CGPoint movePoint;
    
    SVGKLayeredImageView *inFrontBadge;
    NSMutableArray *badgeItems;
    NSMutableArray *items;
}
@end

@implementation KreyosHomeViewController

@synthesize GoalTab;
@synthesize goalView;
@synthesize badgeImageHolder;
@synthesize carouselView;

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
