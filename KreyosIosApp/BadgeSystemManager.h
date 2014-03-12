//
//  BadgeSystemManager.h
//  KreyosIosApp
//
//  Created by KrisJulio on 3/10/14.
//  Copyright (c) 2014 KrisJulio. All rights reserved.
//

#import "KreyosUIViewBaseViewController.h"

@interface BadgeSystemManager : KreyosUIViewBaseViewController
{
    
}

@property (retain, readwrite) NSMutableArray *BadgeArray;

+(BadgeSystemManager*) sharedInstance;
- (void) loadBadgesOnHomePage;
- (NSMutableArray*) getBadges;

@end
