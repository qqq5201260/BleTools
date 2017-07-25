//
//  FZKEnum.h
//  Connector
//
//  Created by 宋搏 on 2017/5/2.
//  Copyright © 2017年 chinapke. All rights reserved.
//

#ifndef FZKEnum_h
#define FZKEnum_h



//汽车发送控制指令
static  NSString const *kCarControlNotification = @"kCarControlNotification";


//获取当前车辆设备id
#define kCurrentCarModleId [[NSUserDefaults standardUserDefaults] integerForKey:@"kSelectCarId"]

//保存当前车辆
#define kSaveCurrentCarModleId(id) [[NSUserDefaults standardUserDefaults] setObject:@(id) forKey:@"kSelectCarId"];\
                                   [[NSUserDefaults standardUserDefaults]synchronize];


typedef NS_ENUM(NSInteger, SRCarStateParseType){

    SRCarStateParseTypeHTTP, //http解析样式
    SRCarStateParseTypeTCP,  //TCP解析样式
    SRCarStateParseTypeBLE   //蓝牙解析样式
    
};

#pragma mark - SRHTTPResultCode

typedef NS_ENUM(NSInteger, SRHTTPResultCode){
    SRHTTP_NotConnected = -1005,
    SRHTTP_TimeOut = -1001,
    SRHTTP_NetUnreachable = -100,
    SRHTTP_Success = 0,
    SRHTTP_UserNameOrPasswordError = 5,
    
    //密码找回->手机验证
    SRHTTP_Vin_Not_Exist  = 6,    //通过手机号找回密码，需要输入Vin
    SRHTTP_Need_Vin = 7,//通过手机号找回密码，手机号码绑定了帐号，但是附加车架号号码查不到对应帐号的错误
    SRHTTP_Phone_Not_Exist = 8,//通过手机号码找回密码,手机号码没有绑定帐号的错误
};

#pragma mark - SRLoginStatus

typedef NS_ENUM(NSInteger, SRLoginStatus) {
    SRLoginStatus_NotLogin = 0,
    SRLoginStatus_DidLogin = 1,
    SRLoginStatus_Visitor = 2,
};

#pragma mark - SRTCPDirect

typedef NS_ENUM(NSUInteger, SRTCPDirect){
    TCPDirect_Request = 1,
    TCPDirect_Response,
    TCPDirect_OneWay,
    TCPDirect_OneWay_Ack,
    TCPDirect_Broadcast,
    TCPDirect_Broadcast_Ack
};

#pragma mark - SRTCPFuncID

typedef NS_ENUM(NSUInteger, SRTCPFuncID){
    TCPFuncID_Addressing = 1,
    TCPFuncID_Login,
    TCPFuncID_Logout,
    TCPFuncID_Query,
    TCPFuncID_Setting,
    TCPFuncID_Synchronous,
    TCPFuncID_Instruction,
    TCPFuncID_BleDebugging = 11,
};

#pragma mark - SRAbilityType

typedef NS_ENUM(NSUInteger, SRControlAbilityType) {
    SRControlAbilityType_Unsupport = 0,
    SRControlAbilityType_Support = 1,
    SRControlAbilityType_CanExtendable = 2
};

#pragma mark - SRTLVTag_Instruction

typedef NS_ENUM(NSUInteger, SRTLVTag_Instruction) {
    //控制
    TLVTag_Instruction_Lock        = 0x501, //1281 上锁
    TLVTag_Instruction_Unlock      = 0x503, //1283 解锁
    TLVTag_Instruction_EngineOn    = 0x505, //1285 引擎开
    TLVTag_Instruction_EngineOff   = 0x506, //1286 引擎关
    TLVTag_Instruction_OilOn       = 0x507, //1287 油路开
    TLVTag_Instruction_OilBreak    = 0x508, //1288 油路关
    TLVTag_Instruction_Call        = 0x50a, //1290 寻车
    
    TLVTag_Instruction_Silence     = 0x514, //1300 静音
    TLVTag_Instruction_WindowClose = 0x517, //1303 关窗
    TLVTag_Instruction_WindowOpen  = 0x518, //1304 开窗
    TLVTag_Instruction_SkyClose    = 0x519, //1305 关天窗
    TLVTag_Instruction_SkyOpen     = 0x51a, //1306 开天窗
    
    TLVTag_Instruction_GPSWeak     = 0x604, //1540 唤醒GPS
    
    TLVTag_Instruction_Defence     = 0x5005, //20485 设防
    TLVTag_Instruction_Undefence   = 0x5006, //20486 撤防
};

#pragma mark - SRTLVTag_Ability

typedef NS_ENUM(NSUInteger, SRTLVTag_Ability) {
    TLVTag_Ability_Lock         = 0x0501,     //关锁权限 1281
    TLVTag_Ability_Unlock       = 0x0502,     //开锁权限 1282
    TLVTag_Ability_EngineOn     = 0x0503,     //启动权限 1283
    TLVTag_Ability_EngineOff    = 0x0504,     //熄火权限 1284
    TLVTag_Ability_OilOn        = 0x0505,     //油路恢复权限 1285
    TLVTag_Ability_OilBreak     = 0x0506,     //油路关闭权限 1286
    TLVTag_Ability_Call         = 0x0507,     //寻车权限 1287
    TLVTag_Ability_Silence      = 0x0508,     //静音权限 1288
    TLVTag_Ability_WindowClose  = 0x0509,     //关窗权限 1289
    TLVTag_Ability_WindowOpen   = 0x050a,     //开窗权限 1290
    TLVTag_Ability_SkyClose     = 0x050b,     //关天窗权限 1291
    TLVTag_Ability_SkyOpen      = 0x050c,     //开天窗权限 1292
    
    TLVTag_Ability_Lock_SMS         = 0x0601,     //关锁权限 1537
    TLVTag_Ability_Unlock_SMS       = 0x0602,     //开锁权限 1538
    TLVTag_Ability_EngineOn_SMS     = 0x0603,     //启动权限 1539
    TLVTag_Ability_EngineOff_SMS    = 0x0604,     //熄火权限 1540
    TLVTag_Ability_OilOn_SMS        = 0x0605,     //油路恢复权限 1541
    TLVTag_Ability_OilBreak_SMS     = 0x0606,     //油路关闭权限 1542
    TLVTag_Ability_Call_SMS         = 0x0607,     //寻车权限 1543
};

#pragma mark - SRTLVTag_Synchronous

typedef NS_ENUM(NSUInteger, SRTLVTag_Synchronous) {
    
    //同步
    TLVTag_Synchronous_CUSTOMIZE   = 0X1010,   //设备状态  4112
    
    TLVTag_Synchronous_Online      = 0x3001,     //在线 12289
    
    TLVTag_Synchronous_GPS_Stars   = 0x3003,     //GPS星数 12291
    TLVTag_Synchronous_Engine      = 0x3004,     //引擎 12292
    
    TLVTag_Synchronous_Defence     = 0x3005,     //撤防布防 12293
    TLVTag_Synchronous_ACC         = 0x3006,     //ACC 12294
    TLVTag_Synchronous_DoorLock    = 0x3007,     //锁状态 12295
    TLVTag_Synchronous_Door        = 0x3008,     //门边状态 12296
    TLVTag_Synchronous_ElectricityStatus   = 0x3009, //电瓶状态 12297
    TLVTag_Synchronous_Electricity = 0x300A,      //电瓶电压 12298
    TLVTag_Synchronous_Mileage     = 0x300B,      //里程 12299
    TLVTag_Synchronous_OilStatus   = 0x300C,     //油量状态 12300
    TLVTag_Synchronous_CarRun      = 0X300D,     //行车 12301
    TLVTag_Synchronous_GPS_Time    = 0X300E,     //时间(utc) 12302
    TLVTag_Synchronous_GPS_Lat     = 0X300F,     //纬度 12303
    TLVTag_Synchronous_GPS_Lng     = 0X3010,     //经度 12304
    TLVTag_Synchronous_GPS_Speed   = 0X3011,     //速度 12305
    TLVTag_Synchronous_GPS_Direct  = 0X3012,     //方向 12306
    TLVTag_Synchronous_TemperatureStatus = 0X3013,//温度状态 12307
    TLVTag_Synchronous_Temperature = 0X3014,      //温度 12308
    TLVTag_Synchronous_GPS         = 0x3015,     //GPS状态 12309
    TLVTag_Synchronous_GPRS        = 0x3016,     //GPRS状态 12310
    //    TAG_DTCCode     = 0x3017,     //故障码 12311
    TLVTag_Synchronous_Oil         = 0x3018,        //剩余油量 12312
    TLVTag_Synchronous_GPS_WEAK    = 0x3020,     //GPS睡眠状态 12320
    
    TLVTag_Synchronous_OBD          = 0x301d,    //OBD状态  12317
    
    // // // // // // // // // // // // // // // // //
    //奥迪专用状态
    //门状态
    TLVTag_Synchronous_Door_LF     = 0X3036,   //左前门   12342
    TLVTag_Synchronous_Door_LB     = 0X3037,   //左后门   12343
    TLVTag_Synchronous_Door_RF     = 0X3038,   //右前门   12344
    TLVTag_Synchronous_Door_RB     = 0X3039,   //右后门   12345
    TLVTag_Synchronous_Door_Trunck = 0X303A,   //后备箱   12346
    //窗状态
    TLVTag_Synchronous_Window_LF   = 0X303B,   //左前窗   12347
    TLVTag_Synchronous_Window_LB   = 0X303C,   //左后窗   12348
    TLVTag_Synchronous_Window_RF   = 0X303D,   //右前窗   12349
    TLVTag_Synchronous_Window_RB   = 0X303E,   //右后窗   12350
    TLVTag_Synchronous_Window_Sky  = 0X303F,   //天窗    12351
    
    TLVTag_Synchronous_Light_Big  = 0X3040,   //大灯    12352
    TLVTag_Synchronous_Light_Little    = 0X3041,//小灯   12353
    
    TLVTag_Synchronous_LeftOil_Litter  = 0X3042,   //剩余油量（L）12354
    // // // // // // // // // // // // // // // // //
    
    TLVTag_Synchronous_Alarm       = 0X4006,     //告警消息 16390
    
    TLVTag_Synchronous_Bluetooth       = 0X4302,     //蓝牙信息 17154
};

#pragma mark - SRTLVTag_Event

typedef NS_ENUM(NSUInteger, SRTLVTag_Event) {
    //事件
    TLVTag_Event_Engine    = 0X400D,    //引擎启动事件 16397
    
    TLVTag_Event_Message   = 0X4300,    //推送消息 17152
    
    TLVTag_Event_UserNamePasswordChange = 0x7000,  //用户名密码改变 28672
    TLVTag_Event_BindStatusChange       = 0x7001,  //绑定状态改变 28673
    TLVTag_Event_TripHidden             = 0x7002,  //轨迹隐藏开启 28674
    TLVTag_Event_TripUnhidden           = 0x7003,  //轨迹隐藏解除 28675
    //    Event_CarBasicInfoUpdate     = 0x7004,  //车辆基本信息改变 28676
    TLVTag_Event_TerminalPasswordChange = 0x7008,    //设备密码变更 28680
    TLVTag_Event_ObdChange              = 0x700a,     //OBD开关变更 28682
};

#pragma mark - SRTLVTag_Debugging

typedef NS_ENUM(NSUInteger, SRTLVTag_Debugging) {
    
    SRTLVTag_Debugging_BleStatus        = 0X7012,   //蓝牙状态 16397
    SRTLVTag_Debugging_ServerToTerminal = 0x7013,   //调试指令下发
    SRTLVTag_Debugging_TerminalToServer = 0x7014,   //调试指令回显
    
};

#pragma mark - SRSexType

typedef NS_ENUM(NSInteger, SRSexType){
    SRSex_Male = 1,
    SRSex_Female = 2
};

#pragma mark - SRCustomerType

typedef NS_ENUM(NSUInteger, SRCustomerType) {
    SRCustomer_Normal = 0,
    SRCustomer_Visitor = 2
};

#pragma mark - SRBindingStatus

typedef NS_ENUM(NSInteger, SRBindingStatus) {
    SRBindingStatus_Unbind = 0,  //未绑定
    SRBindingStatus_Bind_Self = 1, //绑定，当前用户是绑定用户
    SRBindingStatus_Bind_Others = 2,   //绑定，当前用户不是绑定用户
    SRBindingStatus_Reserved
};

#pragma mark - SRTripHiddenStatus

typedef NS_ENUM(NSInteger, SRTripHiddenStatus) {
    SRTrip_Unhidden = 0,  //不隐藏
    SRTrip_Hidden_Self = 1, //本机隐藏
    SRTrip_Hidden_Others = 2,   //其他手机隐藏
    SRTrip_Hidden_Reserved
};

#pragma mark - SRPermissionType

typedef NS_ENUM(NSInteger, SRPermissionType) {
    SRPermissionType_Unknown = -1,
    SRPermissionType_NamePassword = 0,
    SRPermissionType_Phone = 1,
};

#pragma mark - SROrderStartType

typedef NS_ENUM(NSUInteger, SROrderStartType) {
    SROrderStartType_Customer = 0,
    SROrderStartType_GoOffice,
    SROrderStartType_GoHome
};

#pragma mark - SRControlType

typedef NS_ENUM(NSUInteger, SRControlType){
    SRControlType_Unsupport = 0,
    SRControlType_TCP_HTTP,
    SRControlType_SMS,
    SRControlType_BT,
};

#pragma mark - SRIMDirection

typedef NS_ENUM(NSInteger, SRIMDirection) {
    SRIMDirection_New = 0,
    SRIMDirection_Old = 1,
};

#pragma mark - SRIMType

typedef NS_ENUM(NSInteger, SRIMType) {
    SRIMType_Customer = 0,
    SRIMType_SiRui = 1,
};

//#pragma mark - SRMessageType
//
//typedef NS_ENUM(NSInteger, SRMessageType) {
//    SRMsgType_Alarm = 1,
//    SRMsgType_Alart,
//    SRMsgType_EngineOn,
//    SRMsgType_Trouble,
//    SRMsgType_Overspeed,
//    SRMsgType_LowElectric,
//    SRMsgType_Outage,
//    SRMsgType_Maintain,
//    SRMsgType_AnnualExamination,
//    SRMsgType_Insurance,
//    SRMsgType_MarketingActivity,
//    SRMsgType_MyMessage,
//    SRMsgType_Crash,
//
//    SRMsgType_Reserved,
//};

#pragma mark - AuthenticationStatus

typedef NS_ENUM(NSInteger, AuthenticationStatus) {
    AuthenticationStatus_WaitForUpload = 0,
    AuthenticationStatus_InReview,
    AuthenticationStatus_Approved,
    AuthenticationStatus_Rejected,
    
    AuthenticationStatus_Unknown,
};

#pragma mark - SRMessageType

typedef NS_ENUM(NSInteger, SRMessageType) {
    SRMessageType_Alert = 1,
    SRMessageType_Remind = 2,
    SRMessageType_Function = 3,
    SRMessageType_IM = 4,
    SRMessageType_Control = 6,
    
    SRMessageType_Unknown = 0,
};

#pragma mark - SRMessageSubType

typedef NS_ENUM(NSInteger, SRMessageSubType) {
    //SRMessageSubType_Alert_Alert = 1,
    //    SRMessageSubType_Alert_CarTrouble = 4,
    //    SRMessageSubType_Alert_OverSpeed = 5,
    //    SRMessageSubType_Alert_LowElectric = 6,
    //    SRMessageSubType_Alert_PowerOff = 7,
    //    SRMessageSubType_Alert_CarCrash = 13,
    //    SRMessageSubType_Alert_TerminalToken = 14,
    //    SRMessageSubType_Alert_DoorWindowNotClose = 15,
    //    SRMessageSubType_Alert_BigLightNotClose = 16,
    //
    //    SRMessageSubType_Remind_EngineOn = 3,
    //    SRMessageSubType_Remind_ServiceExpire = 17,
    //    SRMessageSubType_Remind_PasswordChange = 18,
    //    SRMessageSubType_Remind_OrderStart = 20,
    //    SRMessageSubType_Remind_CustomerDelete = 22,
    //    SRMessageSubType_Remind_MaintainSuccess = 23,
    //    SRMessageSubType_Remind_MaintainRemind = 24,//预约保养到期提醒
    //
    //    SRMessageSubType_Function_OrderStartRecommend = 19,
    //
    //    SRMessageSubType_Unknown = 0,
    
    
    
    //二级分类
    SRMessageSubType_Alert_Alert  = 1,  //告警
    SRMessageSubType_Call_Police  = 2,//       报警
    SRMessageSubType_Remind_EngineOn  = 3,//  点火启动
    SRMessageSubType_Alert_CarTrouble  = 4,// 车辆故障
    SRMessageSubType_Alert_OverSpeed  = 5,// 车辆超速
    SRMessageSubType_Alert_LowElectric  = 6,// 低电压
    SRMessageSubType_Alert_PowerOff  = 7,// 断电
    //    public static final int  = 8,////保养
    //    public static final int  = 9,// 年审到期
    //    public static final int  = 10,// 保险到期
    //    public static final int  = 11,// 市场活动
    //    public static final int  = 12,// 个人消息
    SRMessageSubType_Alert_CarCrash  = 13,// 碰撞告警
    
    SRMessageSubType_Alert_TerminalToken  = 14,// 设备被拆
    SRMessageSubType_Alert_DoorWindowNotClose  = 15,//  未关门窗
    SRMessageSubType_Alert_BigLightNotClose  = 16,// 大灯未关
    SRMessageSubType_Remind_ServiceExpire  = 17,// 服务费到期
    
    SRMessageSubType_Remind_PasswordChange  = 18,//  修改密码
    SRMessageSubType_Function_OrderStartRecommend  = 19,//  预约启动推荐
    SRMessageSubType_Remind_OrderStart  = 20,// 预约启动
    //    public static final int  = 21,// IM
    SRMessageSubType_Remind_CustomerDelete  = 22,// 客户被删除
    
    SRMessageSubType_Remind_MaintainSuccess  = 23,//  保养预约
    SRMessageSubType_Remind_MaintainRemind  = 24,//  保养预约时间到点提醒
    
    SRMessageSubType_Intrusion_Alarm  = 25,//  入侵告警
    
    SRMessageSubType_Control_Start  = 26,//  启动
    SRMessageSubType_Control_Flameout  = 27,//  熄火
    SRMessageSubType_Control_Lock  = 28,//  上锁
    SRMessageSubType_Control_Unlock = 29,//     解锁
    SRMessageSubType_Control_Find  = 30,//  寻车
    
    SRMessageSubType_Enclosure  = 31,//  围栏
    
    SRMessageSubType_Unknown = 0,
};

#pragma mark - SRMaintainGeneralType

typedef NS_ENUM(NSInteger, SRMaintainGeneralType) {
    SRMaintainGeneralType_Reserved = 0,
    SRMaintainGeneralType_Big,
    SRMaintainGeneralType_Little
};

#pragma mark - SRMaintainSpecialType

typedef NS_ENUM(NSInteger, SRMaintainSpecialType) {
    SRMaintainSpecialType_Tire = 0,
    SRMaintainSpecialType_Brake,
    SRMaintainSpecialType_Battery,
    SRMaintainSpecialType_Wiper
};

#pragma mark - SRMaintainStatus

typedef NS_ENUM(NSInteger, SRMaintainStatus) {
    SRMaintainStatus_None = 0, //没有记录
    SRMaintainStatus_Pending   //待处理
};

#pragma mark - SRSystemType

typedef NS_ENUM(NSInteger, SRSystemType) {
    SRSystemType_Engine_Transmission = 0, //引擎及变速箱系统
    SRSystemType_Chassis ,//底盘控制系统
    SRSystemType_Bodywork ,//车身控制系统
    SRSystemType_Network//网络连接系统
};
#endif /* FZKEnum_h */
