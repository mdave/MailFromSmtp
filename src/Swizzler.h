/*
 * File: Swizzler.h
 * Author: github.com/stl
 */

/**
 * @brief Define a class which performs method-swizzling on a target class.
 */
@interface Swizzler : NSObject

+ (void) setSuperclassOf: (NSString*) aStr toClass: (NSString*) bStr;
+ (void) extendClass: (NSString*) aStr withClass: (NSString*) bStr;

@end
