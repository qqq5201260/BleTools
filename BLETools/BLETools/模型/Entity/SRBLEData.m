//
//  SRBLEData.m
//  Mizward
//
//  Created by zhangjunbo on 15/8/26.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRBLEData.h"

@implementation SRBLEData

+ (NSString *)transferEndFlagString
{
    return [NSString stringWithFormat:@"%c", 0];
}

+ (NSData *)transferEndFlagData
{
    Byte byte[] = {0x00};
    return  [[NSData alloc] initWithBytes:byte length:sizeof(byte)];
}

@end
