//
//  KreyosFacebookController.h
//  kreyos_watch
//
//  Created by KrisJulio on 1/4/14.
//  Copyright (c) 2014 kreyos. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "KreyosUIViewBaseViewController.h"

@interface KreyosFacebookController : KreyosUIViewBaseViewController
{
    
}
-(void) releaseData;

+(KreyosFacebookController*) sharedInstance;
-(NSString*)getUserID;
-(NSString*)getUserName;
-(NSString*)getFirstName;
-(NSString*)getSurName;
-(NSString*)getBirthday;
-(NSString*)getLocation;

@property (retain, nonatomic) id<FBGraphUser> FbUser;

@end
