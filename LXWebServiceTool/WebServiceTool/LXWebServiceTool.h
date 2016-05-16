//
//  LXWebServiceTool.h
//  LXWebServiceTool
//
//  Created by Niko on 16/4/13.
//  Copyright © 2016年 niko. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^successBlock)(NSString *methodName, id responseObject);
typedef void (^errorBlock)(NSString *methodName, NSError *error);

@interface LXWebServiceTool : NSObject
@property (strong, nonatomic) NSURLConnection *conn;

/**
 *  request to webService
 *
 *  @param nameSpace the name space of your WebService
 *  @param soapMethod webservice method name
 *  @param parArray webservice need paramil
 *  @param webServiceUrl   the url of webservice
 */
+ (void)requestWithNameSpace:(NSString *)nameSpace SoapMthod:(NSString *)soapMethod parArray:(NSArray *)parArray webServiceUrl:(NSURL *)webServiceUrl success:(successBlock)success errorBlock:(errorBlock)errorBlock;
@end
