Date: Mon, 20 Jul 2020 08:38:13 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200720123813.GA502563@redhat.com>
References: <612101595231414@mail.yandex.com>
	<CAOssrKeUnGKADi_d3yNvrMJ2JCum_MAc0MWfnu0bU3prrjj1jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKeUnGKADi_d3yNvrMJ2JCum_MAc0MWfnu0bU3prrjj1jQ@mail.gmail.com>
Subject: Re: [Virtio-fs] F_SETLKW not supported
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On Mon, Jul 20, 2020 at 11:33:32AM +0200, Miklos Szeredi wrote:
> On Mon, Jul 20, 2020 at 10:01 AM Aa Aa <jimbothom@yandex.com> wrote:
> >
> > Hi
> >
> > I am trying to run some java apps via virtfs and some of the file locking (java) doesn't work. Here an exception (java) is thrown something about file locking:
> >
> > Here is the strace output:
> >
> >  3541 [pid 12461] openat(AT_FDCWD, "/mnt/<redacted> O_WRONLY|O_CREAT|O_APPEND, 0666 <unfinished ...>
> >  3542 [pid 12461] <... openat resumed>)       = 180
> >  3543 [pid 12461] fstat(180, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
> >  3544 [pid 12461] fcntl(180, F_SETLKW, {l_type=F_WRLCK, l_whence=SEEK_SET, l_start=0, l_len=0} <unfinished ...>
> >  3545 [pid 12461] <... fcntl resumed>)        = -1 EOPNOTSUPP (Operation not supported)
> 
> I think that's due to an incomplete implementation of POSIX locks in virtiofsd.
> 
> Try "no_posix_lock" option: that should make locks work, but only
> locally (i.e. inside the guest).
> 
> Vivek, do we maybe want to turn off remote posix locks by default
> until the implementation is complete?

Hi Miklos,

Disabling it by default till we support blocking version of locks is
probably a good idea. That way it will work out of box without
having to specify no_posix_lock. Anyway, we don't support virtiofs
in shared mode yet. I will send a patch.

Thanks
Vivek

