MIME-Version: 1.0
References: <20200424133516.73077-1-mreitz@redhat.com>
	<20200427175902.GM2923@work-vm>
	<20200428145143.GB107541@stefanha-x1.localdomain>
	<CAOssrKcoXBAxE=Ld5ZY79G=Dy=qBh3HdSxxC+nMGJOX52rUxxg@mail.gmail.com>
	<20200428191523.GU2794@work-vm>
	<0da9422f-6399-6ef0-1042-4b2b90d49ed8@redhat.com>
In-Reply-To: <0da9422f-6399-6ef0-1042-4b2b90d49ed8@redhat.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Wed, 29 Apr 2020 10:52:46 +0200
Message-ID: <CAOssrKfA_7cAio6i4Zy5hM-6VwBXphja6ps4s_NKrLsoF1yC+Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
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
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

On Wed, Apr 29, 2020 at 10:31 AM Max Reitz <mreitz@redhat.com> wrote:
>
> On 28.04.20 21:15, Dr. David Alan Gilbert wrote:

> > So are you saying we need a:
> >        if (mount(NULL, "/", NULL, MS_REC | MS_SHARED, NULL) < 0) {
> >
> >   and can this go straight after (1) ?
>
> Isn’t MS_SHARED and MS_SLAVE mutually exclusive, that is, both are just
> different propagation types?  So shouldn’t putting this after (1) be
> effectively the same as replacing (1)?

No, think of it more like a set of groups (mounts in a group have the
same "shared:$ID" tag in /proc/self/mountinfo) and these groups being
arranged into a tree, where child groups get propagation from the
parent group (mounts have a "master:$PARENT_ID" tag), but not the
other way round.

So if a mount is part of a shared group and this group is also the
child of another shared group, then it will have both a "shared:$ID"
and a "master:$PARENT_ID" tag in /proc/self/mountinfo.

For the gory details see Documentation/filesystems/sharedsubtree.txt

Thanks,
Miklos


