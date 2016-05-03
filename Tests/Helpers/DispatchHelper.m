#import "DispatchHelper.h"

@implementation DispatchHelper

+ (dispatch_queue_t)currentQueue
{
  return dispatch_get_current_queue();
}

@end
