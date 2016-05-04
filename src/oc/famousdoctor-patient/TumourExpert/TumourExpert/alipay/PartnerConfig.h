//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088111855435263"
//收款支付宝账号
#define SellerID  @"18092701696@163.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"oagsy6j2z62xltp49oaa640xow2wfslt"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMribHzyJAfwvRqSQr7+USL5IqDib2SAUGckHWZaz8BFoo9qIpUpNcBtOglqyj8K1gPDPwBtZTxxYto1PBKGAEIBG6V5v+ieaEaYWHuiEdGBlsoXOD1v3noIpczxDJFhaLgIHdCveaoHlLnwZJmNSUS+lNu7PaDMHYm3GWgR4lcLAgMBAAECgYBdRJn7FpXZ0KIehP6KLv+9xCpXK8FpwlM0FzYsx7KaAWkp5PDhAYDkZVI44g73zFN2h1t/JstTbgyzo6VqHpAe9gtesQHsorRFmPP1HIW0tkBfPtHqaKMw0SNrFMzRHCj4sh9cieruRjvpp8SPfMk4TzREu+g4gmhCa1gfVC6FAQJBAO2LwRy80c/42+w959BxQJE6uPsz8oDhFJqfeR66/vzfrc4OZVXmvxj+JMGwnrohEQ0xc5U65LKnqUsIBThhiaMCQQDapVUZcCTFLsSyaZUsn71uEr3G5nDGXDYUzarDBlbnpQFLqmrc+iwt/eh9kjOkUKw2PmTiVPLvLCYisxRvnSN5AkB4Xp3vavrCcO84CbKC3DCEpwX/PLaAeg2PwImGeeklyE5xILhWzAM/reCASXhVBtZ2If3Yu6wRn4XYoGrMxBgTAkEAvp8gJ1JnLGZO5ME6ZjJKY9oBDJTBw56HI/H/K5KuV7y6+W31RvzxYZOZi0jYrywKSCxzpgOr3StfgCci7QBR+QJACQAD6Gk8FWOJTpDsYP4O8cDoR47j5Q3YpflSnAUkPmy/Hzgzq2Bx9HQorZ2FayYyl5xlI6IjXfpFBTqo0/AS1g=="


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#endif
