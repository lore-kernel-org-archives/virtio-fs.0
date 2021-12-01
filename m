Date: Wed, 1 Dec 2021 17:10:54 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <Yafy7hF56oPn9h4/@redhat.com>
References: <CAJh=p+6o8_2UekwO0nQ8+sjcgpcEzGhFrTsiTjN4n72R3vNAGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJh=p+6o8_2UekwO0nQ8+sjcgpcEzGhFrTsiTjN4n72R3vNAGw@mail.gmail.com>
Subject: Re: [Virtio-fs] [virtiofsd][virtiofsd-rs] unlink an openfile over
	NFS
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: German Maglione <gmaglione@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Dec 01, 2021 at 01:06:23PM +0100, German Maglione wrote:
> Hi,
> 
> I was working on [1] (related to [2]), and I saw that both versions
> (C and rust) of virtiofsd make the NFs client to "silly rename" an open
> file that were unlinked, because we keep each file open as O_PATH in the
> lo_do_lookup/do_lookup function. David pointed me to this problem, and I
> confirmed that this is the case.
> 
> This fires the silly rename in the nfs client. I'm talking with
> Bruce Fields (nfs team) to see how to move the silly rename functionality
> to the nfs server and outside the directory tree [4], to avoid having
> non-really-empty
> dirs full of .nfsxxx files. But it is not an easy task.
> Also, this will not solve some potential issues with the resource usage:
> disk space and open file limits (I hit this limit a couple of times during
> my
> tests). And, in some cases could be worst, more than one guest sharing the
> same
> exported dir, one guest just 'ls' or 'find' while the other 'rm' some files.
> (The 'find' command will open all files, btw)
> 
> Vivek, I saw in [5] that you mentioned that this could be fixed introducing
> synchronous, could you elaborate a bit or point me to some code?

Hi German,

Right now forget messages are asynchronous. They are sent to server and
client does not wait for any reply. That means when unlink() returns,
it is possible that a FORGET message is in progress and has not finished
yet.

Idea behind synchronous FORGET messages is that it will generate a reply
and client will wait for it. Given inode on server should be gone,
I am not sure how much sense does it make. But anyway conceputaully
that's the idea. If we want for FORGET message to finish, that will
mean that O_PATH fd opened by virtiofsd is closed and we will not
have NFS silly rename issue (atleast due to virtiofsd). If virtiofs
client has file open, then issue will still happen.

I think using file handles in virtiofsd_rs (--inode-file-handles) is
a reasonable solution for this problem. Trying to add synchronous
FORGET might be overkill.

Thanks
Vivek
> 
> Thanks,
> [1] https://bugzilla.redhat.com/show_bug.cgi?id=2018072
> [2] https://bugzilla.redhat.com/show_bug.cgi?id=1908490
> [4] https://wiki.linux-nfs.org/wiki/index.php/Server-side_silly_rename
> [5]
> https://sourceforge.net/p/fuse/mailman/fuse-devel/?viewmonth=202101&viewday=4
> 
> 
> -- 
> German

