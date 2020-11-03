MIME-Version: 1.0
References: <20201102161859.156603-1-mreitz@redhat.com>
	<20201102161859.156603-6-mreitz@redhat.com>
	<CAOssrKdrRV6vbooVnMH2Hrq3XPAG6uX4N8nxgwxRDzAyKF1A1g@mail.gmail.com>
	<cecb2ca8-d15a-76e7-a34d-c37b85929961@redhat.com>
In-Reply-To: <cecb2ca8-d15a-76e7-a34d-c37b85929961@redhat.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Tue, 3 Nov 2020 10:14:03 +0100
Message-ID: <CAOssrKcqyQyYrsR9wxGKjeJ7KMAEuZ=avW3u9bhg2fhB1Y4Ypg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v3 5/7] virtiofsd: Announce sub-mount points
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>, QEMU Developers <qemu-devel@nongnu.org>

On Tue, Nov 3, 2020 at 10:00 AM Max Reitz <mreitz@redhat.com> wrote:
>
> On 03.11.20 09:10, Miklos Szeredi wrote:
> > On Mon, Nov 2, 2020 at 5:19 PM Max Reitz <mreitz@redhat.com> wrote:
> >>
> >> Whenever we encounter a directory with an st_dev or mount ID that
> >> differs from that of its parent, we set the FUSE_ATTR_SUBMOUNT flag so
> >> the guest can create a submount for it.
> >>
> >> We only need to do so in lo_do_lookup().  The following functions return
> >> a fuse_attr object:
> >> - lo_create(), though fuse_reply_create(): Calls lo_do_lookup().
> >> - lo_lookup(), though fuse_reply_entry(): Calls lo_do_lookup().
> >> - lo_mknod_symlink(), through fuse_reply_entry(): Calls lo_do_lookup().
> >> - lo_link(), through fuse_reply_entry(): Creating a link cannot create a
> >>   submount, so there is no need to check for it.
> >> - lo_getattr(), through fuse_reply_attr(): Announcing submounts when the
> >>   node is first detected (at lookup) is sufficient.  We do not need to
> >>   return the submount attribute later.
> >> - lo_do_readdir(), through fuse_add_direntry_plus(): Calls
> >>   lo_do_lookup().
> >>
> >> Make announcing submounts optional, so submounts are only announced to
> >> the guest with the announce_submounts option.  Some users may prefer the
> >> current behavior, so that the guest learns nothing about the host mount
> >> structure.
> >>
> >> (announce_submounts is force-disabled when the guest does not present
> >> the FUSE_SUBMOUNTS capability, or when there is no statx().)
> >>
> >> Signed-off-by: Max Reitz <mreitz@redhat.com>
> >> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> >> ---
> >>  tools/virtiofsd/helper.c         |  1 +
> >>  tools/virtiofsd/passthrough_ll.c | 22 ++++++++++++++++++++++
> >>  2 files changed, 23 insertions(+)
> >>
> >> diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
> >> index 2e181a49b5..4433724d3a 100644
> >> --- a/tools/virtiofsd/helper.c
> >> +++ b/tools/virtiofsd/helper.c
> >> @@ -190,6 +190,7 @@ void fuse_cmdline_help(void)
> >>             "                               retain/discard O_DIRECT flags passed down\n"
> >>             "                               to virtiofsd from guest applications.\n"
> >>             "                               default: no_allow_direct_io\n"
> >> +           "    -o announce_submounts      Announce sub-mount points to the guest\n"
> >>             );
> >>  }
> >>
> >> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> >> index 34d107975f..ec1008bceb 100644
> >> --- a/tools/virtiofsd/passthrough_ll.c
> >> +++ b/tools/virtiofsd/passthrough_ll.c
> >> @@ -40,6 +40,7 @@
> >>  #include "fuse_virtio.h"
> >>  #include "fuse_log.h"
> >>  #include "fuse_lowlevel.h"
> >> +#include "standard-headers/linux/fuse.h"
> >>  #include <assert.h>
> >>  #include <cap-ng.h>
> >>  #include <dirent.h>
> >> @@ -167,6 +168,7 @@ struct lo_data {
> >>      int readdirplus_set;
> >>      int readdirplus_clear;
> >>      int allow_direct_io;
> >> +    int announce_submounts;
> >>      bool use_statx;
> >>      struct lo_inode root;
> >>      GHashTable *inodes; /* protected by lo->mutex */
> >> @@ -207,6 +209,7 @@ static const struct fuse_opt lo_opts[] = {
> >>      { "no_readdirplus", offsetof(struct lo_data, readdirplus_clear), 1 },
> >>      { "allow_direct_io", offsetof(struct lo_data, allow_direct_io), 1 },
> >>      { "no_allow_direct_io", offsetof(struct lo_data, allow_direct_io), 0 },
> >> +    { "announce_submounts", offsetof(struct lo_data, announce_submounts), 1 },
> >>      FUSE_OPT_END
> >>  };
> >>  static bool use_syslog = false;
> >> @@ -601,6 +604,20 @@ static void lo_init(void *userdata, struct fuse_conn_info *conn)
> >>          fuse_log(FUSE_LOG_DEBUG, "lo_init: disabling readdirplus\n");
> >>          conn->want &= ~FUSE_CAP_READDIRPLUS;
> >>      }
> >> +
> >> +    if (!(conn->capable & FUSE_CAP_SUBMOUNTS) && lo->announce_submounts) {
> >> +        fuse_log(FUSE_LOG_WARNING, "lo_init: Cannot announce submounts, client "
> >> +                 "does not support it\n");
> >> +        lo->announce_submounts = false;
> >> +    }
> >> +
> >> +#ifndef CONFIG_STATX
> >> +    if (lo->announce_submounts) {
> >> +        fuse_log(FUSE_LOG_WARNING, "lo_init: Cannot announce submounts, there "
> >> +                 "is no statx()\n");
> >> +        lo->announce_submounts = false;
> >
> > Minor issue: this warns only when libc doesn't have statx, and not
> > when kernel doesn't have it.
> >
> >> +    }
> >> +#endif
> >>  }
> >>
> >>  static void lo_getattr(fuse_req_t req, fuse_ino_t ino,
> >> @@ -877,6 +894,11 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
> >>          goto out_err;
> >>      }
> >>
> >> +    if (S_ISDIR(e->attr.st_mode) && lo->announce_submounts &&
> >> +        (e->attr.st_dev != dir->key.dev || mnt_id != dir->key.mnt_id)) {
> >> +        e->attr_flags |= FUSE_ATTR_SUBMOUNT;
> >> +    }
> >
> > ... and since announce_submounts isn't turned off in case the kernel
> > doesn't have STATX_MNT_ID, this will trigger a submount when crossing
> > into a different filesystem.
>
> Oh.  Yes.  I totally forgot that when writing the warning.
>
> > Possible solutions:
> >
> > a) test and warn at startup in case kernel doesn't have statx
> >
> > b) do not test st_dev, only mnt_id (which will always be zero if not supported)
> >
> > c) merge announce_submounts and use_statx, which are basically doing
> > the same thing
>
> Isn’t that a single thing?  I.e., if we decide not to test st_dev, then
> we should do all of these, I think.
>
> OTOH, we could also just drop the warning (that statx()) isn’t
> available, because as the code is, we can still announce submounts.  The
> only problem is that we’ll suffer from the bug fixed by patch 4
> (different mounts with the same st_dev being treated as the same tree),
> but that’s unrelated to announcing submounts.
>
> (Well, to be fair, not having statx() does break one thing about
> submounts: I suppose you could mount a device inside of its own mount
> (“mount $mount_opts $dir; mount $mount_opts $dir/sub” – then $dir/sub
> wouldn’t be marked as a submount without statx()), but that probably
> yields a host of other problems besides not announcing the nested mount
> as a submount (virtiofsd would treat $dir/sub as the same node as $dir,
> I think), so again, I wouldn’t worry too much about not getting the
> FUSE_SUBMOUNT flag right.)
>
> So I think I’d rather just drop the warning and leave the rest as it is.
>  Not least because STATX_MNT_ID is rather new.

Okay, makes sense.   The nested  bind mount case is likely not very
likely to turn up in real life, and if it does, submounts can still be
disabled explicitly.

Thanks,
Miklos


