Date: Thu, 30 Apr 2020 09:58:12 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200430085812.GC2874@work-vm>
References: <20200424133516.73077-1-mreitz@redhat.com>
	<20200427175902.GM2923@work-vm> <20200429145720.GA2835@work-vm>
	<8c73f374-fcc8-1684-b581-84a9ab501aa9@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8c73f374-fcc8-1684-b581-84a9ab501aa9@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Show submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com

* Max Reitz (mreitz@redhat.com) wrote:
> On 29.04.20 16:57, Dr. David Alan Gilbert wrote:
> > * Dr. David Alan Gilbert (dgilbert@redhat.com) wrote:
> >> * Max Reitz (mreitz@redhat.com) wrote:
> >>> Currently, setup_mounts() bind-mounts the shared directory without
> >>> MS_REC.  This makes all submounts disappear.
> >>>
> >>> Pass MS_REC so that the guest can see submounts again.
> >>
> >> Thanks!
> >>
> >>> Fixes: 3ca8a2b1c83eb185c232a4e87abbb65495263756
> >>
> >> Should this actually be 5baa3b8e95064c2434bd9e2f312edd5e9ae275dc ?
> >>
> >>> Signed-off-by: Max Reitz <mreitz@redhat.com>
> >>> ---
> >>>  tools/virtiofsd/passthrough_ll.c | 2 +-
> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> >>> index 4c35c95b25..9d7f863e66 100644
> >>> --- a/tools/virtiofsd/passthrough_ll.c
> >>> +++ b/tools/virtiofsd/passthrough_ll.c
> >>> @@ -2643,7 +2643,7 @@ static void setup_mounts(const char *source)
> >>>      int oldroot;
> >>>      int newroot;
> >>>  
> >>> -    if (mount(source, source, NULL, MS_BIND, NULL) < 0) {
> >>> +    if (mount(source, source, NULL, MS_BIND | MS_REC, NULL) < 0) {
> >>>          fuse_log(FUSE_LOG_ERR, "mount(%s, %s, MS_BIND): %m\n", source, source);
> >>>          exit(1);
> >>>      }
> >>
> >> Do we want MS_SLAVE to pick up future mounts that might happenf rom the
> >> host?
> >> What's the interaction between this and the MS_REC|MS_SLAVE that we have
> >> a few lines above for / ?
> > 
> > Just to confirm something from vgoyal, and what had confused me about
> > why we hadn't spotted this earlier.
> > 
> > Even without this patch, the SLAVE stuff worked so if you start the
> > daemon and *then* mount under the shared directory, the guest sees it
> > with or without this patch.
> 
> Hm, I don’t.  Do you really?

Yes! With your patch reverted:

Start virtiofsd, mount in the guest:

host:
# ./virtiofsd --socket-path=/tmp/vhostqemu -o source=/home/dgilbert/virtio-fs/fs  -o log_level=warn -o no_writeback

guest:
# mount -t virtiofs myfs /sysroot

host:
# findmnt -o +PROPAGATION -N 6100
TARGET SOURCE                                                              FSTYPE OPTIONS                                                      PROPAGATION
/      /dev/mapper/fedora_dgilbert--t580-root[/home/dgilbert/virtio-fs/fs] xfs    rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,no private,slave
# mount -t tmpfs /dev/null /home/dgilbert/virtio-fs/fs/tmp
# findmnt -o +PROPAGATION -N 6100
TARGET SOURCE                                                              FSTYPE OPTIONS                                                      PROPAGATION
/      /dev/mapper/fedora_dgilbert--t580-root[/home/dgilbert/virtio-fs/fs] xfs    rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,no private,slave
└─/tmp /dev/null                                                           tmpfs  rw,relatime,seclabel                                         private,slave
# touch /home/dgilbert/virtio-fs/fs/tmp/hello

guest:
# ls -l /sysroot/tmp
total 0
-rw-r--r-- 1 root root 0 Apr 30 08:50 hello

Maybe this is related to what Vivek said about default behaviours on
systemd's, what does:

# findmnt -o +PROPAGATION
TARGET    SOURCE         FSTYPE     OPTIONS                                                                                  PROPAGATION
/         /dev/mapper/fedora_dgilbert--t580-root
│                        xfs        rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota                        shared

say for your source= directory?

Dave

> Max
> 



--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

