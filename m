Date: Tue, 28 Apr 2020 11:19:45 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200428101945.GB2794@work-vm>
References: <20200424133516.73077-1-mreitz@redhat.com>
	<20200427175902.GM2923@work-vm>
	<8aa9aea2-cc5d-f9b5-5cdb-b5e596ef89aa@redhat.com>
	<20200428095935.GA2794@work-vm>
	<537eb3fe-d930-1d8e-1597-1b73831d0623@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <537eb3fe-d930-1d8e-1597-1b73831d0623@redhat.com>
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
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

* Max Reitz (mreitz@redhat.com) wrote:
> On 28.04.20 11:59, Dr. David Alan Gilbert wrote:
> > * Max Reitz (mreitz@redhat.com) wrote:
> >> On 27.04.20 19:59, Dr. David Alan Gilbert wrote:
> >>> * Max Reitz (mreitz@redhat.com) wrote:
> >>>> Currently, setup_mounts() bind-mounts the shared directory without
> >>>> MS_REC.  This makes all submounts disappear.
> >>>>
> >>>> Pass MS_REC so that the guest can see submounts again.
> >>>
> >>> Thanks!
> >>>
> >>>> Fixes: 3ca8a2b1c83eb185c232a4e87abbb65495263756
> >>>
> >>> Should this actually be 5baa3b8e95064c2434bd9e2f312edd5e9ae275dc ?
> >>
> >> Well, I bisected it and landed at 3ca8a2b1.  So while the problematic
> >> line may have been introduced by 5baa3b8e, it wasn’t used until 3ca8a2b1.
> > 
> > OK, I'd rather stick with the Fixes: for the patch that was actually
> > wrong.
> 
> Why not both? :)
> 
> >>>> Signed-off-by: Max Reitz <mreitz@redhat.com>
> >>>> ---
> >>>>  tools/virtiofsd/passthrough_ll.c | 2 +-
> >>>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> >>>> index 4c35c95b25..9d7f863e66 100644
> >>>> --- a/tools/virtiofsd/passthrough_ll.c
> >>>> +++ b/tools/virtiofsd/passthrough_ll.c
> >>>> @@ -2643,7 +2643,7 @@ static void setup_mounts(const char *source)
> >>>>      int oldroot;
> >>>>      int newroot;
> >>>>  
> >>>> -    if (mount(source, source, NULL, MS_BIND, NULL) < 0) {
> >>>> +    if (mount(source, source, NULL, MS_BIND | MS_REC, NULL) < 0) {
> >>>>          fuse_log(FUSE_LOG_ERR, "mount(%s, %s, MS_BIND): %m\n", source, source);
> >>>>          exit(1);
> >>>>      }
> >>>
> >>> Do we want MS_SLAVE to pick up future mounts that might happenf rom the
> >>> host?
> >>
> >> Hm.  So first it looks to me from the man page like one shouldn’t give
> >> MS_SLAVE on the first mount() call but kind of only use it for remounts
> >> (in the list at the start, “Create a bind mount” is separate from
> >> “Change the propagation type of an existing mount”, and the man page
> >> later says “The only other flags that can be specified while changing
> >> the propagation type are MS_REC (described below) and MS_SILENT (which
> >> is ignored).”).
> >>
> >> Second, even if I do change the propagation type to MS_SLAVE in a second
> >> call, mounts done after qemu has been started don’t show up in the guest
> >> (for me).
> >>
> >> So while it sounds correct, I can’t see it having an effect, actually.
> > 
> > That's unfortunate; but I guess we can debug that separately
> > 
> >>> What's the interaction between this and the MS_REC|MS_SLAVE that we have
> >>> a few lines above for / ?
> >>
> >> Good question.  It would seem to me that there isn’t any.  That previous
> >> mount call just sets MS_REC | MS_SLAVE for the whole mount namespace,
> >> and then we do a new mount here (by default from / to /) that needs its
> >> own flags.
> >>
> >> (More interesting is perhaps why we have that other mount() call below,
> >> which again sets MS_REC | MS_SLAVE for the old (not-yet-bind-mounted) /.
> >>  I can’t imagine that to have any effect.)
> > 
> > Is that just trying to be careful before the umount2 so it doesn't try
> > to unmount something useful?
> 
> Perhaps, but still, it shouldn’t matter.  I rather suspect that
> setup_namespaces() and setup_mounts() were developed (or taken from
> elsewhere) independently, so they both have to work independently, and
> thus they do overlapping stuff.

Yep, agreed.

Dave

> Max
> 



--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

