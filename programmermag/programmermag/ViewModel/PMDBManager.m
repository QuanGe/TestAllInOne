//
//  PMDBManager.m
//  programmermag
//
//  Created by 张如泉 on 15/10/19.
//  Copyright © 2015年 csdn. All rights reserved.
//

#import "PMDBManager.h"
#import "PMIssueModel.h"
static sqlite3 *contactDB = NULL;

@implementation PMDBManager

+ (instancetype)getInstance
{
    static PMDBManager *singletonCSDNDBManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonCSDNDBManager = [[self alloc] init];
    });
    return singletonCSDNDBManager;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    self.databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"issues100/offline_and_user_generated_1_0.sqlite"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    BOOL exist = [filemgr fileExistsAtPath:self.databasePath];
    
    const char *dbpath = [self.databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK)
    {
        if (!exist)
        {
            char *errMsg;
            const char *sql_download = "CREATE TABLE IF NOT EXISTS download(videoId TEXT,videoName TEXT,progress TEXT,state INTEGER,lessonId TEXT)";
            if (sqlite3_exec(contactDB, sql_download, NULL, NULL, &errMsg)!=SQLITE_OK) {
                
            }
            
        }
    }
    else
    {
        sqlite3_close(contactDB);
        contactDB = NULL;
        
    }
    
    
    return self;
}


/**
 获取所有杂志目录
 
 */
- (NSMutableArray*)fetchAllBooks
{
    
    sqlite3_stmt *statement;
    NSMutableArray * downloadArray= [NSMutableArray arrayWithCapacity:0];
    NSString *querySQL = @"SELECT  * from issue";
    const char *query_stmt = [querySQL UTF8String];
    if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString * issuePrice = @(sqlite3_column_double(statement, 1)).stringValue;
            NSString * issueEdition = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
       
            
            NSString * issueid = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
            NSString * issueName = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
            NSString * issueDes = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
            NSData * package = [NSData dataWithBytes:sqlite3_column_blob(statement, 3) length:sqlite3_column_bytes(statement,3)];
           
            PMIssueModel * model = [[PMIssueModel alloc] init];
            model.issueId = issueid;
            model.issueDescription = issueDes;
            model.name = issueName;
            model.edition = issueEdition;
            model.price = issuePrice;
            [downloadArray addObject:model];
        }
        
        sqlite3_finalize(statement);
    }
    
    return downloadArray;
}

/**
 获取我的杂志目录
 
 */
- (NSMutableArray*)fetchMylBooks
{
    
    sqlite3_stmt *statement;
    NSMutableArray * downloadArray= [NSMutableArray arrayWithCapacity:0];
    NSString *querySQL = @"SELECT  * from issue where p is not null";
    const char *query_stmt = [querySQL UTF8String];
    if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString * issuePrice = @(sqlite3_column_double(statement, 1)).stringValue;
            NSString * issueEdition = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
            
            
            NSString * issueid = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
            NSString * issueName = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
            NSString * issueDes = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
            NSData * package = [NSData dataWithBytes:sqlite3_column_blob(statement, 3) length:sqlite3_column_bytes(statement,3)];
            
            PMIssueModel * model = [[PMIssueModel alloc] init];
            model.issueId = issueid;
            model.issueDescription = issueDes;
            model.name = issueName;
            model.edition = issueEdition;
            model.price = issuePrice;
            [downloadArray addObject:model];
        }
        
        sqlite3_finalize(statement);
    }
    
    return downloadArray;
}

@end
