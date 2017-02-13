
//
//  NSUserDefautSet.m
//  MercyMap
//
//  Created by sunshaoxun on 16/4/20.
//  Copyright © 2016年 Wispeed. All rights reserved.
//

#import "NSUserDefautSet.h"

@implementation NSUserDefautSet

-(void)loginDataStorage:(int)UID Token:(NSString *)Token
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"ID"];
    [defaults removeObjectForKey:@"Token"];
    
    [defaults setInteger:UID forKey:@"ID"];
    [defaults setObject:Token forKey:@"Token"];
    [defaults setObject:[NSNumber numberWithBool:YES] forKey:@"UserLogin"];
    [defaults synchronize];
}

@end
