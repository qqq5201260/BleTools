//
//  SRBLECoder.h
//  Mizward
//
//  Created by zhangjunbo on 15/8/25.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRBLEEnum.h"
#import "FZKEnum.h"

@interface SRBLECoder : NSObject

/**
 *  控制指令加密
 *
 *  @param idStr        加密ID
 *  @param keyStr       加密密钥
 *  @param command      指令
 *  @param serialNumber 序列号
 *
 *  @return 加密后的控制指令
 */
+ (NSString *)controlDataWithID:(NSString *)idStr
                            key:(NSString *)keyStr
                        Command:(SRBLEInstruction)command
                andSerialNumber:(UInt16)serialNumber;
/**
 *  蓝牙认证
 *
 *  @param authID 认证ID
 *
 *  @return 加密后的ID
 */
+ (NSString *)BLEAuthStringWithID:(NSInteger)authID;


/**
 tcp  http 控制指令转换为蓝牙控制指令

 @param tag SRTLVTag_Instruction
 @return 蓝牙控制指令
 */
+ (SRBLEInstruction)bleCommandFromTag:(SRTLVTag_Instruction)tag;

@end
