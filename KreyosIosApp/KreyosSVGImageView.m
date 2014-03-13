//
//  KreyosSVGImageView.m
//  KreyosIosApp
//
//  Created by KrisJulio on 3/13/14.
//  Copyright (c) 2014 KrisJulio. All rights reserved.
//

#import "KreyosSVGImageView.h"
#import "SVGKImage.h"
#import "SVGKFastImageView.h"

@implementation KreyosSVGImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"HELLO UIIMAGE");
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        
        [self setImageAsSVGImage:[self restorationIdentifier]];
    }
    return self;
}

- (void) setImageAsSVGImage : (NSString*) p_svgName
{
    SVGKImage *svgImage = [SVGKImage imageNamed:p_svgName];
    
    SVGKFastImageView *imageSet = [[SVGKFastImageView alloc] initWithSVGKImage:svgImage];
    imageSet.layer.anchorPoint = CGPointMake(0, 0.5);
    imageSet.transform = CGAffineTransformScale(imageSet.transform, 1.5f, 1.5f);
    
    
    [self addSubview: imageSet];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
