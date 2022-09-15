/* mostly taken from http://newosxbook.com/src.jl?tree=listings&file=17-15-utun.c */

#include <string.h>
#include <stdio.h>
#include <sys/socket.h>
#include <sys/sys_domain.h>
#include <sys/ioctl.h>
#include <unistd.h>

/* https://github.com/apple/darwin-xnu/blob/main/bsd/sys/kern_control.h */
#include <sys/kern_control.h>

/* https://github.com/apple/darwin-xnu/blob/main/bsd/net/if_utun.h */
#include <net/if_utun.h>

int init_tun() {
    struct sockaddr_ctl sc;     /* https://developer.apple.com/documentation/kernel/sockaddr_ctl */
    struct ctl_info ctl_info;   /* https://developer.apple.com/documentation/kernel/ctl_info */
    int fd;

    memset(&ctl_info, 0, sizeof(ctl_info));

    if (strlcpy(ctl_info.ctl_name, UTUN_CONTROL_NAME, sizeof(ctl_info.ctl_name)) >= sizeof(ctl_info.ctl_name)) {
        fprintf(stderr, "strlcpy: UTUN_CONTROL_NAME too long");
        return -1;
    }

    /* SYSPROTO_CONTROL: "kernel control protocol" */
    fd = socket(PF_SYSTEM, SOCK_DGRAM, SYSPROTO_CONTROL);

    if (fd == -1) {
        perror("socket");
        return -1;
    }

    /* Can't really find documentation about this, beyond the ctl_info
     * link above :shrug: */
    if (ioctl(fd, CTLIOCGINFO, &ctl_info) == -1) {
        perror("ioctl");
        close(fd);
        return -1;
    }

    sc.sc_id = ctl_info.ctl_id;
    sc.sc_len = sizeof(sc);
    sc.sc_family = AF_SYSTEM;
    sc.ss_sysaddr = AF_SYS_CONTROL;
    sc.sc_unit = 9;             /* ummmm... sure */

    if (connect(fd, (struct sockaddr *)&sc, sizeof(sc)) == -1) {
        perror("connect");
        close(fd);
        return -1;
    }

    /* tunX device is created, where X is sc.sc_unit - 1. */

    return fd;
}

void close_tun(int fd) {
    close(fd);
}
