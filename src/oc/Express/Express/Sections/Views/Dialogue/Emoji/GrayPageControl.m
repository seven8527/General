//
//  GrayPageControl.m
//


#import "GrayPageControl.h"
@implementation GrayPageControl
-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    activeImage = [UIImage imageNamed:@"inactive_page_image"];
    inactiveImage = [UIImage imageNamed:@"active_page_image"];
    [self setCurrentPage:1];
    return self;
}

- (id)initWithFrame:(CGRect)aFrame {
    
	if (self = [super initWithFrame:aFrame]) {
        activeImage = [UIImage imageNamed:@"inactive_page_image"] ;
        inactiveImage = [UIImage imageNamed:@"active_page_image"];
        [self setCurrentPage:1];
	}
	
	return self;
}

-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        if ([[self.subviews objectAtIndex:i] isKindOfClass:[UIImageView class]]) {
            UIImageView* dot = [self.subviews objectAtIndex:i];
            if (i == self.currentPage) dot.image = activeImage;
            else dot.image = inactiveImage;
        }
        
    }
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

@end