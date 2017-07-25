//
//  SRBLEReceivedData.m
//  Mizward
//
//  Created by zhangjunbo on 15/8/27.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRBLEReceivedData.h"
#import "SRBLEVehicleStatus.h"
#import "SRBLEEncryptionInfo.h"
#import "SRBLEControlResult.h"
#import "SRBLEBluetoothInfo.h"

@implementation SRBLEReceivedData

- (instancetype)initWithData:(NSString *)string
{
    // *校验#消息类型#标签1,参数…##
    // *ff#8#b501#
    
//    NSLog(@"蓝牙接收到的数据:%@\n",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
//    //CRC校验
//    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //SRLogDebug(@"【蓝牙】接收数据<<<<<<<<<<<<<<<<<<<<<<%@", string);
    
    NSRange crcRange = [string rangeOfString:@"#"];
    if (crcRange.location == NSNotFound) {
        return nil;
    }
    NSString *crcStr = [string substringWithRange:NSMakeRange(1, crcRange.location-1)];
    
    NSString *sub = [string substringFromIndex:crcRange.location+crcRange.length];
    
    //如果第一位 不大于2 && b301 跳过（远键上报状态有问题）
    NSArray *arr=[sub componentsSeparatedByString:@","];
    NSString *firstObj = arr[0];
    NSInteger first = [sub substringWithRange:NSMakeRange(0, 1)].integerValue;;
//    NSLog(@"first %ld %@",(long)first , firstObj);
    
    if ([firstObj hasSuffix:@"b301"] && first <= 2) {
        return nil;
    }
    
    
    __block UInt8 crcCalculate = 0;
    dispatch_apply(sub.length, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
        crcCalculate += [sub characterAtIndex:index];
    });
    
    NSString *crcCalculateStr = [NSString stringWithFormat:@"%x", crcCalculate&0xff];
    
    if (crcStr.integerValue != crcCalculateStr.integerValue) {
       // SRLogError(@"【蓝牙】CRC校验错误，接收：%@--->计算：%@", crcStr, crcCalculateStr);
        return nil;
    }
    
    self = [super init];

    NSArray *parameters = [sub componentsSeparatedByString:@"#"];
    if (parameters.count < 3) {
        return nil;
    }
    self.terminalType = [parameters[0] integerValue];
    self.operationMessageType = [parameters[1] integerValue];
    
    NSRange range = [parameters[2] rangeOfString:@","];
    if (range.location != NSNotFound) {
        self.operationInstruction = strtoul([parameters[2] substringToIndex:range.location].UTF8String, 0, 16);
        self.operationInstructionParamenter = [parameters[2] substringFromIndex:range.location+1];
    } else {
        self.operationInstruction = strtoul([parameters[2] UTF8String], 0, 16);
    }
    
    return self;
}

- (SRBLEVehicleStatus *)vehicleStatus
{
    if (self.operationInstruction != SRBLEOperationInstruction_B301)
        return nil;
    
    return [[SRBLEVehicleStatus alloc] initWithParameters:[self.operationInstructionParamenter componentsSeparatedByString:@","]];
}

- (SRBLEControlResult *)controlResult
{
    if (self.operationInstruction != SRBLEOperationInstruction_B402) {
        return nil;
    }
    
    return [[SRBLEControlResult alloc] initWithParameters:[self.operationInstructionParamenter componentsSeparatedByString:@","]];
}

- (SRBLEEncryptionInfo *)encryptionInfo
{
    if (self.operationInstruction != SRBLEOperationInstruction_B203)
        return nil;
    
    return [[SRBLEEncryptionInfo alloc] initWithParameters:[self.operationInstructionParamenter componentsSeparatedByString:@","]];
}

- (SRBLEBluetoothInfo *)bluetoothInfo
{
    if (self.operationInstruction != SRBLEOperationInstruction_A605) {
        return nil;
    }
    
    return [[SRBLEBluetoothInfo alloc] initWithParameters:[self.operationInstructionParamenter componentsSeparatedByString:@","]];
}

- (NSInteger)controlNumber
{
    if (self.operationInstruction != SRBLEOperationInstruction_B502) {
        return 0;
    }
    
    return strtoul(self.operationInstructionParamenter.UTF8String, 0, 16);
}

@end
