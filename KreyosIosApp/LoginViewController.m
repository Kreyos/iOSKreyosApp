//
//  LoginViewController.m
//  KreyosIosApp
//
//  Created by KrisJulio on 3/6/14.
//  Copyright (c) 2014 KrisJulio. All rights reserved.
//

#import "LoginViewController.h"
#import "KreyosHomeViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "KreyosFacebookController.h"
#import "AppDelegate.h"
#import "KreyosUtility.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize _facebookBtn;

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
    [super hideNavigationItem:self];
    
    //Add Login FB
    FBLoginView *fbLogin = [[FBLoginView alloc] init];
    fbLogin.frame = _facebookBtn.frame;
    fbLogin.frame = CGRectMake(_facebookBtn.frame.origin.x, _facebookBtn.frame.origin.y, fbLogin.frame.size.width, fbLogin.frame.size.height);
    fbLogin.delegate = self;
    
    ADD_TO_ROOT_VIEW(fbLogin);
    // Do any additional setup after loading the view.
}

#pragma mark FACEBOOK LOGIN

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [FBLoginView class];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSLog(@"Fetched User Info ");
    [KreyosFacebookController sharedInstance].FbUser = user;
    
    
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    
}

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    NSLog(@"Logged Out user");
    
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    AppDelegate *deleg =  (AppDelegate* )[[UIApplication sharedApplication] delegate];
    NSLog(@"Error %@", error);
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        
        [[KreyosFacebookController sharedInstance] releaseData];
        // If the session state is not any of the two "open" states when the button is clicked
    }
    
    if (! [deleg isConnectedToWifi] ) return;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
