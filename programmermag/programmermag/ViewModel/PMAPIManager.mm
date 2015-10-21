//
//  PMAPIManager.m
//  programmermag
//
//  Created by 张如泉 on 15/10/20.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import "PMAPIManager.h"
#import "tinyxml2.h"
#import "PMIssueModel.h"
@implementation PMAPIManager

+ (instancetype)sharedManager
{
    static PMAPIManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        instance.responseSerializer = [AFHTTPResponseSerializer serializer];
     
        
    });
    return instance;
}

-(instancetype)init{
    
    self=[super init];
    
    if(self){

    }
    
    return  self;
}
- (RACSignal *)fetchDataWithURLString:(NSString *)urlString params:(NSDictionary *)parameters headers:(NSDictionary*)headers returnType:(PMAPIReturnType)type httpMethod:(NSString *)method{
    

    BOOL errorReturnCache = [parameters objectForKey:@"errorReturnCache"]?[[parameters objectForKey:@"errorReturnCache"] boolValue] :NO;
    
    NSString * savePath = [kDocuments stringByAppendingPathComponent:[urlString componentsSeparatedByString:@"/"].lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:savePath])
    {
        errorReturnCache = NO;
    }
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method
                                                                   URLString:urlString
                                                                  parameters:parameters error:nil];
    if(type == PMAPIManagerReturnTypeData)
        request.timeoutInterval = 120;
    if(headers)
    {
        for (NSString * key in headers) {
            [request setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/xml", @"text/xml",@"application/json",@"application/vnd.apple.mpegurl",@"application/octet-stream",@"text/vnd.trolltech.linguist",nil];
        AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (type == PMAPIManagerReturnTypePlain||type == PMAPIManagerReturnTypeM3u8||type == PMAPIManagerReturnTypeXML) {
                [subscriber sendNext:operation.responseString];
                [subscriber sendCompleted];
            }
            else if (type == PMAPIManagerReturnTypeData) {
                [subscriber sendNext:operation.responseData];
                [subscriber sendCompleted];
            }
            else
            {
                NSString *html = operation.responseString;
                NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
                id dict= nil;//[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                
                if (data) {
                    if ([data length] > 0) {
                        dict = [NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                    } else if(!errorReturnCache){
                        [subscriber sendError:[NSError errorWithDomain:@"MyDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"服务器发生未知错误"}]];
                    }
                    else
                    {
                        [subscriber sendNext:[[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:savePath]] objectForKey:@"data"]];
                        [subscriber sendCompleted];
                        
                    }
                }
                if([dict isKindOfClass:[NSDictionary class]])
                {
                    if(!dict[@"code"])
                    {
                        if(!errorReturnCache){
                            [subscriber sendError:[NSError errorWithDomain:@"MyDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"服务器发生未知错误"}]];
                        }
                        else
                        {
                            [subscriber sendNext:[[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:savePath]] objectForKey:@"data"]];
                            [subscriber sendCompleted];
                            
                        }
                        
                    }
                    else if([dict[@"code"] integerValue] == 4000)
                    {
                        if(!dict[@"message"])
                        {
                            if(!errorReturnCache){
                                [subscriber sendError:[NSError errorWithDomain:@"MyDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"服务器发生未知错误"}]];
                            }
                            else
                            {
                                [subscriber sendNext:[[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:savePath]] objectForKey:@"data"]];
                                [subscriber sendCompleted];
                                
                            }
                            
                        }
                        else
                            [subscriber sendError:[NSError errorWithDomain:@"MyDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:dict[@"message"]}]];
                    }
                    else
                    {
                        if(!dict[@"data"])
                        {
                            if(!errorReturnCache){
                                [subscriber sendError:[NSError errorWithDomain:@"MyDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"服务器发生未知错误"}]];
                            }
                            else
                            {
                                [subscriber sendNext:[[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:savePath]] objectForKey:@"data"]];
                                [subscriber sendCompleted];
                                
                            }
                            
                        }
                        else if([dict[@"data"] isMemberOfClass:[NSNull class]])
                        {
                            if(!errorReturnCache){
                                [subscriber sendError:[NSError errorWithDomain:@"MyDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"服务器发生未知错误"}]];
                            }
                            else
                            {
                                [subscriber sendNext:[[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:savePath]] objectForKey:@"data"]];
                                [subscriber sendCompleted];
                                
                            }
                            
                        }
                        else
                        {
                            dict = dict[@"data"];
                            if(![dict isKindOfClass:[NSDictionary class]] &&type == PMAPIManagerReturnTypeDic)
                            {
                                if(!errorReturnCache){
                                    [subscriber sendError:[NSError errorWithDomain:@"MyDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"服务器发生未知错误"}]];
                                }
                                else
                                {
                                    [subscriber sendNext:[[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:savePath]] objectForKey:@"data"]];
                                    [subscriber sendCompleted];
                                    
                                }
                                
                            }
                            else if(![dict isKindOfClass:[NSArray class]] &&type == PMAPIManagerReturnTypeArray)
                            {
                                if(!errorReturnCache){
                                    [subscriber sendError:[NSError errorWithDomain:@"MyDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"服务器发生未知错误"}]];
                                }
                                else
                                {
                                    [subscriber sendNext:[[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:savePath]] objectForKey:@"data"]];
                                    [subscriber sendCompleted];
                                    
                                }
                                
                            }
                            else if(![dict isKindOfClass:[NSString class]] &&type == PMAPIManagerReturnTypeStr)
                            {
                                if(!errorReturnCache){
                                    [subscriber sendError:[NSError errorWithDomain:@"MyDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"服务器发生未知错误"}]];
                                }
                                else
                                {
                                    [subscriber sendNext:[[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:savePath]] objectForKey:@"data"]];
                                    [subscriber sendCompleted];
                                    
                                }
                                
                            }
                            else if(![dict isKindOfClass:[NSValue class]] &&type == PMAPIManagerReturnTypeValue)
                            {
                                if(!errorReturnCache){
                                    [subscriber sendError:[NSError errorWithDomain:@"MyDomain" code:0 userInfo:@{NSLocalizedDescriptionKey:@"服务器发生未知错误"}]];
                                }
                                else
                                {
                                    
                                    [subscriber sendNext:[[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:savePath]] objectForKey:@"data"]];
                                    [subscriber sendCompleted];
                                    
                                }
                                
                            }
                            else
                            {
                                NSDictionary *result = @{@"data":dict};
                                
                                NSData * data = [NSKeyedArchiver archivedDataWithRootObject:result];
                                [data writeToFile:savePath atomically:YES];
                                
                                [subscriber sendNext:dict];
                                [subscriber sendCompleted];
                            }
                            
                            
                        }
                    }
                }
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if(!errorReturnCache){
                [subscriber sendError:error];
            }
            else
            {
                [subscriber sendNext:[[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:savePath]] objectForKey:@"data"]];
                [subscriber sendCompleted];
                
            }
            
            
            
        }];
        
        
        [self.operationQueue addOperation:operation];
        
        return [RACDisposable disposableWithBlock:^{
            [operation cancel];
        }];
    }]  doError:^(NSError *error) {
        
    }];
    
}

/**
 获取杂志列表
 */
- (RACSignal *)fetchBookList
{
    
    return [[self fetchDataWithURLString:mUrlString(@"")
                                  params:@{@"errorReturnCache":@(YES)}
                                 headers:nil
                              returnType:PMAPIManagerReturnTypeXML httpMethod:@"get"] map:^id(NSString* value) {
        tinyxml2::XMLDocument *pDoc = new tinyxml2::XMLDocument();
        pDoc->Parse([value UTF8String]);
        tinyxml2::XMLElement *root = pDoc->RootElement();
        NSString * result = [[NSString alloc] initWithUTF8String:root->GetText() ];
        result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        NSData * resultDataChange = [[NSData alloc] initWithBase64EncodedString:result options:NSDataBase64DecodingIgnoreUnknownCharacters];
        resultDataChange = [resultDataChange qgocc_aes256_decrypt:kOrtherAESKey];
        NSString * sss = [[NSString alloc ] initWithData:resultDataChange encoding:NSUTF8StringEncoding];
        pDoc->Parse([sss UTF8String]);
        root = pDoc->RootElement();
        NSMutableArray * dataArray = [NSMutableArray arrayWithCapacity:10];
        while (root != NULL) {
            PMIssueModel * mode = [[PMIssueModel alloc] init];
            mode.name = [NSString stringWithUTF8String:root->FirstChildElement("name") != NULL?root->FirstChildElement("name")->GetText():""];
            mode.edition = [NSString stringWithUTF8String:root->FirstChildElement("edition") != NULL?root->FirstChildElement("edition")->GetText():""];
            mode.issueDescription = [NSString stringWithUTF8String:root->FirstChildElement("description") != NULL?root->FirstChildElement("description")->GetText():""];
            mode.special = [NSString stringWithUTF8String:root->FirstChildElement("special") != NULL ?root->FirstChildElement("special")->GetText():""];
            mode.issueId =  [NSString stringWithUTF8String:root->Attribute("issueId") != NULL ?root->Attribute("issueId"):""];
            mode.price =  [NSString stringWithUTF8String:root->Attribute("price") != NULL ?root->Attribute("price"):""];
            mode.package =  [NSString stringWithUTF8String:root->Attribute("package")!= NULL ?root->Attribute("package"):""];
            mode.package2x =  [NSString stringWithUTF8String:root->Attribute("package2x")!= NULL ?root->Attribute("package2x"):""];
            mode.packageSize =  [NSString stringWithUTF8String:root->Attribute("packageSize")!= NULL ?root->Attribute("packageSize"):""];
            mode.packageSize2x =  [NSString stringWithUTF8String:root->Attribute("packageSize2x")!= NULL ?root->Attribute("packageSize2x"):""];
            mode.packageMD5 =  [NSString stringWithUTF8String:root->Attribute("packageMD5")!= NULL ?root->Attribute("packageMD5"):""];
            mode.package2xMD5 =  [NSString stringWithUTF8String:root->Attribute("package2xMD5")!= NULL ?root->Attribute("package2xMD5"):""];
            mode.packageUpdated =  [NSString stringWithUTF8String:root->Attribute("packageUpdated")!= NULL ?root->Attribute("packageUpdated"):""];
            mode.package2xUpdated =  [NSString stringWithUTF8String:root->Attribute("package2xUpdated")!= NULL ?root->Attribute("package2xUpdated"):""];
            mode.toc =  [NSString stringWithUTF8String:root->Attribute("toc")!= NULL ?root->Attribute("toc"):""];
            
        
            mode.coverSmall =  [NSString stringWithUTF8String:root->Attribute("coverSmall")!= NULL ?root->Attribute("coverSmall"):""];
            mode.coverSmall2x =  [NSString stringWithUTF8String:root->Attribute("coverSmall2x")!= NULL ?root->Attribute("coverSmall2x"):""];
            mode.coverMedium =  [NSString stringWithUTF8String:root->Attribute("coverMedium")!= NULL ?root->Attribute("coverMedium"):""];
            mode.coverMedium2x =  [NSString stringWithUTF8String:root->Attribute("coverMedium2x")!= NULL ?root->Attribute("coverMedium2x"):""];
            mode.coverLarge =  [NSString stringWithUTF8String:root->Attribute("coverLarge")!= NULL ?root->Attribute("coverLarge"):""];
            mode.coverLarge2x =  [NSString stringWithUTF8String:root->Attribute("coverLarge2x")!= NULL ?root->Attribute("coverLarge2x"):""];
            mode.datePublished =  [NSString stringWithUTF8String:root->Attribute("datePublished")!= NULL ?root->Attribute("datePublished"):""];
            mode.dateUpdated =  [NSString stringWithUTF8String:root->Attribute("dateUpdated")!= NULL ?root->Attribute("dateUpdated"):""];
            
            [dataArray addObject:mode];
            root = root->NextSiblingElement();
        }
    
        return dataArray;
    }];
    
}
@end
