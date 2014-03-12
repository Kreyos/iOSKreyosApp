//
//  SVGFactoryManager.h
//  KreyosIosApp
//
//  Created by KrisJulio on 3/10/14.
//  Copyright (c) 2014 KrisJulio. All rights reserved.
//

#import "KreyosUIViewBaseViewController.h"

@interface SVGFactoryManager : KreyosUIViewBaseViewController

-(SVGKLayeredImageView*) createSVGImage:(NSString*)imageName;
+(SVGFactoryManager*) sharedInstance;

@end
