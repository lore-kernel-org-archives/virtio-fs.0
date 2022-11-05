Return-Path: <mst@redhat.com>
Date: Sat, 5 Nov 2022 17:59:40 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20221105175822-mutt-send-email-mst@kernel.org>
References: <20221105172453.445049-1-mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20221105172453.445049-1-mst@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH RFC 0/3] virtio fix up started checks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, virtio-fs@redhat.com

On Sat, Nov 05, 2022 at 02:16:29PM -0400, Michael S. Tsirkin wrote:
> This is an attempt to fix up device started checks.
> Unfortunately this causes failures in CI
> and I could not figure it out.
> 
> The simplest way to test is to set QEMU_CI to 2
> on gitlab, then push there.
> 
> Alternatively, push to gitlab, then
> create pipeline while setting QEMU_CI to 1,
> then run amd64-fedora-container and then clang-system -
> that slows things down enough to make the failures
> trigger.
> 
> See: https://gitlab.com/mstredhat/qemu/-/jobs/3279537476

And here is a backtrace:

――――――――――――――――――――――――――――――――――――― ✀  ―――――――――――――――――――――――――――――――――――――
stderr:
qemu-system-arm: Failed to write msg. Wrote -1 instead of 20.
qemu-system-arm: vhost VQ 0 ring restore failed: -22: Invalid argument (22)
qemu-system-arm: Failed to set msg fds.
qemu-system-arm: vhost VQ 1 ring restore failed: -22: Invalid argument (22)
qemu-system-arm: -chardev socket,id=chr-reconnect,path=/tmp/vhost-test-PIIDV1/reconnect.sock,server=on: info: QEMU waiting for connection on: disconnected:unix:/tmp/vhost-test-PIIDV1/reconnect.sock,server=on
qemu-system-arm: Failed to write msg. Wrote -1 instead of 20.
qemu-system-arm: vhost VQ 0 ring restore failed: -22: Invalid argument (22)
qemu-system-arm: Failed to set msg fds.
qemu-system-arm: vhost VQ 1 ring restore failed: -22: Invalid argument (22)
qemu-system-arm: -chardev socket,id=chr-connect-fail,path=/tmp/vhost-test-U7IGV1/connect-fail.sock,server=on: info: QEMU waiting for connection on: disconnected:unix:/tmp/vhost-test-U7IGV1/connect-fail.sock,server=on
qemu-system-arm: -netdev vhost-user,id=hs0,chardev=chr-connect-fail,vhostforce=on: Failed to read msg header. Read 0 instead of 12. Original request 1.
qemu-system-arm: -netdev vhost-user,id=hs0,chardev=chr-connect-fail,vhostforce=on: vhost_backend_init failed: Protocol error
qemu-system-arm: -netdev vhost-user,id=hs0,chardev=chr-connect-fail,vhostforce=on: failed to init vhost_net for queue 0
qemu-system-arm: -netdev vhost-user,id=hs0,chardev=chr-connect-fail,vhostforce=on: info: QEMU waiting for connection on: disconnected:unix:/tmp/vhost-test-U7IGV1/connect-fail.sock,server=on
qemu-system-arm: Failed to write msg. Wrote -1 instead of 20.
qemu-system-arm: vhost VQ 0 ring restore failed: -22: Invalid argument (22)
qemu-system-arm: Failed to set msg fds.
qemu-system-arm: vhost VQ 1 ring restore failed: -22: Invalid argument (22)
qemu-system-arm: -chardev socket,id=chr-flags-mismatch,path=/tmp/vhost-test-BUYEV1/flags-mismatch.sock,server=on: info: QEMU waiting for connection on: disconnected:unix:/tmp/vhost-test-BUYEV1/flags-mismatch.sock,server=on
qemu-system-arm: Failed to write msg. Wrote -1 instead of 52.
qemu-system-arm: vhost_set_mem_table failed: Invalid argument (22)
qemu-system-arm: unable to start vhost net: 22: falling back on userspace virtio
vhost lacks feature mask 0x40000000 for backend
qemu-system-arm: failed to init vhost_net for queue 0
qemu-system-arm: Failed to set msg fds.
qemu-system-arm: vhost VQ 0 ring restore failed: -22: Invalid argument (22)
qemu-system-arm: Failed to set msg fds.
qemu-system-arm: vhost VQ 1 ring restore failed: -22: Invalid argument (22)
qemu-system-arm: Failed to write msg. Wrote -1 instead of 20.
qemu-system-arm: vhost VQ 0 ring restore failed: -22: Invalid argument (22)
qemu-system-arm: Failed to set msg fds.
qemu-system-arm: vhost VQ 1 ring restore failed: -22: Invalid argument (22)
qemu-system-arm: Failed to set msg fds.
qemu-system-arm: vhost VQ 2 ring restore failed: -22: Invalid argument (22)
qemu-system-arm: Failed to set msg fds.
qemu-system-arm: vhost VQ 3 ring restore failed: -22: Invalid argument (22)
qemu-system-arm: Failed to write msg. Wrote -1 instead of 20.
qemu-system-arm: vhost VQ 0 ring restore failed: -22: Invalid argument (22)
qemu-system-arm: Failed to set msg fds.
qemu-system-arm: vhost VQ 1 ring restore failed: -22: Invalid argument (22)
qemu-system-arm: Failed to write msg. Wrote -1 instead of 20.
qemu-system-arm: vhost VQ 0 ring restore failed: -22: Invalid argument (22)
qemu-system-arm: Failed to set msg fds.
qemu-system-arm: vhost VQ 1 ring restore failed: -22: Invalid argument (22)
qemu-system-arm: Failed to set msg fds.
qemu-system-arm: vhost VQ 0 ring restore failed: -22: Invalid argument (22)
qemu-system-arm: Failed to set msg fds.
qemu-system-arm: vhost VQ 1 ring restore failed: -22: Invalid argument (22)
qemu-system-arm: Failed to set msg fds.
qemu-system-arm: vhost_set_vring_call failed: Invalid argument (22)
qemu-system-arm: Failed to set msg fds.
qemu-system-arm: vhost_set_vring_call failed: Invalid argument (22)
qemu-system-arm: Failed to write msg. Wrote -1 instead of 20.
qemu-system-arm: vhost VQ 0 ring restore failed: -5: Input/output error (5)
UndefinedBehaviorSanitizer:DEADLYSIGNAL
==8747==ERROR: UndefinedBehaviorSanitizer: SEGV on unknown address 0x0000000000fc (pc 0x55b8ada1276d bp 0x000000000007 sp 0x7ffd127cf5f0 T8747)
==8747==The signal is caused by a WRITE memory access.
==8747==Hint: address points to the zero page.
    #0 0x55b8ada1276d in virtio_bus_release_ioeventfd /builds/mstredhat/qemu/build/../hw/virtio/virtio-bus.c:216:30
    #1 0x55b8ade97b51 in vu_gpio_set_status /builds/mstredhat/qemu/build/../hw/virtio/vhost-user-gpio.c:172:9
    #2 0x55b8ade593f9 in virtio_set_status /builds/mstredhat/qemu/build/../hw/virtio/virtio.c:2442:9
    #3 0x55b8ada4d3d7 in vm_state_notify /builds/mstredhat/qemu/build/../softmmu/runstate.c:334:13
    #4 0x55b8ada4459a in do_vm_stop /builds/mstredhat/qemu/build/../softmmu/cpus.c:262:9
    #5 0x55b8ada4e2db in qemu_cleanup /builds/mstredhat/qemu/build/../softmmu/runstate.c:827:5
    #6 0x55b8ad6054fc in qemu_default_main /builds/mstredhat/qemu/build/../softmmu/main.c:38:5
    #7 0x7f3da8999eaf in __libc_start_call_main (/lib64/libc.so.6+0x3feaf)
    #8 0x7f3da8999f5f in __libc_start_main@GLIBC_2.2.5 (/lib64/libc.so.6+0x3ff5f)
    #9 0x55b8ad5dc094 in _start (/builds/mstredhat/qemu/build/qemu-system-arm+0xc17094)
UndefinedBehaviorSanitizer can not provide additional info.
SUMMARY: UndefinedBehaviorSanitizer: SEGV /builds/mstredhat/qemu/build/../hw/virtio/virtio-bus.c:216:30 in virtio_bus_release_ioeventfd
==8747==ABORTING
../tests/qtest/libqtest.c:179: kill_qemu() tried to terminate QEMU process but encountered exit status 1 (expected 0)
**
ERROR:../tests/qtest/qos-test.c:191:subprocess_run_one_test: child process (/arm/virt/virtio-mmio/virtio-bus/vhost-user-gpio-device/vhost-user-gpio/vhost-user-gpio-tests/read-guest-mem/memfile/subprocess [8737]) failed unexpectedly
(test program exited with status code -6)
――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――



https://gitlab.com/mstredhat/qemu/-/jobs/3279637541


gpio attempts to stop backend when notifiers are not enabled.

No clue how that triggers.



> 
> Alex, Viresh, need your help here. Thanks!
> 
> Alex, pls note that same failures are triggered by your RFC - if we know the
> root cause we can discuss solutions. So if you prefer pls go ahead and
> debug that. Thanks!
> 
> Michael S. Tsirkin (3):
>   virtio: distinguish between started and running
>   gpio: use virtio_device_running
>   virtio: revert changes to virtio_device_started
> 
>  include/hw/virtio/virtio.h   | 7 ++++++-
>  hw/virtio/vhost-user-fs.c    | 2 +-
>  hw/virtio/vhost-user-gpio.c  | 4 ++--
>  hw/virtio/vhost-user-i2c.c   | 4 ++--
>  hw/virtio/vhost-user-rng.c   | 4 ++--
>  hw/virtio/vhost-user-vsock.c | 2 +-
>  hw/virtio/vhost-vsock.c      | 2 +-
>  7 files changed, 15 insertions(+), 10 deletions(-)
> 
> -- 
> MST
> 

