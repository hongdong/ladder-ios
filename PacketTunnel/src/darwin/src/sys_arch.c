#include <mach/mach_time.h>
#include "arch/sys_arch.h"
#include "lwip/sys.h"

void sys_init(void) {
}

void sio_send(u8_t c, sio_fd_t fd) {
}

u32_t sio_tryread(sio_fd_t fd, u8_t *data, u32_t len) {
	return 0;
}

sio_fd_t sio_open(u8_t devnum) {
	return 0;
}

u32_t sys_now(void) {
	uint64_t now = mach_absolute_time();
	mach_timebase_info_data_t info;
	mach_timebase_info(&info);
	now = now * info.numer / info.denom / NSEC_PER_MSEC;
	return (u32_t)(now);
}
