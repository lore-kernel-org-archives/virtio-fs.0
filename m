MIME-Version: 1.0
References: <CAAQbG+U9m91sxsm9swLB7gYNh3NT47Z0kb9LbgEZXUMV65StLQ@mail.gmail.com>
In-Reply-To: <CAAQbG+U9m91sxsm9swLB7gYNh3NT47Z0kb9LbgEZXUMV65StLQ@mail.gmail.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Mon, 25 Jan 2021 20:22:32 +0100
Message-ID: <CAOssrKd6JkEKt98F7XhHeUhcCYP+gwnrHLE8VKTg0K-ABUxDEA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] Lack of inotify for virtio-fs backed
	files/directories
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eric Ernst <eric.g.ernst@gmail.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On Fri, Jan 22, 2021 at 5:58 PM Eric Ernst <eric.g.ernst@gmail.com> wrote:
>
> Hey ya'll,
>
> As highlighted nicely at [1], a common pattern in Kubernetes is to watch for changes to files/directories passed in as Configmaps or secrets. Sidecars typically use inotify to watch for changes and then signal the primary container or perform other changes based on the reconfiguration.
>
> In the context of Kata, these files/dirs are passed in utilizing virtio-fs. Since FUSE itself doesn't support inotify, this pattern will fail. I'm looking at ways to work-around this gap, including:
>
> 1) documenting this as a compatibility limitation ("don't do this!").
> 2) suggesting end-users modify their sidecars and utilize poll
> 3) doing an inotify on the host, and when changes are identified, notify the guest agent who can then modify the files on disk to trigger an inotify
> 4) Working on contributing to libfuse in order to add inotify support.
>
> (4) is the right thing, but will take quite a bit of time before it can be used. I'm curious if other folks have suggestions for workarounds (I don't like any of the ones I suggested), and if anyone has taken a look at (4)?

Here's a thread on enabling inotify in remote fs:

https://lore.kernel.org/linux-fsdevel/20190507085707.GD30899@veci.piliscsaba.redhat.com/

The discussion didn't get too far, it seems there's not a very big
interest in this, but conceptually it doesn't seem too difficult.

At the moment I'm busy with other things, but it's an interesting
issue so I'd be happy to look into it sometime if nobody is willing to
pick it up.

Thanks,
Miklos


