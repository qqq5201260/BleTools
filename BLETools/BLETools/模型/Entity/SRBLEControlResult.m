//
//  SRBLEControlResult.m
//  Mizward
//
//  Created by zhangjunbo on 15/9/10.
//  Copyright (c) 2015年 Mizward. All rights reserved.
//

#import "SRBLEControlResult.h"

@implementation SRBLEControlResult

- (instancetype)initWithParameters:(NSArray *)parameters
{
    if (self = [super init]) {
        _instruction = (parameters&&parameters.count>0)?strtoul(((NSString *)parameters.firstObject).UTF8String, 0, 16):SRBLEInstruction_NULL;
        _resultCode = (parameters&&parameters.count>1)?strtoul(((NSString *)parameters.lastObject).UTF8String, 0, 16):SRBLEControlResultCode_NULL;
    }
    
    return self;
}

- (BOOL)isSuccess
{
    return self.resultCode == SRBLEControlResultCode_OK
            ||self.resultCode == SRBLEControlResultCode_EXE;
}

- (NSString *)resultString
{
    NSDictionary *dic = @{@(SRBLEControlResultCode_NULL)                    :   @"无效",
                          @(SRBLEControlResultCode_OK)                      :   @"成功",
                          @(SRBLEControlResultCode_EXE)                     :   @"正在执行",
                          @(SRBLEControlResultCode_Fail)                    :   @"失败（通用）",
                          @(SRBLEControlResultCode_Fail_CANCEL)             :   @"失败（取消）",
                          @(SRBLEControlResultCode_Fail_DELAY)              :   @"失败（延时执行）",
                          @(SRBLEControlResultCode_Fail_UNSUPPORT)          :   @"失败（设备不支持）",
                          @(SRBLEControlResultCode_Fail_TIMOUT)             :   @"失败（有效期超时）",
                          @(SRBLEControlResultCode_Fail_CONFIG)             :   @"失败（配置不支持）",
                          @(SRBLEControlResultCode_Fail_PARAM)              :   @"失败（参数非法）",
                          @(SRBLEControlResultCode_Fail_BUSY)               :   @"失败（系统繁忙）",
                          @(SRBLEControlResultCode_Fail_STATE)              :   @"失败（状态不支持）",
                          @(SRBLEControlResultCode_Fail_DUPCMD)             :   @"失败（指令正在执行时再次接收相同指令）",
                          @(SRBLEControlResultCode_Fail_DUPSTATE)           :   @"失败（状态已更新）",
                          @(SRBLEControlResultCode_Fail_START_ON)           :   @"失败（启动检测到状态ON）",
                          @(SRBLEControlResultCode_Fail_START_OPEN)         :   @"失败（启动检测到门开）",
                          @(SRBLEControlResultCode_Fail_START_WIN)          :   @"失败（启动检测到升窗）",
                          @(SRBLEControlResultCode_Fail_START_WASH)         :   @"失败（启动检测到洗车模式）",
                          @(SRBLEControlResultCode_Fail_STOP_ON)            :   @"失败（熄火检测到档位ON）",
                          @(SRBLEControlResultCode_Fail_STOP_DRIVE)         :   @"失败（熄火检测到行驶）",
                          @(SRBLEControlResultCode_Fail_PANIC_ON)           :   @"失败（寻车检测到状态ON）",
                          @(SRBLEControlResultCode_Fail_LOCK_OPEN)          :   @"失败（关锁检测到门开）",
                          @(SRBLEControlResultCode_Fail_START_UNLK)         :   @"失败（PPKE解锁禁止遥控启动）",
                          @(SRBLEControlResultCode_Fail_STOP_GERA)          :   @"失败（熄火检测到档位非P档）",
                          @(SRBLEControlResultCode_Fail_STOP_MANUAL)        :   @"失败（熄火检测到手动启动）",
                          @(SRBLEControlResultCode_Fail_BTK_ID)             :   @"失败（钥匙错误）",
                          @(SRBLEControlResultCode_Fail_BTK_SEQ)            :   @"失败（滚动码错误）",
                          @(SRBLEControlResultCode_Fail_Vehicle_Unkown)     :   @"失败（车型拨码错误）",
                          @(SRBLEControlResultCode_Fail_App_Unsupport)      :   @"失败（业务不支持）",
                          @(SRBLEControlResultCode_Fail_STOP_LF_CLOSE)      :   @"失败（熄火时必须打开主门）",
                          
                          @(SRBLEControlResultCode_Fail_BTK_AUTH)           :   @"失败（蓝牙签权错误）",
                          @(SRBLEControlResultCode_Fail_PKE_OFF)            :   @"失败（在off状态下遥控启动)",
                          @(SRBLEControlResultCode_Fail_OTA_PAUSE)          :   @"失败（升级暂停）",
                          @(SRBLEControlResultCode_Fail_CRC_ERROR)          :   @"失败（CRC错误）",
                          @(SRBLEControlResultCode_Fail_FLASH_WRITE_ERR)    :   @"失败（写FLASH失败）",
                          @(SRBLEControlResultCode_Fail_RESET_1)            :   @"失败（升级期间重启）",
                          @(SRBLEControlResultCode_Fail_RESTIMEOUT)         :   @"失败（接收超时达到最大次数）",
                          @(SRBLEControlResultCode_Fail_CRC_ERROR_FRAG)     :   @"失败（B808返回的片校验与B806返回的片校验不一致）",
                          @(SRBLEControlResultCode_Fail_CRC_DATA)           :   @"失败（上传将要写入的FLASH 的片校验）",
                          @(SRBLEControlResultCode_Fail_RX_CRC)             :   @"失败（接收数据CRC错误）",
                          @(SRBLEControlResultCode_Fail_SET)                :   @"失败（参数设置1）",
                          @(SRBLEControlResultCode_Fail_RESET_2)            :   @"失败（参数清零）",
                          @(SRBLEControlResultCode_Fail_UPDATE_ERR_ON)      :   @"失败（在ON档在线升级）",
                          @(SRBLEControlResultCode_Fail_BKOPEN_ON)          :   @"失败（ON无法开启后备箱）",
                          @(SRBLEControlResultCode_Fail_KEYFIND_OK)         :   @"失败（找到遥控器）",
                          @(SRBLEControlResultCode_Fail_KEYFIND_FAIL)       :   @"失败（未找到遥控器）",
                          @(SRBLEControlResultCode_Fail_BLOCK_ERASE_FINISHED)     :   @"失败（块擦除完成）"
                          };
    
    return dic[@(self.resultCode)]?dic[@(self.resultCode)]:[NSString stringWithFormat:@"失败(%zd)", self.resultCode];
}

@end
