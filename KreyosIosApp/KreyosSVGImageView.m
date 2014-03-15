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
    
    [svgImage setSize:self.bounds.size];
    
    SVGKFastImageView *imageSet = [[SVGKFastImageView alloc] initWithSVGKImage:svgImage];
    
    UIButton *IASDA = [[UIButton alloc] init];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.superclass action:@selector(tapHandler:)];
    //imageSet addGestureRecognizer:<#(UIGestureRecognizer *)#>
    
    [self addSubview: imageSet];
}


@end
