//
//  LXWebServiceTool.m
//  LXWebServiceTool
//
//  Created by Niko on 16/4/13.
//  Copyright © 2016年 niko. All rights reserved.
//

#import "LXWebServiceTool.h"
#import "AFNetworking.h"
#import "XMLDictionary.h"
@implementation LXWebServiceTool
#pragma mark LXWebServiceTool 调用webService的工具
+ (void)requestWithNameSpace:(NSString *)nameSpace SoapMthod:(NSString *)soapMethod parArray:(NSArray *)parArray webServiceUrl:(NSURL *)webServiceUrl success:(successBlock)success errorBlock:(errorBlock)errorBlock
{
    NSString *matchingElement = [NSString stringWithFormat:@"%@Result", soapMethod];
    // 1. process para Array
    NSMutableString *soapBody = [[NSMutableString alloc] initWithString:@""];
    for (int i = 0; i < (parArray.count) / 2;i ++) {
        NSString *templeString = [NSString stringWithFormat:@"<%@>%@</%@>",[parArray objectAtIndex:i],[parArray objectAtIndex:(i + (parArray.count)/2)],[parArray objectAtIndex:i]];
        [soapBody appendFormat:templeString];
    }
    
    // 2. name space
    if (!nameSpace) {
        nameSpace = @"http://tempuri.org/";
    }
    
    // 3. process soapMsg
    NSString *soapMsg = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                         "<soap12:Envelope "
                         "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
                         "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
                         "xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
                         "<soap12:Body>"
                         "<%@ xmlns=\"%@\">"
                         "%@"
                         "</%@>"
                         "</soap12:Body>"
                         "</soap12:Envelope>", soapMethod, nameSpace, soapBody,soapMethod];
    NSLog(@"soapMsg = %@",soapMsg);
    // 4. process url
    NSURL *url = webServiceUrl;
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMsg length]];
    // 4.2. add request detail config
    [req addValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    // 4.3. add HTTP method name
    [req setHTTPMethod:@"POST"];
    // 5. add soapMsg to HTTP Body
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    // 6. creat a reqest
    // upon code is based on AFNetworking 2.x, which is Deprecated in AFNetworking3.0;
    // In AFNetworking 3.0 use URLSession to instead for mutableURLRequest should refer to Class AFHTTPSessionManager.
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (responseObject != nil) {
            NSDictionary *dict = [NSDictionary dictionaryWithXMLData:responseObject];
            NSLog(@"%@",dict);
            
            NSString *foo = [dict valueForKeyPath:[NSString stringWithFormat:@"soap:Body.%@.%@",[NSString stringWithFormat:@"%@Response", soapMethod], matchingElement]];
            if (success) {
                success(soapMethod, foo);
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (errorBlock) {
            errorBlock(soapMethod, error);
        }
    }];
    [operation start];
}
@end
