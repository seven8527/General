//
//  ListItem.m
//  POHorizontalList
//
//  Created by Polat Olu on 15/02/2013.
//  Copyright (c) 2013 Polat Olu. All rights reserved.
//

#import "ListItem.h"
#import "UIColor+Hex.h"

@implementation ListItem

- (id)initWithFrame:(CGRect)frame imageView:(UIImageView *)imageView text:(NSString *)imageTitle selectedId:(NSString *)selectedId
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setUserInteractionEnabled:YES];
        
        self.imageTitle = imageTitle;
        self.image = imageView.image;
        self.selectedId = selectedId;

        CALayer *roundCorner = [imageView layer];
        [roundCorner setMasksToBounds:YES];
        [roundCorner setCornerRadius:36.0];
        [roundCorner setBorderColor:[UIColor colorFromHexRGB:@"d1d1d1"].CGColor];//[UIColor blackColor].CGColor];
        [roundCorner setBorderWidth:1.0];
        
        UILabel *title = [[UILabel alloc] init];
        [title setBackgroundColor:[UIColor clearColor]];
        [title setFont:[UIFont boldSystemFontOfSize:12.0]];
        [title setOpaque: NO];
        [title setText:imageTitle];
        
        imageRect = CGRectMake(0.0, 0.0, 72.0, 72.0);
        textRect = CGRectMake(15.0, imageRect.origin.y + imageRect.size.height + 10.0, 80.0, 20.0);
        
        [title setFrame:textRect];
        [imageView setFrame:imageRect];
        
        [self addSubview:title];
        [self addSubview:imageView];
    }
    
    return self;
}

@end
