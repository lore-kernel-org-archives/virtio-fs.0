Date: Mon, 6 Jan 2020 11:43:14 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200106114314.GF2798@work-vm>
References: <20200102035312.18507-1-yangx.jy@cn.fujitsu.com>
	<20200102185540.GL2927@work-vm>
	<20200106112154.GC3163@ndevos-x270.lan.nixpanic.net>
	<20200106112422.GE2798@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106112422.GE2798@work-vm>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd/passthrough_ll: Pass errno to
 fuse_reply_err()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Niels de Vos <ndevos@redhat.com>
Cc: virtio-fs@redhat.com

* Dr. David Alan Gilbert (dgilbert@redhat.com) wrote:
> * Niels de Vos (ndevos@redhat.com) wrote:
> > On Thu, Jan 02, 2020 at 06:55:40PM +0000, Dr. David Alan Gilbert wrote:
> > > * Xiao Yang (yangx.jy@cn.fujitsu.com) wrote:
> > > > lo_copy_file_range() passes -errno to fuse_reply_err() and then fuse_reply_err()
> > > > changes it to errno again, so that subsequent fuse_send_reply_iov_nofree() catches
> > > > the wrong errno.(i.e. reports "fuse: bad error value: ...").
> > > > 
> > > > Make fuse_send_reply_iov_nofree() accept the correct -errno by passing errno
> > > > directly in lo_copy_file_range().
> > > > 
> > > > Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
> > > 
> > > Yes, I think you're right - FUSE does use +ve errno's for some things,
> > > normally the failure of the fuse channel itself; but in this case it
> > > looks like 'errno' is consistent with the other calls; this comes
> > > straight from upstream libfuse commit 2548c4b8, so lets cc in Niels.
> > 
> > Indeed, setting a negative errno is a mistake. Could you send the fix to
> > https://github.com/libfuse/libfuse (example/passthrough_ll.c) as well? I
> > am happy to do so if you prefer, just let me know.
> 
> I'll do a pull with Xiao Yang's fix.

https://github.com/libfuse/libfuse/pull/486

> Dave
> 
> > Thanks,
> > Niels
> > 
> > > 
> > > I'll take it into virtiofsd for the moment; thanks!
> > > 
> > > Dave
> > > 
> > > > ---
> > > >  tools/virtiofsd/passthrough_ll.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> > > > index 83dd0084b4..a77bed655e 100644
> > > > --- a/tools/virtiofsd/passthrough_ll.c
> > > > +++ b/tools/virtiofsd/passthrough_ll.c
> > > > @@ -2615,7 +2615,7 @@ static void lo_copy_file_range(fuse_req_t req, fuse_ino_t ino_in, off_t off_in,
> > > >  
> > > >      res = copy_file_range(in_fd, &off_in, out_fd, &off_out, len, flags);
> > > >      if (res < 0) {
> > > > -        fuse_reply_err(req, -errno);
> > > > +        fuse_reply_err(req, errno);
> > > >      } else {
> > > >          fuse_reply_write(req, res);
> > > >      }
> > > > -- 
> > > > 2.21.0
> > > > 
> > > > 
> > > > 
> > > > 
> > > > _______________________________________________
> > > > Virtio-fs mailing list
> > > > Virtio-fs@redhat.com
> > > > https://www.redhat.com/mailman/listinfo/virtio-fs
> > > --
> > > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

