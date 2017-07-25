//
//  SRBLECoder.m
//  Mizward
//
//  Created by zhangjunbo on 15/8/25.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#include "Ht2crypt_btk.h"
//#import "BLEConfig.h"
#import "SRBLEEnum.h"
#import "SRBLECoder.h"
//#import "SRBLEHeader.h"



@implementation SRBLECoder

+ (NSData *)hexStringToData:(NSString *)str {
    NSMutableData* data = [NSMutableData data];
    for (NSInteger idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

+ (NSString *)dataToHexString:(NSData *)data{
    Byte *bytes = (Byte *)[data bytes];
    NSMutableString *hexStr = [NSMutableString string];
    for(NSInteger idx = 0; idx < data.length; ++idx) {
//        if(0 == bytes[idx]) {break;}
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[idx]&0xff];
        [hexStr appendString:newHexStr.length>1?newHexStr:[NSString stringWithFormat:@"0%@", newHexStr]];
    }
    NSLog(@"%@",hexStr);
    
    return hexStr;
}

+ (NSString *)controlDataWithID:(NSString *)idStr
                            key:(NSString *)keyStr
                        Command:(SRBLEInstruction)command
                andSerialNumber:(UInt16)serialNumber
{
    //加密去掉开始的0
//    while ([idStr hasPrefix:@"0"]) {
//        idStr = [idStr substringFromIndex:1];
//    }
//    
//    while ([keyStr hasPrefix:@"0"]) {
//        keyStr = [keyStr substringFromIndex:1];
//    }
    
    NSData *idData = [self hexStringToData:idStr];
    Byte *idByte = (Byte *)[idData bytes];
    
    NSData *keyData = [self hexStringToData:keyStr];
    Byte *keyByte = (Byte *)[keyData bytes];
    
    UInt8 data[8];
    
    memset(data, 0x00, sizeof(data));
    
    //前3个字节为密钥
    memcpy(data, idByte, MIN(idData.length, 3));
//    NSData *test1 = [NSData dataWithBytes:data length:sizeof(data)];

    //最后2字节为滚动码
    data[6] = serialNumber>>8&0xff;
    data[7] = serialNumber&0xff;
//    NSData *test2 = [NSData dataWithBytes:data length:sizeof(data)];
    
    //第4个字节和最后一个字节相同
    data[3] = data[7];
//    NSData *test3 = [NSData dataWithBytes:data length:sizeof(data)];
    
    //4字节 == 0字节, 5字节高3位==1字节高3位, 5字节低位 == command&0x0f
    data[4] = data[0];
//    data[5] = (data[5]&0xF0)|(command&0x0F);
//    data[5] = (data[5]&0x1F)|(data[1]&0xE0);
    data[5] = command;
//    NSData *test4 = [NSData dataWithBytes:data length:sizeof(data)];
    
//    NSData *before = [NSData dataWithBytes:data length:sizeof(data)];
    
    //加密
    sr_Oneway1_ext(data, keyByte);
//    NSData *after1 = [NSData dataWithBytes:data length:sizeof(data)];
//    NSString *test1 = [self dataToHexString:[NSData dataWithBytes:data length:sizeof(data)]];
//    NSLog(@"sr_Oneway1_ext->%@", test1);
    
    sr_Oneway2(&data[4],32);
    
//    NSData *after = [NSData dataWithBytes:data length:sizeof(data)];
//    NSString *test = [self dataToHexString:[NSData dataWithBytes:data length:sizeof(data)]];
//    NSLog(@"sr_Oneway2->%@", test);
    
//    //解密
//    Oneway1_ext(data, keyByte);
//    Oneway2(&data[4],32);
    
//    NSString *test = [self dataToHexString:[NSData dataWithBytes:data length:sizeof(data)]];
    
    return [self dataToHexString:[NSData dataWithBytes:data length:sizeof(data)]];
}

+ (NSString *)BLEAuthStringWithID:(NSInteger)authID {
    if (authID == 0) {
        return nil;
    }
    
    authID += 0x13572468;
    authID ^= 0x50A00A05;

    UInt8 auth_unit[4] = {0};
    for(NSInteger i = 0; i < sizeof(auth_unit); i++) {
        auth_unit[i] = authID>>(8*i);
    }
    
    NSData *keyData = [kBTUAuth dataUsingEncoding:NSUTF8StringEncoding];
    Byte *keyByte = (Byte *)[keyData bytes];
    NSInteger i, j;
    for( i = 0, j = 0; i < keyData.length; i++,j++) {
        if (j >= 4) {j = 0;}
        keyByte[i] -= auth_unit[j];
    }
    
//    NSLog(@"%@", [self dataToHexString:[[NSData alloc] initWithBytes:keyByte length:/*sizeof(keyByte)*/keyData.length-1]]);
    return [self dataToHexString:[[NSData alloc] initWithBytes:keyByte length:keyData.length]];
    
}





@end
