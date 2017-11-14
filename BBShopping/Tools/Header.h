//
//  Header.h
//  BBShopping
//
//  Created by mibo02 on 17/1/16.
//  Copyright © 2017年 mibo02. All rights reserved.
//

#ifndef Header_h
#define Header_h

/** 监控网络状态 */
#define kNetworkState  @"kNetworkState"

//self
#define WS(weakSelf) __weak  __typeof(&*self)weakSelf = self;
/**随机颜色*/
#define RandomColor [UIColor colorWithRed:arc4random() % 256 / 255.0 green:arc4random() % 256 / 255.0 blue:arc4random() % 256 / 255.0 alpha:1.0]
//黄色
#define SystemOriginColor [UIColor colorWithRed:249/255.0 green:205/255.0 blue:2/255.0 alpha:1.0f]

#define TabBarHeight 49

///正常字体
#define H30 [UIFont systemFontOfSize:30]
#define H29 [UIFont systemFontOfSize:29]
#define H28 [UIFont systemFontOfSize:28]
#define H27 [UIFont systemFontOfSize:27]
#define H26 [UIFont systemFontOfSize:26]
#define H25 [UIFont systemFontOfSize:25]
#define H24 [UIFont systemFontOfSize:24]
#define H23 [UIFont systemFontOfSize:23]
#define H22 [UIFont systemFontOfSize:22]
#define H20 [UIFont systemFontOfSize:20]
#define H19 [UIFont systemFontOfSize:19]
#define H18 [UIFont systemFontOfSize:18]
#define H17 [UIFont systemFontOfSize:17]
#define H16 [UIFont systemFontOfSize:16]
#define H15 [UIFont systemFontOfSize:15]
#define H14 [UIFont systemFontOfSize:14]
#define H13 [UIFont systemFontOfSize:13]
#define H12 [UIFont systemFontOfSize:12]
#define H11 [UIFont systemFontOfSize:11]
#define H10 [UIFont systemFontOfSize:10]
#define H8 [UIFont systemFontOfSize:8]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define XFHeadViewH 220

#define XFHeadViewMinH 64

#define XFTabBarH 44
//尺寸
#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
// 根据屏幕分辨率判断设备，是则返回YES，不是返回NO
#define isiPhone5or5sor5c ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isiPhone6or6s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define isiPhone6plusor6splus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
//测试环境http://120.76.208.111:9909/wbappapi/
//正式环境https://hwi.wb1688.com/
#define allURL @"http://120.76.208.111:9909/wbappapi/"
//支付宝
#define zhifubaonewURl  [NSString stringWithFormat:@"%@aliPay/notify",allURL]
//获取数量
#define countsURL [NSString stringWithFormat:@"%@order/counts",allURL]
//评价
#define commentURL  [NSString stringWithFormat:@"%@user/comment",allURL]
//版本设置
#define  getAppVersionURL  [NSString stringWithFormat:@"%@common/getAppVersion",allURL]
#define safeSetURL [NSString stringWithFormat:@"%@user/safeSet",allURL]

//验证原手机号码
#define reBindMobileURL  [NSString stringWithFormat:@"%@user/reBindMobile",allURL]

//短信验证码登陆
#define smsLoginURL  [NSString stringWithFormat:@"%@user/smslogin",allURL]
//我的拼团
#define myGrouponListURl [NSString stringWithFormat:@"%@groupon/myGrouponList",allURL]
//我的拼团详情
#define grouponDetailURL [NSString stringWithFormat:@"%@activity/group/groupon/",allURL]
//我的拼团查看物流
//#define getLogisticsURL  [NSString stringWithFormat:@"%@order/getLogistics",allURL]
//我的圈子提取现金
#define order_cashURL  [NSString stringWithFormat:@"%@fund/order_cash",allURL]
//提现
#define doCashURL  [NSString stringWithFormat:@"%@fund/doCash",allURL]
//我的圈子--资金管理--已提现金额（提现明细）
#define cash_detailURL [NSString stringWithFormat:@"%@fund/cash_detail",allURL]
//我的圈子--资金管理--合伙人收入明细
#define partner_detailURL  [NSString stringWithFormat:@"%@fund/partner_detail",allURL]
//我的圈子--资金管理--累计佣金主页--佣金明细
#define commission_detailURL [NSString stringWithFormat:@"%@fund/commission_detail",allURL]
//我的圈子--资金管理--累计佣金主页
#define detail_allURL  [NSString stringWithFormat:@"%@fund/detail_all",allURL]
//我的圈子--资金管理--主页
#define myFundsURL [NSString stringWithFormat:@"%@fund/myFunds",allURL]
//我的圈子--预收入
#define circlebudgetURL  [NSString stringWithFormat:@"%@circle/budget",allURL]
//我的圈子--分销订单
#define orderListURl  [NSString stringWithFormat:@"%@order/orderList",allURL]
//我的圈子--师徒
#define disciplesAndFollowersURL  [NSString stringWithFormat:@"%@circle/disciplesAndFollowers",allURL]

//绑定新手机号码
#define bindMobileURL  [NSString stringWithFormat:@"%@user/bindMobile",allURL]
//找回密码前验证
#define findPassURL  [NSString stringWithFormat:@"%@user/verifyFindPass",allURL]
//重设密码
#define newfindPassURL  [NSString stringWithFormat:@"%@user/findPass",allURL]
//订单列表
#define orderListURL  [NSString stringWithFormat:@"%@order/orderList",allURL]
//物流信息跟踪
#define getLogisticsURL  [NSString stringWithFormat:@"%@order/getLogistics",allURL]
//设置订单状态
#define setOrderInfoOrderStatusURl  [NSString stringWithFormat:@"%@order/setOrderInfoOrderStatus",allURL]

//订单详情
#define findFrontOrderInfoURL  [NSString stringWithFormat:@"%@order/findFrontOrderInfo",allURL]
//微信授权登陆判断是否是第一次登陆
#define isFirstLoginURL  [NSString stringWithFormat:@"%@user/isFirstLogin",allURL]
//微信首次登陆授权登陆
#define webChatLoginFirstURL  [NSString stringWithFormat:@"%@user/webChatLoginFirst",allURL]
//微信非首次登陆
#define webChatLogin  [NSString stringWithFormat:@"%@user/webChatLogin",allURL]
//首页
#define HomeURL [NSString stringWithFormat:@"%@index",allURL]
//首页点击更多接口
#define HomeMoreURL  [NSString stringWithFormat:@"%@goods/storeyMoreGoods",allURL]

//新品上市
#define NewShopURL  [NSString stringWithFormat:@"%@collection/",allURL]
//精选好货
#define ChosenShopURL [NSString stringWithFormat:@"%@selection/",allURL]
//搜索接口
#define SearchURL  [NSString stringWithFormat:@"%@goods/search",allURL]
//搜索自动填充接口
#define SearchZDURL  [NSString stringWithFormat:@"%@goods/getSearchInfo",allURL]
//清除历史记录接口
#define ClearHistoryURL  [NSString stringWithFormat:@"%@goods/clearUserSearch",allURL]

//详情接口
#define DetailURL  [NSString stringWithFormat:@"%@goods/detail",allURL]
//根据sku的值查询sku商品对象
#define SkudetailURL [NSString stringWithFormat:@"%@goods/getSkuGoodsBySkuValue",allURL]

//秒杀接口
#define seckillURL  [NSString stringWithFormat:@"%@activity/seckill",allURL]
//秒杀详情
#define seckilDetaukURL  [NSString stringWithFormat:@"%@activity/seckill/detail",allURL]
//秒杀详情选择规格
#define seckilgetSkuInfoURL  [NSString stringWithFormat:@"%@activity/seckill/getSkuInfo",allURL]
//加入购物车前获取当前商品缺省信息(用于首页等)
#define cartGoodsDetailURL  [NSString stringWithFormat:@"%@cart/cartGoodsDetail",allURL]
//删除购物车中指定商品
#define DelegatecartShop  [NSString stringWithFormat:@"%@cart/deleteCartGoods",allURL]
//获取用户购物车
#define getShoppingCartUrl  [NSString stringWithFormat:@"%@cart/getShoppingCart",allURL]
//购物车商品减一
#define minusCartGoodsURL  [NSString stringWithFormat:@"%@cart/minusCartGoods",allURL]
//购物车商品加一
#define increaseCartGoodsURL  [NSString stringWithFormat:@"%@cart/increaseCartGoods",allURL]
//加入购物车
#define addGoodsToCartURL  [NSString stringWithFormat:@"%@cart/addGoodsToCart",allURL]
//分类主界面
#define SortURL  [NSString stringWithFormat:@"%@goods/sort",allURL]
//分类详情界面
#define SortDetailURl  [NSString stringWithFormat:@"%@goods/sortGoodsList",allURL]
//团购主界面
#define groupRL [NSString stringWithFormat:@"%@activity/group",allURL]
//参团详情界面
#define groupDetaiAddlURL  [NSString stringWithFormat:@"%@activity/group/groupon/",allURL]
//团购详情
#define groupDetailURL  [NSString stringWithFormat:@"%@activity/group/detail/",allURL]
//参团选择规格
#define clickGroupURL  [NSString stringWithFormat:@"%@activity/group/getSkuInfo",allURL]
//发送短信
#define sendMessage  [NSString stringWithFormat:@"%@sms/sendSms",allURL]
//注册
#define RegistURL  [NSString stringWithFormat:@"%@user/register",allURL]
//登录
#define LoginURL  [NSString stringWithFormat:@"%@user/login",allURL]
//注销
#define logoutURL  [NSString stringWithFormat:@"%@user/logout",allURL]
//获取用户信息
#define GetInfoMationURL  [NSString stringWithFormat:@"%@user/getUserInfo",allURL]

//添加礼品卡
#define AddPresentURL  [NSString stringWithFormat:@"%@giftcard/addGiftCard",allURL]
//获取礼品卡信息
#define GetPresentInfomationURL  [NSString stringWithFormat:@"%@giftcard/getGiftCard",allURL]
//获取礼品卡列表
#define GetGiftCardListURL  [NSString stringWithFormat:@"%@giftcard/getGiftCardList",allURL]
//删除地址
#define deleteAddressURL  [NSString stringWithFormat:@"%@address/deleteAddress",allURL]
//设置默认地址
#define setDefaultAddressURL [NSString stringWithFormat:@"%@address/setDefaultAddress",allURL]
//编辑地址
#define editAddressURL [NSString stringWithFormat:@"%@address/editAddress",allURL]
//获取地址信息
#define getAddressURL  [NSString stringWithFormat:@"%@address/getAddress",allURL]
//新增地址
#define addAddressURL [NSString stringWithFormat:@"%@address/addAddress",allURL]
//获取省市区
#define getLocationURL  [NSString stringWithFormat:@"%@address/getLocation",allURL]
//获取地址列表
#define getAddressListURL  [NSString stringWithFormat:@"%@address/getAddressList",allURL]

//结算
#define buynowURL  [NSString stringWithFormat:@"%@order/buynow",allURL]
//支付宝接口
//请求数据签名
#define signaturesURL [NSString stringWithFormat:@"%@aliPay/signatures",allURL]
//提交售后申请
#define customerapplyAddURL  [NSString stringWithFormat:@"%@customerapply/add",allURL]
//进入售后申请
#define customerapplyIdexURL  [NSString stringWithFormat:@"%@customerapply/index",allURL]
//订单评价
#define saveRateURL  [NSString stringWithFormat:@"%@order/saveRate",allURL]
//礼品卡确认支付
#define giftCardPayURL  [NSString stringWithFormat:@"%@pay/giftCardPay",allURL]
//微信支付回调接口
#define wxpaynotifyURL  [NSString stringWithFormat:@"%@wxpay/notify",allURL]
//微信支付统一下单接口
#define wxpaywxprepayURL  [NSString stringWithFormat:@"%@wxpay/wxprepay",allURL]

//参团己满，去支付成为新团长吧
#define confirmGrouponPayURL  [NSString stringWithFormat:@"%@pay/confirmGrouponPay",allURL]
//前往确认支付页面
#define payindexURL  [NSString stringWithFormat:@"%@pay/index",allURL]

//修改个人信息
#define updateUserInfoURL [NSString stringWithFormat:@"%@user/updateUserInfo",allURL]
//上传图片
#define commonuploadImgURL  [NSString stringWithFormat:@"%@common/uploadImg",allURL]
//创建订单
#define createorderURl   [NSString stringWithFormat:@"%@order/createOrder",allURL]
//获取通知消息列表
#define getMsgListURL  [NSString stringWithFormat:@"%@msg/getMsgList",allURL]
#endif /* Header_h */


