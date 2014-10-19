/*
 * File: Swizzler.h
 * Author: github.com/stl
 */

#import <objc/runtime.h>
#import "Swizzler.h"

// Prefix to methods that will be swizzled.
#define SWIZZLE_PREFIX_STRING @"MSF_"

// Length of swizzle prefix string.
#define SWIZZLE_PREFIX_LENGTH 4

@implementation Swizzler

+ (void) extendClass: (NSString*) aStr withClass: (NSString*) bStr {
    Class aClass = NSClassFromString(aStr);
    Class bClass = NSClassFromString(bStr);

    uint methodCount, i;
    Method* bMethods = class_copyMethodList(bClass, &methodCount);

    for (i = 0; i < methodCount; i++) {
        Method bMethod = bMethods[i];
        SEL bSel = method_getName(bMethod);

        class_addMethod(aClass, bSel,
                        method_getImplementation(bMethod),
                        method_getTypeEncoding(bMethod));

        bStr = NSStringFromSelector(bSel);

        if ([bStr hasPrefix: SWIZZLE_PREFIX_STRING]) {
            aStr = [bStr substringFromIndex: SWIZZLE_PREFIX_LENGTH];
            SEL aSel = NSSelectorFromString(aStr);

            method_exchangeImplementations(class_getInstanceMethod(aClass, aSel),
                                           class_getInstanceMethod(aClass, bSel));
            
            NSLog(@"Swizzling %@", aStr);
        }
    }
    free(bMethods);
}

@end
