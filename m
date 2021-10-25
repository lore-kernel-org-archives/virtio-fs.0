Date: Mon, 25 Oct 2021 13:32:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YXbqL6qTfi/gzOOJ@redhat.com>
References: <5e79ba8579b33e60e9670f2fd99b1c1b@posteo.de>
	<YXauFapuRuxXRR2k@redhat.com>
	<0c4d0bb990217000fe24f4a8522dcfa3@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c4d0bb990217000fe24f4a8522dcfa3@posteo.de>
Subject: Re: [Virtio-fs] write permissions for Windows host on Linux guest
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: birnenkram@posteo.de
Cc: virtio-fs-list <virtio-fs@redhat.com>, Gal Hammer <ghammer@redhat.com>

On Mon, Oct 25, 2021 at 04:28:45PM +0000, birnenkram@posteo.de wrote:
> Hi Vivek,
> 

Hi Michael,

[ CC virtio-fs list, Gal Hammer ]

Lets keep the discussion on mailing list. Not sure if you removed mailing
list from cc list accidently.

> thanks for your answer. Based on it I tried again, this time using matching
> uids on guest and host (by creating a test account on the host with a uid
> matching the guest uid). However this did not solve the problem. In fact I
> observe that regardless of the uid on the host it is always mapped to SID
> S-1-5-0 on the guest.
> 
> Which has been noted by other users as well. In fact there's a comment from
> the WinFsp responsible Bill Zissimopoulos (on
> https://groups.google.com/g/winfsp/c/5JhqnV5siiU) from February this year:
> 
> "When I [...] looked at the virtiofs source code I saw that this file system
> implements the native WinFsp API. This means that relevant security calls
> would be in the operations GetSecurityByName and GetSecurity:
> 
>     GetSecurityByName: https://github.com/virtio-win/kvm-guest-drivers-windows/blob/e2fc291866a7d2f147a8117dacdce7ac6375b6b8/viofs/svc/virtiofs.c#L839
>     GetSecurity: https://github.com/virtio-win/kvm-guest-drivers-windows/blob/e2fc291866a7d2f147a8117dacdce7ac6375b6b8/viofs/svc/virtiofs.c#L1619
> 
>  Both of these functions call the WinFsp API
> FspPosixMapPermissionsToSecurityDescriptor to map UNIX permissions (that
> they got from their internal API's) to Windows security descriptors. For
> example, GetSecurity calls (via GetFileInfoInternal) the internal
> VirtFsFuseRequest to perform a getattr. I bet that the returned
> VirtFs->LocalUid == VirtFs->LocalGid == 0, but do not ask me why.
> 
> In any case this seems unrelated to WinFsp. I note that FspPosixMapUidToSid
> returns the SID S-1-0-65534 when it fails to map (and not S-1-5-0)."
> 
> Can it be that Bill is correct and (at least for a Windows guest)
> VirtFsFuseRequest always returns uid == gid == 0? Which would then be mapped
> to S-1-5-0, requiring Administrator rights for file modifications and
> deletions?

IIUC, you are saying what uid/gid vrtiofs server is returning for a file. It
returns whatever it sees on the host. So for a file owned by uid/gid
1000/1000 on host, it should return it. That should be mapped to
SID using WinFsp API? I have no idea how does that work.

If you like you can debug virtiofsd easily, put few printf statements
and make sure correct uid/gid is being returned. May be next step is
to debug virtiofs driver in windows and make sure it receives correct
uid/gid. And if that works, then final step is making sure permissions
are being mapped properly.

Frankly, I have not done any work on windows side and have no idea what
components are there and how do they interact. Copying Gal Hammer, and
he might have thoughts on this.

Vivek

> 
> Michael
> 
> > Hi Michael,
> 
> > FUSE protocol sends the uid/gid of the client to the server and server
> > switches to that uid/gid before performing file operation. I am not
> > sure how the concept of uid/gid works with windows client but if you
> > are sharing a directory owned by a uid/gid on host, guest will have
> > to use same uid/gid to be able to use it (or become root inside).
> 
> > Vivek
> 

