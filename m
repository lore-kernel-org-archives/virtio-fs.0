Date: Tue, 17 Sep 2019 19:34:25 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190917183425.GJ3370@work-vm>
References: <20190906100324.8492-1-stefanha@redhat.com>
	<CAFLxGvw-n2VYcYR9kei7Hu2RBhCG9PeWuW7Z+SaiyDQVBRiugw@mail.gmail.com>
	<20190909070039.GB13708@stefanha-x1.localdomain>
	<CAFLxGvw51qeifCLwhV-8DKXNwC9=_5hFf==e7h4YCvFE5_Wz0A@mail.gmail.com>
	<20190917183029.GH1131@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917183029.GH1131@ZenIV.linux.org.uk>
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
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <mszeredi@redhat.com>, Richard Weinberger <richard.weinberger@gmail.com>, David Howells <dhowells@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>

* Al Viro (viro@zeniv.linux.org.uk) wrote:
> On Tue, Sep 17, 2019 at 08:19:55PM +0200, Richard Weinberger wrote:
> 
> > mtd, ubi, virtiofs and 9p have one thing in common, they are not block devices.
> > What about a new miscroot= kernel parameter?
> 
> How about something like xfs!sda5 or nfs!foo.local.net/bar, etc.?  With
> ubi et.al. covered by the same syntax...

Would Stefan's patch work if there was just a way to test for non-block
based fileystsmes and we replaced
   !strcmp(root_fs_names, "virtiofs") by
   not_block_based_fs(root_fs_names)

Or is there some magic that the other filesystems do that's specific?

Dave

> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

