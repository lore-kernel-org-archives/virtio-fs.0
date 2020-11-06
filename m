Date: Fri, 6 Nov 2020 12:18:43 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201106171843.GA1445528@redhat.com>
References: <20201009181512.65496-1-vgoyal@redhat.com>
	<20201009181512.65496-4-vgoyal@redhat.com>
	<CAJfpegu=ooDmc3hT9cOe2WEUHQN=twX01xbV+YfPQPJUHFMs-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegu=ooDmc3hT9cOe2WEUHQN=twX01xbV+YfPQPJUHFMs-g@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v3 3/6] fuse: setattr should set
 FATTR_KILL_PRIV upon size change
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>

On Fri, Nov 06, 2020 at 03:39:29PM +0100, Miklos Szeredi wrote:
> On Fri, Oct 9, 2020 at 8:16 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > If fc->handle_killpriv_v2 is enabled, we expect file server to clear
> > suid/sgid/security.capbility upon chown/truncate/write as appropriate.
> >
> > Upon truncate (ATTR_SIZE), suid/sgid is cleared only if caller does
> > not have CAP_FSETID. File server does not know whether caller has
> > CAP_FSETID or not. Hence set FATTR_KILL_PRIV upon truncate to let
> > file server know that caller does not have CAP_FSETID and it should
> > kill suid/sgid as appropriate.
> >
> > We don't have to send this information for chown (ATTR_UID/ATTR_GID)
> > as that always clears suid/sgid irrespective of capabilities of
> > calling process.
> 
> I'm  undecided on this.   Would it hurt to set it on chown?  That
> might make the logic in some servers simpler, no?
> 
> What would be the drawback of setting FATTR_KILL_PRIV for chown as well?

Hi Miklos,

Thinking loud.

So these are the rules we expect from VFS point of view.

- caps are always cleared on chown/write/truncate
- suid is always cleared on chown, while for truncate/write it is cleared
  only if caller does not have CAP_FSETID.
- sgid is always cleared on chown, while for truncate/write it is cleared
  only if caller does not have CAP_FSETID as well as file has group execute
  permission.

>From server point of view, these rules become.

- caps are always cleared on chown/write/truncate
- suid is always cleared on chown, while for truncate/write it is cleared
  only if client set appropriate flag.
  	- For truncate, this flag will either be FUSE_OPEN_KILL_PRIV or
	  FATTR_KILL_PRIV.
	- For write, FUSE_WRITE_KILL_PRIV will be set.
- sgid is always cleared on chown, while for truncate/write it is cleared
  only if caller has set a flag as well as file has group execute permission.
  	- For truncate, this flag will either be FUSE_OPEN_KILL_PRIV or
	  FATTR_KILL_PRIV.
	- For write, FUSE_WRITE_KILL_PRIV will be set.

Above rules assumes that chown() will always clear caps/suid/sgid and
server does not have to rely on any flags.

I think it does not hurt to start passing FATTR_KILL_PRIV for chown()
as well. In that case, server will always clear caps on chown but
clear suid/sgid only if FATTR_KILL_PRIV is set. (Which will always
be set).

So anything is fine. We just need to document it well. I think I will
write it very clearly in qemu patch depending on what goes in kernel.

Thanks
Vivek

