Date: Tue, 17 Sep 2019 19:30:29 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
Message-ID: <20190917183029.GH1131@ZenIV.linux.org.uk>
References: <20190906100324.8492-1-stefanha@redhat.com>
	<CAFLxGvw-n2VYcYR9kei7Hu2RBhCG9PeWuW7Z+SaiyDQVBRiugw@mail.gmail.com>
	<20190909070039.GB13708@stefanha-x1.localdomain>
	<CAFLxGvw51qeifCLwhV-8DKXNwC9=_5hFf==e7h4YCvFE5_Wz0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvw51qeifCLwhV-8DKXNwC9=_5hFf==e7h4YCvFE5_Wz0A@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [Virtio-fs] [PATCH] init/do_mounts.c: add virtiofs root fs
	support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, David Howells <dhowells@redhat.com>, virtio-fs@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Tue, Sep 17, 2019 at 08:19:55PM +0200, Richard Weinberger wrote:

> mtd, ubi, virtiofs and 9p have one thing in common, they are not block devices.
> What about a new miscroot= kernel parameter?

How about something like xfs!sda5 or nfs!foo.local.net/bar, etc.?  With
ubi et.al. covered by the same syntax...

