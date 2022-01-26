Date: Wed, 26 Jan 2022 10:51:50 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YfEnxhFIW9Y0A7O6@work-vm>
References: <YfBGoriS38eBQrAb@redhat.com>
	<YfEcdsTdIBc9nIdN@stefanha-x1.localdomain>
MIME-Version: 1.0
In-Reply-To: <YfEcdsTdIBc9nIdN@stefanha-x1.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Drop membership of all
 supplementary groups (CVE-2022-0358)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: JIETAO XIAO <shawtao1125@gmail.com>, Mauro Matteo Cascella <mcascell@redhat.com>, qemu-devel@nongnu.org, virtio-fs-list <virtio-fs@redhat.com>, P J P <pj.pandit@yahoo.co.in>, Vivek Goyal <vgoyal@redhat.com>

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Tue, Jan 25, 2022 at 01:51:14PM -0500, Vivek Goyal wrote:
> > At the start, drop membership of all supplementary groups. This is
> > not required.
> > 
> > If we have membership of "root" supplementary group and when we switch
> > uid/gid using setresuid/setsgid, we still retain membership of existing
> > supplemntary groups. And that can allow some operations which are not
> > normally allowed.
> > 
> > For example, if root in guest creates a dir as follows.
> > 
> > $ mkdir -m 03777 test_dir
> > 
> > This sets SGID on dir as well as allows unprivileged users to write into
> > this dir. 
> > 
> > And now as unprivileged user open file as follows.
> > 
> > $ su test
> > $ fd = open("test_dir/priviledge_id", O_RDWR|O_CREAT|O_EXCL, 02755);
> > 
> > This will create SGID set executable in test_dir/.
> > 
> > And that's a problem because now an unpriviliged user can execute it,
> > get egid=0 and get access to resources owned by "root" group. This is
> > privilege escalation.
> > 
> > Fixes: https://bugzilla.redhat.com/show_bug.cgi?id=2044863
> > Fixes: CVE-2022-0358
> > Reported-by: JIETAO XIAO <shawtao1125@gmail.com>
> > Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
> > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  tools/virtiofsd/passthrough_ll.c |   26 ++++++++++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> > 
> > Index: rhvgoyal-qemu/tools/virtiofsd/passthrough_ll.c
> > ===================================================================
> > --- rhvgoyal-qemu.orig/tools/virtiofsd/passthrough_ll.c	2022-01-25 13:38:59.349534531 -0500
> > +++ rhvgoyal-qemu/tools/virtiofsd/passthrough_ll.c	2022-01-25 13:39:10.140177868 -0500
> > @@ -54,6 +54,7 @@
> >  #include <sys/wait.h>
> >  #include <sys/xattr.h>
> >  #include <syslog.h>
> > +#include <grp.h>
> >  
> >  #include "qemu/cutils.h"
> >  #include "passthrough_helpers.h"
> > @@ -1161,6 +1162,29 @@ static void lo_lookup(fuse_req_t req, fu
> >  #define OURSYS_setresuid SYS_setresuid
> >  #endif
> >  
> > +static void drop_supplementary_groups(void)
> > +{
> > +    int ret;
> > +
> > +    ret = getgroups(0, NULL);
> > +    if (ret == -1) {
> > +        fuse_log(FUSE_LOG_ERR, "getgroups() failed with error=%d:%s\n",
> > +                 errno, strerror(errno));
> > +        exit(1);
> > +    }
> > +
> > +    if (!ret)
> > +        return;
> > +
> > +    /* Drop all supplementary groups. We should not need it */
> > +    ret = setgroups(0, NULL);
> > +    if (ret == -1) {
> > +        fuse_log(FUSE_LOG_ERR, "setgroups() failed with error=%d:%s\n",
> > +                 errno, strerror(errno));
> > +        exit(1);
> > +    }
> > +}
> > +
> >  /*
> >   * Change to uid/gid of caller so that file is created with
> >   * ownership of caller.
> > @@ -3926,6 +3950,8 @@ int main(int argc, char *argv[])
> >  
> >      qemu_init_exec_dir(argv[0]);
> >  
> > +    drop_supplementary_groups();
> > +
> >      pthread_mutex_init(&lo.mutex, NULL);
> >      lo.inodes = g_hash_table_new(lo_key_hash, lo_key_equal);
> >      lo.root.fd = -1;
> > 
> 
> Thanks, applied to my block tree:
> https://gitlab.com/stefanha/qemu/commits/block

Actually, I just posted it as a separate pull by itself.

(I added {}'s around the if (!ret) { return; }  to meet Qemu
style guides).

Dave


> Stefan


-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

