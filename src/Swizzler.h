/*
 * File: Swizzler.h
 * Author: github.com/stl
 */

/**
 * @brief Define a class which performs method-swizzling on a target class.
 */
@interface Swizzler : NSObject

+ (void) extendClass: (NSString*) aStr withClass: (NSString*) bStr;

@end
