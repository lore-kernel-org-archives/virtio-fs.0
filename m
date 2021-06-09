Date: Wed, 9 Jun 2021 09:46:38 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210609094638.197ca7fc@bahia.lan>
In-Reply-To: <c3d49438-6ee1-32b1-1be4-41be78cec2ce@redhat.com>
References: <20210604161156.408496-1-groug@kaod.org>
	<c3d49438-6ee1-32b1-1be4-41be78cec2ce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v2 0/7] fuse: Some fixes for submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>

On Tue, 8 Jun 2021 17:52:13 +0200
Max Reitz <mreitz@redhat.com> wrote:

> On 04.06.21 18:11, Greg Kurz wrote:
> > v2:
> >
> > - add an extra fix (patch 2) : mount is now added to the list before
> >    unlocking sb->s_umount
> > - set SB_BORN just before unlocking sb->s_umount, just like it would
> >    happen when using fc_mount() (Max)
> > - don't allocate a FUSE context for the submounts (Max)
> > - introduce a dedicated context ops for submounts
> > - add a extra cleanup : simplify the code even more with fc_mount()
> >
> > v1:
> >
> > While working on adding syncfs() support in FUSE, I've hit some severe
> > bugs with submounts (a crash and an infinite loop). The fix for the
> > crash is straightforward (patch 1), but the fix for the infinite loop
> > is more invasive : as suggested by Miklos, a simple bug fix is applied
> > first (patch 2) and the final fix (patch 3) is applied on top.
> 
> Thanks a lot for these patches. I’ve had a style nit on patch 6, but 
> other than that, looks nice to me.
> 

Thanks a lot for the review !

Cheers,

--
Greg

> Max
> 


