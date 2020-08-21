Date: Fri, 21 Aug 2020 16:56:54 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200821205654.GB905782@redhat.com>
References: <20200724183812.19573-1-vgoyal@redhat.com>
	<20200724183812.19573-4-vgoyal@redhat.com>
	<CAJfpeguvMvc9rXChGrSuQsO9__Ln7exozmMWVY_1B8DrsV4rpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguvMvc9rXChGrSuQsO9__Ln7exozmMWVY_1B8DrsV4rpQ@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 3/5] fuse: Add a flag FUSE_SETATTR_KILL_PRIV
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

On Fri, Aug 21, 2020 at 04:53:59PM +0200, Miklos Szeredi wrote:
> On Fri, Jul 24, 2020 at 8:38 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > With handle_killpriv_v2, server needs to kill suid/sgid on truncate (setattr)
> > but it does not know if caller has CAP_FSETID or not. So like write, send
> > killpriv information in fuse_setattr_in and add a flag FUSE_SETATTR_KILL_PRIV.
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 
> [...]
> 
> > +/**
> > + * Setattr flags
> > + * FUSE_SETATTR_KILL_PRIV: kill suid and sgid bits. sgid should be killed
> > + * only if group execute bit (S_IXGRP) is set. Meant to be used together
> > + * with FUSE_HANDLE_KILLPRIV_V2.
> > + */
> > +#define FUSE_SETATTR_KILL_PRIV (1 << 0)
> 
> Why not a FATTR_KILL_PRIV set in fuse_setattr_in.valid?

Yes, I should be able to do that. ATTR_KILL_PRIV is already there
which can map to FATTR_KILL_PRIV. Not sure why didn't I think of it.

Vivek

