//
//  ARCSingletonTemplate.h
//  PhoneＭonitoring
//
//  Created by Hcat on 13-8-7.
//  Copyright (c) 2013年 Hcat. All rights reserved.
//

#define SYNTHESIZE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SYNTHESIZE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
    static className *shared##className = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        shared##className = [[self alloc] init]; \
    }); \
    return shared##className; \
}