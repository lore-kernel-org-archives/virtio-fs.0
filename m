Date: Tue, 26 Oct 2021 12:18:13 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YXgqRb21hvYyI69D@redhat.com>
References: <20211025204634.2517-1-iangelak@redhat.com>
	<CAOQ4uxieK3KpY7pf0YTKcrNHW7rnTATTDZdK9L4Mqy32cDwV8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxieK3KpY7pf0YTKcrNHW7rnTATTDZdK9L4Mqy32cDwV8w@mail.gmail.com>
Subject: Re: [Virtio-fs] [RFC PATCH 0/7] Inotify support in FUSE and virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Steve French <sfrench@samba.org>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, linux-kernel <linux-kernel@vger.kernel.org>, virtio-fs-list <virtio-fs@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Oct 26, 2021 at 06:23:50PM +0300, Amir Goldstein wrote:

[..]
> > 3) The lifetime of the local watch in the guest kernel is very
> > important. Specifically, there is a possibility that the guest does not
> > receive remote events on time, if it removes its local watch on the
> > target or deletes the inode (and thus the guest kernel removes the watch).
> > In these cases the guest kernel removes the local watch before the
> > remote events arrive from the host (virtiofsd) and as such the guest
> > kernel drops all the remote events for the target inode (since the
> > corresponding local watch does not exist anymore).

So this is one of the issues which has been haunting us in virtiofs. If
a file is removed, for local events, event is generated first and
then watch is removed. But in case of remote filesystems, it is racy.
It is possible that by the time event arrives, watch is already gone
and application never sees the delete event.

Not sure how to address this issue.

Vivek

