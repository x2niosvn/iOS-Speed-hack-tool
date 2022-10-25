// Tạo Vào Ngày 14 Tháng 7 Năm 2022
// Bởi Nguyễn Xuân Nam
// Tên file: blackmanspeed.m


#include <sys/time.h>
#include <substrate.h>
#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

//-----------------//
#define delay(sec) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec * NSEC_PER_SEC), dispatch_get_main_queue(), ^
//-----------------//

#include "blackmanspeed.h"

//-----------------//


UISlider *uslider;
UIWindow *mainWindow;


//-----------------//


int indx = 0;
static struct timeval *base = NULL;
static int (*orig_gettimeofday)(struct timeval *, struct timezone *);
static int new_gettimeofday(struct timeval *tv, struct timezone *tz) {
	int val = orig_gettimeofday(tv, tz);
	if (val == 0 && tv != NULL) {
		if (base == NULL) {
			base = malloc(sizeof(struct timeval));
			*base = *tv;
			return val;
		}
		long int diffSec = (tv->tv_sec - base->tv_sec) * uslider.value;
		long int diffUsec = (tv->tv_usec - base->tv_usec) * uslider.value;
		tv->tv_sec = base->tv_sec + diffSec;
		tv->tv_usec = base->tv_usec + diffUsec;
	}

	return val;
}


//-----------------//


@implementation NguyenNamSpeed : NSObject

static NguyenNamSpeed *active;

//-----------------//

+ (void)load
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
//-----------------//
	MSHookFunction((void *)MSFindSymbol(NULL, "_gettimeofday"), (void *)new_gettimeofday, (void **)&orig_gettimeofday);
//-----------------//
mainWindow = [UIApplication sharedApplication].keyWindow;
//-----------------//
        active =  [NguyenNamSpeed new];
        [active main];
//-----------------//
    });
}
//-----------------//
-(void)main{
uslider = [[UISlider alloc] initWithFrame:CGRectMake(500, 92, 100, 20)];
uslider.minimumValue = 1.0;
uslider.maximumValue = 10.0;
uslider.continuous = YES;
uslider.value = 1;
[mainWindow addSubview:uslider];
}
//-----------------//
@end
