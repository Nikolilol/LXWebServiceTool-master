//
//  LXWebServiceTool.h
//  LXWebServiceTool
//
//  Created by Niko on 16/4/13.
//  Copyright © 2016年 niko. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LXWebServiceTool;

@protocol LXWebServiceToolDelegate <NSObject>

@optional
/**
 *  代理方法，成功返回数据时调用
 *
 *  @param responseObj 返回的数据
 */
- (void)WebServiceToolFinsihedWithXmlPar:(id)responseObj;

/**
 *  代理方法，失败返回数据时调用
 *
 *  @param error 错误原因
 */
- (void)WebServiceToolFailedWithXmlPar:(id)error;
@end

@interface LXWebServiceTool : NSObject<NSXMLParserDelegate,  NSURLConnectionDelegate>
@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSMutableString *soapResults;
@property (strong, nonatomic) NSXMLParser *xmlParser;
@property (nonatomic) BOOL elementFound;
@property (strong, nonatomic) NSString *matchingElement;
@property (strong, nonatomic) NSURLConnection *conn;
@property (nonatomic, strong) id<LXWebServiceToolDelegate> delegate;

/**
 *  webservice网络请求
 *
 *  @param target 代理对象一般写self
 *  @param soapMethod webservice方法名
 *  @param matchinStr webservice匹配返回结果的关键字
 *  @param parArray   参数列表及参数的值, 顺序为所有的参数名+所有的参数值, 参数名顺序根据webservice上的顺序相同
 */
+ (void)requestWithTarget:(id)target SoapMethod:(NSString *)soapMethod parArray:(NSArray *)parArray webServiceUrl:(NSURL *)webServiceUrl;
@end
