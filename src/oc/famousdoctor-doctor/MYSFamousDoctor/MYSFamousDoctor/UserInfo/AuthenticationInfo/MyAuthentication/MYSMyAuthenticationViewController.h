//
//  MYSMyAuthenticationViewController.h
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "BaseViewController.h"

@interface MYSMyAuthenticationViewController : BaseViewController
{
    IBOutlet UIImageView *mImage;
    
    NSString *mURL;
}

- (void)sendValue:(NSString *)url;

@end
