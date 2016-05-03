#import <Foundation/Foundation.h>

@interface DispatchHelper : NSObject

+ (nonnull dispatch_queue_t)currentQueue;

@end
