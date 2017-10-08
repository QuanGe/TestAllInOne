//
//  main.m
//  TestCurl
//
//  Created by 张汝泉 on 2017/10/5.
//  Copyright © 2017年 QuanGe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "fishhook.h"
//#import "curl.h"
#import <dlfcn.h>
#include <stdio.h>
#include <dlfcn.h>
#include <stdint.h>
#include <sys/mman.h>
#include <unistd.h>


//static void* (*orig_close)(void);
//static void* my_close(void) {
//    printf("Calling curl_easy_perform\n");
//    return NULL;
//}

int curl_easy_setopt(void *curl, int option, ...){
    return 0;
}
int64_t originalOffset;
int64_t *origFunc;

int64_t originalCallBackOffset;
int64_t *origCallBackFunc;
void changeCurlSetOpt(void);
size_t my_urlCallback(char *ptr,size_t size,size_t nmemeb,void *data) {
    if (origCallBackFunc) {
        // replace jump instruction w/ the original memory offset
        const size_t sizeInBytes = size *nmemeb;
        NSData * resultdata= [[NSData alloc] initWithBytes:ptr length:sizeInBytes];
        NSString *resultStr = [[NSString alloc] initWithData:resultdata encoding:NSUTF8StringEncoding];
        NSLog(@"%@",resultStr);
        *origCallBackFunc = originalCallBackOffset;
        return  ((size_t(*)(char *,size_t,size_t,void *))origCallBackFunc)(ptr,size,nmemeb,data);
    }
    return 0;
}

int my_curl_easy_setopt(void *curl, int option, ...) {
    void * last;
    va_list args;
    va_start(args, option);
    last = va_arg(args,void *);
    va_end(args);
    NSLog(@"swizzled!");
    
    *origFunc = originalOffset;
    if(option == 20011){
        origCallBackFunc = last;
        originalCallBackOffset = *origCallBackFunc;
        
        int64_t *newFunc = (int64_t*)&my_urlCallback;
        int32_t offset = (int64_t)newFunc - ((int64_t)origCallBackFunc + 5 * sizeof(char));
        
        //Make the memory containing the original funcion writable
        //Code from http://stackoverflow.com/questions/20381812/mprotect-always-returns-invalid-arguments
        size_t pageSize = sysconf(_SC_PAGESIZE);
        uintptr_t start = (uintptr_t)origCallBackFunc;
        uintptr_t end = start + 1;
        uintptr_t pageStart = start & -pageSize;
        mprotect((void *)pageStart, end - pageStart, PROT_READ | PROT_WRITE | PROT_EXEC);
        
        //Insert the jump instruction at the beginning of the original function
        int64_t instruction = 0xe9 | offset << 8;
        *origCallBackFunc = instruction;
        
        
    }
    int result =   ((int(*)(void *curl, int option, ...))origFunc)(curl,option,last);
    
    changeCurlSetOpt();
    return result;
}
/*
CURLcode my_curl_easy_perform(CURL *curl){
    NSLog(@"swizzled!");
    if (origFunc) {
        // replace jump instruction w/ the original memory offset
        *origFunc = originalOffset;
        return  ((CURLcode(*)(CURL *))origFunc)(curl);
    }
    return 15;
}
*/

int main(int argc, char * argv[]) {
//    void * aaa = curl_easy_init();
//    rebind_symbols((struct rebinding[1]){{"curl_easy_init", (void*)my_close, (void **)&orig_close}}, 1);
    @autoreleasepool {
        
        changeCurlSetOpt();
       
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

void changeCurlSetOpt(void)
{
    void *mainProgramHandle = dlopen(NULL, RTLD_NOW);
    //int64_t *origFunc = dlsym(mainProgramHandle , "qcurl_version");
    if(mainProgramHandle == NULL){
        NSLog(@"########===@@@@@====cannot open mainProgram");
        return;
    }
    origFunc = (int64_t*)dlsym(mainProgramHandle , "curl_easy_setopt");
    
    if(origFunc == NULL){
        NSLog(@"########===@@@@@====cannot find curl_easy_setopt method");
        //origFunc = (int64_t*)&curl_easy_setopt;
        return;
    }
    else{
        NSLog(@"########===@@@@@==== finded curl_easy_setopt method");
        return;
    }
    
    //origFunc = (int64_t*)&curl_easy_setopt;
    originalOffset = *origFunc;
    
    int64_t *newFunc = (int64_t*)&my_curl_easy_setopt;
    int32_t offset = (int64_t)newFunc - ((int64_t)origFunc + 5 * sizeof(char));
    
    //Make the memory containing the original funcion writable
    //Code from http://stackoverflow.com/questions/20381812/mprotect-always-returns-invalid-arguments
    size_t pageSize = sysconf(_SC_PAGESIZE);
    uintptr_t start = (uintptr_t)origFunc;
    uintptr_t end = start + 1;
    uintptr_t pageStart = start & -pageSize;
    mprotect((void *)pageStart, end - pageStart, PROT_READ | PROT_WRITE | PROT_EXEC);
    
    //Insert the jump instruction at the beginning of the original function
    int64_t instruction = 0xe9 | offset << 8;
    *origFunc = instruction;
}
