//
//  KreyosSVGButton.m
//  KreyosIosApp
//
//  Created by KrisJulio on 3/14/14.
//  Copyright (c) 2014 KrisJulio. All rights reserved.
//

#import "KreyosSVGButton.h"
#import "SVGKImage.h"
#import "SVGKLayeredImageView.h"

@implementation KreyosSVGButton



- (void) awakeFromNib
{
    if ( [self restorationIdentifier] )
        [self addSVGOnThisButton:[self restorationIdentifier]];
}

- (void) addSVGOnThisButton : (NSString*)svgName
{
    SVGKImage *svgImage = [SVGKImage imageNamed:svgName];
    
    [svgImage setSize:self.bounds.size];
    
    SVGKFastImageView *imageSet = [[SVGKFastImageView alloc] initWithSVGKImage:svgImage];
    
    imageSet.userInteractionEnabled = false;
    
    [self addSubview: imageSet];

}


@end
