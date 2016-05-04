//
//  NSString+MD5HexDigest.h
//  Express
//
//  Created by owen on 15/11/4.
//  Copyright © 2015年 owen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>  

@interface NSString(md5)

-(NSString *)md5HexDigest;

@end
