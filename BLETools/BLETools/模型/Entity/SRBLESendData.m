//
//  SRBLESendData.m
//  Mizward
//
//  Created by zhangjunbo on 15/8/27.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRBLESendData.h"
#import "SRBLECoder.h"
#import "SRBLEEnum.h"

@implementation SRBLESendData


//心跳数据
+ (SRBLESendData *)buildHeart{
    return [[SRBLESendData alloc] initWithTerminalType:SRBLETerminalType_Ble
                                  operationMessageType:SRBLEMessageType_Execute
                                  operationInstruction:SRBLEOperationInstruction_HEART
                        operationInstructionParamenter:nil];

}


//蓝牙认证数据查询
+ (SRBLESendData *)queryBleAuthData{
    return [[SRBLESendData alloc] initWithTerminalType:SRBLETerminalType_Ble
                                  operationMessageType:SRBLEMessageType_Query
                                  operationInstruction:SRBLEOperationInstruction_A605
                        operationInstructionParamenter:nil];

}

//蓝牙认证
+ (SRBLESendData *)bleAuthDataWithID:(NSInteger)idNumber
{
    return [[SRBLESendData alloc] initWithTerminalType:SRBLETerminalType_Ble
                                  operationMessageType:SRBLEMessageType_Execute
                                  operationInstruction:SRBLEOperationInstruction_A606
                        operationInstructionParamenter:[SRBLECoder BLEAuthStringWithID:idNumber]];
}

//大数据申请
+ (SRBLESendData *)bleBigDataRequest
{
    return [[SRBLESendData alloc] initWithTerminalType:SRBLETerminalType_Ble
                                  operationMessageType:SRBLEMessageType_Publish
                                  operationInstruction:SRBLEOperationInstruction_A607
                        operationInstructionParamenter:nil];
}

//设备连接状态
+ (SRBLESendData *)terminalConnectionStatus
{
    return [[SRBLESendData alloc] initWithTerminalType:SRBLETerminalType_Ble
                                  operationMessageType:SRBLEMessageType_Query
                                  operationInstruction:SRBLEOperationInstruction_A304
                        operationInstructionParamenter:nil];
}

//查询ID及密钥
+ (SRBLESendData *)queryEncryptionInfo
{
    return [[SRBLESendData alloc] initWithTerminalType:SRBLETerminalType_Broadcast
                                  operationMessageType:SRBLEMessageType_Query
                                  operationInstruction:SRBLEOperationInstruction_B203
                        operationInstructionParamenter:nil];
}

//设置ID及密钥
+ (SRBLESendData *)configDataWithID:(NSString *)idStr
                             andKey:(NSString *)keyStr
{
    return [[SRBLESendData alloc] initWithTerminalType:SRBLETerminalType_Broadcast
                                  operationMessageType:SRBLEMessageType_Config
                                  operationInstruction:SRBLEOperationInstruction_B203
                        operationInstructionParamenter:[NSString stringWithFormat:@"%@,%@", idStr, keyStr]];
}

//查询控制滚动码
+ (SRBLESendData *)queryControlNumber
{
    return [[SRBLESendData alloc] initWithTerminalType:SRBLETerminalType_Broadcast
                                  operationMessageType:SRBLEMessageType_Query
                                  operationInstruction:SRBLEOperationInstruction_B502
                        operationInstructionParamenter:nil];
}

//控制
+ (SRBLESendData *)dataWithControlInstruction:(SRBLEInstruction)instruction controlNumber:(UInt16)controlNumber key:(NSString *)keyStr idStr:(NSString *)idStr
{

    return [[SRBLESendData alloc] initWithTerminalType:SRBLETerminalType_Broadcast
                                  operationMessageType:SRBLEMessageType_Publish
                                  operationInstruction:SRBLEOperationInstruction_B502
                         operationInstructionParamenter:[SRBLECoder controlDataWithID:idStr
                                                                                  key:keyStr
                                                                              Command:instruction
                                                                      andSerialNumber:controlNumber/*[SRUserDefaults bleSerialNumber]*/]];
}

//状态查询
+ (SRBLESendData *)dataWithQueryStatus
{
    return [[SRBLESendData alloc] initWithTerminalType:SRBLETerminalType_Broadcast
                                  operationMessageType:SRBLEMessageType_Query
                                  operationInstruction:SRBLEOperationInstruction_B301
                        operationInstructionParamenter:nil];
}

//终端基本信息查询
+ (SRBLESendData *)queryTerminalBasicInfo
{
    return [[SRBLESendData alloc] initWithTerminalType:SRBLETerminalType_Broadcast
                                  operationMessageType:SRBLEMessageType_Query
                                  operationInstruction:SRBLEOperationInstruction_B101
                        operationInstructionParamenter:nil];
}

//回复
+ (SRBLESendData *)dataWithAckTerminalType:(SRBLETerminalType)terminalType
                      operationInstruction:(SRBLEOperationInstruction)operationInstruction;
{
    return [[SRBLESendData alloc] initWithTerminalType:terminalType
                                   operationMessageType:SRBLEMessageType_Publish_Confirm
                                   operationInstruction:operationInstruction
                         operationInstructionParamenter:nil];
}


//通用
+ (SRBLESendData *)dataWithTerminalType:(SRBLETerminalType)terminalType
                   operationMessageType:(SRBLEMessageType)operationMessageType
                   operationInstruction:(SRBLEOperationInstruction)operationInstruction
         operationInstructionParamenter:(NSString *)operationInstructionParamenter
{
    return [[SRBLESendData alloc] initWithTerminalType:terminalType
                                   operationMessageType:operationMessageType
                                   operationInstruction:operationInstruction
                         operationInstructionParamenter:operationInstructionParamenter];
}


- (instancetype)initWithTerminalType:(SRBLETerminalType)terminalType
                operationMessageType:(SRBLEMessageType)operationMessageType
                operationInstruction:(SRBLEOperationInstruction)operationInstruction
      operationInstructionParamenter:(NSString *)operationInstructionParamenter
{
    if (self = [super init]) {
        self.terminalType = terminalType;
        self.operationMessageType = operationMessageType;
        self.operationInstruction = operationInstruction;
        self.operationInstructionParamenter = operationInstructionParamenter;
    }
    
    return self;
}

- (BOOL)needAck
{
    //SRBLEMessageType_Query SRBLEMessageType_Config SRBLEMessageType_Publish 需要应答
    if (self.operationMessageType == SRBLEMessageType_Query_Ack
        || self.operationMessageType == SRBLEMessageType_Config_Ack
        || self.operationMessageType == SRBLEMessageType_Execute
        || self.operationMessageType == SRBLEMessageType_Na
        || self.operationMessageType == SRBLEMessageType_Publish_Confirm) {
        return NO;
    } else {
        return YES;
    }
}

- (NSData *)dataValue {
    
    // *校验#消息类型#标签1,参数…#
    
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"#%x", self.terminalType];
    [string appendFormat:@"#%x#%x", self.operationMessageType, self.operationInstruction];
    if (self.operationInstructionParamenter && self.operationInstructionParamenter.length>0) {
        [string appendFormat:@",%@", self.operationInstructionParamenter];
    }
    [string appendString:@"#"];
    
    __block UInt8 crc = 0;
    dispatch_apply(string.length, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
        if (index==0) {
            return ;
        }
        crc += [string characterAtIndex:index];
    });
    
    [string insertString:[NSString stringWithFormat:@"*%x", crc&0xff] atIndex:0];
    
    [string appendString:[SRBLEData transferEndFlagString]];
    
    //SRLogDebug(@"【蓝牙】发送数据>>>>>>>>>>>>>>>>>>>%@", string);
    
    NSData *originalData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    //长度大于kMaxBLEPacketLength 需要分片
    //FLAG_XXXXXXXX_结束符,首尾要占用2个字节
    NSInteger packetLength = kMaxBLEPacketLength - 2;
    NSInteger count = originalData.length/packetLength + (originalData.length%packetLength==0?0:1);
    NSInteger newLength = originalData.length + count*2;
    NSMutableData *packetedData = [NSMutableData dataWithLength:newLength];
    
    dispatch_apply(count, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
        @autoreleasepool {
            NSMutableData *newPacketed = [NSMutableData data];
            SRBLEPacketFlag flag;
            if (index == 0 && index == count-1) {
                flag = SRBLEPacketFlag_Start_End;
            } else if (index == 0) {
                flag = SRBLEPacketFlag_Start;
            } else if (index == count-1) {
                flag = SRBLEPacketFlag_End;
            } else {
                flag = SRBLEPacketFlag_Middle;
            }
            [newPacketed appendData:[[NSString stringWithFormat:@"%x", flag]
                                     dataUsingEncoding:NSUTF8StringEncoding]];
            NSInteger length = index*packetLength+packetLength>originalData.length?(originalData.length-index*packetLength):packetLength;
            [newPacketed appendData:[originalData subdataWithRange:NSMakeRange(index*packetLength, length)]];
            [newPacketed appendData:[SRBLEData transferEndFlagData]];
            [packetedData replaceBytesInRange:NSMakeRange(index*kMaxBLEPacketLength, newPacketed.length)
                                    withBytes:newPacketed.bytes];
//            SRLogDebug(@">>>>>>%@", [[NSString alloc] initWithData:newPacketed encoding:NSUTF8StringEncoding]);
        }
    });
    
    NSLog(@"蓝牙发送数据:%@\n",[[NSString alloc]initWithData:packetedData encoding:NSUTF8StringEncoding]);
    return packetedData;
}

@end
