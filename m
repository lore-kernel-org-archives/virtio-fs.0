Date: Wed, 17 Mar 2021 13:01:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210317170119.GE324911@redhat.com>
References: <20210316160147.289193-1-vgoyal@redhat.com>
	<20210316160147.289193-2-vgoyal@redhat.com>
	<CAJfpegtD-6Xt3JDtoOtqJLXeDzVgjfaVJhHU8OQ8Lpw9tu2FzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegtD-6Xt3JDtoOtqJLXeDzVgjfaVJhHU8OQ8Lpw9tu2FzA@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 1/1] fuse: send file mode updates using
	SETATTR
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, Seth Forshee <seth.forshee@canonical.com>

On Wed, Mar 17, 2021 at 04:43:35PM +0100, Miklos Szeredi wrote:
> On Tue, Mar 16, 2021 at 5:02 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > If ACL changes, it is possible that file mode permission bits change. As of
> > now fuse client relies on file server to make those changes. But it does
> > not send enough information to server so that it can decide where SGID
> > bit should be cleared or not. Server does not know if caller has CAP_FSETID
> > or not. It also does not know what are caller's group memberships and if any
> > of the groups match file owner group.
> 
> Right.  So what about performing the capability and group membership
> check in the client and sending the result of this check to the
> server?

Hi Miklos,

But that will still be non-atomic, right? I mean server probably will
do setxattr first, then check if SGID was cleared or not, and if it
has not been cleared, then it needs to set the mode.

IOW, we still have two operations (setxattr followed by mode setting).

I had thought about that option. But could not understand what does
it buy us as opposed to guest sending a SETATTR.

> 
> Yes, need to extend fuse_setxattr_in.

Ok.
> 
> There's still a race with uid and gid changing on the underlying
> filesystem, so the attributes need to be refreshed, but I don't think
> that's a big worry.

Yes, attributes will need to be refreshed.

Thanks
Vivek

