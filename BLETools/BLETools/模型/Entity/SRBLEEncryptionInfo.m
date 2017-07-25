//
//  SRBLEEncryptionInfo.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/10.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRBLEEncryptionInfo.h"

@implementation SRBLEEncryptionInfo

- (instancetype)initWithParameters:(NSArray *)parameters
{
    if (self = [super init]) {
        NSString *idStr = (parameters&&parameters.count>0)?parameters.firstObject:nil;
        NSString *keyCRC = (parameters&&parameters.count>1)?parameters.lastObject:nil;
        
        if (idStr.length>0) {
//            while ([idStr hasPrefix:@"0"]) {
//                idStr = [idStr substringFromIndex:1];
//            }
            
            _idStr = [idStr stringByReplacingOccurrencesOfString:@"\0" withString:@""];
        }
        
        if (keyCRC.length>0) {
//            while ([keyCRC hasPrefix:@"0"]) {
//                keyCRC = [keyCRC substringFromIndex:1];
//            }
            
            _keyCRC = [keyCRC stringByReplacingOccurrencesOfString:@"\0" withString:@""];
        }
    }
    
    return self;
}

- (BOOL)isIdStrCorrect:(NSString *)idStr {
    while ([idStr hasPrefix:@"0"]) {
        idStr = [idStr substringFromIndex:1];
    }
    
    NSString *local = self.idStr;
    while ([local hasPrefix:@"0"]) {
        local = [local substringFromIndex:1];
    }
    
    return [idStr isEqualToString:local];
}

- (BOOL)isKeyCorrect:(NSString *)keyStr
{
    if (!self.keyCRC) {
        return NO;
    }
    
    __block UInt8 crcCalculate = 0;
    
    NSMutableString *idStr = [NSMutableString stringWithString:self.idStr];
    if (idStr.length%2!=0) {
        [idStr insertString:@"0" atIndex:0];
    }
    
    for (NSInteger idx = 0; idx+2 <= idStr.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString * hexStr = [idStr substringWithRange:range];
        crcCalculate += strtoul(hexStr.UTF8String, 0, 16);
    }
    
    NSMutableString *newKeyStr = [NSMutableString stringWithString:keyStr];
    if (newKeyStr.length%2!=0) {
        [newKeyStr insertString:@"0" atIndex:0];
    }
    for (NSInteger idx = 0; idx+2 <= newKeyStr.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString * hexStr = [newKeyStr substringWithRange:range];
        crcCalculate += strtoul(hexStr.UTF8String, 0, 16);
    }
       
    NSString *crcCalculateStr = [NSString stringWithFormat:@"%x", crcCalculate&0xff];
    
    return self.keyCRC.integerValue == crcCalculateStr.integerValue;
}

@end
