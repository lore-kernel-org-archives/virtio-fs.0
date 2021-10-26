DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=8DfdHsgRGfRYDFyOlx7BhB4eR5HyQPULbChWSwlujqM=;
	b=DQ2ClPENcpuSWhEkviDxhrir5Owrb+DaQYTA67p5MIxZfgZZ7ycqJ0g2CqeXeZlV/o
	bm+XkeGEpxX5dLvrTHcTLXEgLbWVOtj7OtfeofGcahgCNRAWKtuaVHEHJOvLaNpSYW+o
	Y27lmoYmNirPCFfHOR5XeXBsp/tZeJTpAMzrUUi5Fgw9r90KtrEAr0Xj0bxINpyh2Cfl
	yKxot7jueXi26V7siKtEgRUNKJOM8z16gHNeTKa6hfhdjaRNe9Dc19vAoO3IbqyeH5wz
	xdBxY0CNOwrrm7DqeZPuZsKm0rdA1OAJib+duimqtw0Q9G6puIk8v4EaUhpkh6op3iBw
	6LJQ==
MIME-Version: 1.0
References: <20211025204634.2517-1-iangelak@redhat.com>
	<CAOQ4uxieK3KpY7pf0YTKcrNHW7rnTATTDZdK9L4Mqy32cDwV8w@mail.gmail.com>
	<YXgqRb21hvYyI69D@redhat.com>
In-Reply-To: <YXgqRb21hvYyI69D@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 26 Oct 2021 20:59:44 +0300
Message-ID: <CAOQ4uxhpCKK2MYxSmRJYYMEWaHKy5ezyKgxaM+YAKtpjsZkD-g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [RFC PATCH 0/7] Inotify support in FUSE and virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Steve French <sfrench@samba.org>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, linux-kernel <linux-kernel@vger.kernel.org>, virtio-fs-list <virtio-fs@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Oct 26, 2021 at 7:18 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, Oct 26, 2021 at 06:23:50PM +0300, Amir Goldstein wrote:
>
> [..]
> > > 3) The lifetime of the local watch in the guest kernel is very
> > > important. Specifically, there is a possibility that the guest does not
> > > receive remote events on time, if it removes its local watch on the
> > > target or deletes the inode (and thus the guest kernel removes the watch).
> > > In these cases the guest kernel removes the local watch before the
> > > remote events arrive from the host (virtiofsd) and as such the guest
> > > kernel drops all the remote events for the target inode (since the
> > > corresponding local watch does not exist anymore).
>
> So this is one of the issues which has been haunting us in virtiofs. If
> a file is removed, for local events, event is generated first and
> then watch is removed. But in case of remote filesystems, it is racy.
> It is possible that by the time event arrives, watch is already gone
> and application never sees the delete event.
>
> Not sure how to address this issue.

Can you take me through the scenario step by step.
I am not sure I understand the exact sequence of the race.
If it is local file removal that causes watch to be removed,
then don't drop local events and you are good to go.
Is it something else?

Thanks,
Amir.

