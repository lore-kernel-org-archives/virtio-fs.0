Return-Path: <gmaglion@redhat.com>
MIME-Version: 1.0
References: <20231005203030.223489-1-vgoyal@redhat.com>
 <20231010172107.GC1754551@fedora>
In-Reply-To: <20231010172107.GC1754551@fedora>
From: German Maglione <gmaglione@redhat.com>
Date: Wed, 11 Oct 2023 20:08:11 +0200
Message-ID: <CAJh=p+6_MrouagxuaM6myEc=PCW88xqNG-vesW2GsT9f+mr+-g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH] virtiofs: Export filesystem tags through
 sysfs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, miklos@szeredi.hu, mzxreary@0pointer.de

On Tue, Oct 10, 2023 at 8:38=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat.co=
m> wrote:
>
> On Thu, Oct 05, 2023 at 04:30:30PM -0400, Vivek Goyal wrote:
> > virtiofs filesystem is mounted using a "tag" which is exported by the
> > virtiofs device. virtiofs driver knows about all the available tags but
> > these are not exported to user space.
> >
> > People have asked these tags to be exported to user space. Most recentl=
y
> > Lennart Poettering has asked for it as he wants to scan the tags and mo=
unt
> > virtiofs automatically in certain cases.
> >
> > https://gitlab.com/virtio-fs/virtiofsd/-/issues/128
> >
> > This patch exports tags through sysfs. One tag is associated with each
> > virtiofs device. A new "tag" file appears under virtiofs device dir.
> > Actual filesystem tag can be obtained by reading this "tag" file.
> >
> > For example, if a virtiofs device exports tag "myfs", a new file "tag"
> > will show up here.
> >
> > /sys/bus/virtio/devices/virtio<N>/tag
> >
> > # cat /sys/bus/virtio/devices/virtio<N>/tag
> > myfs
>
> If you respin this series, please mention that the tag is available at
> KOBJ_BIND time, but not KOBJ_ADD. Just a sentence or two is enough to
> help someone trying to figure out how to use this new sysfs attr with
> udev.

Maybe it's also worth mention, that the tag file is created after a success=
ful
probe, so the tag should be a valid one: non-empty and unique

>
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/fuse/virtio_fs.c | 34 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 34 insertions(+)
>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>



--=20
German

