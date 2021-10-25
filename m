Date: Mon, 25 Oct 2021 09:16:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YXauFapuRuxXRR2k@redhat.com>
References: <5e79ba8579b33e60e9670f2fd99b1c1b@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e79ba8579b33e60e9670f2fd99b1c1b@posteo.de>
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
Cc: virtio-fs@redhat.com

On Sun, Oct 24, 2021 at 06:24:33AM +0000, birnenkram@posteo.de wrote:
> Hello list,
> 
> thanks for a great project which will simplify my workflow a lot once I get
> everything working.
> 
> I am trying to share a folder from an Ubuntu 20.04.3 host with a Windows 10
> build 19042 (20H2) guest, using QEMU 5.2 / libvirt 7.0.0 on the host and
> virtio-win 0.1.208 (driver 100.85.104.20800 and associated virtiofs service)
> on the guest. I got the Windows drivers from
> https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md
> (stable virtio-win ISO).
> 
> So far I am able to read files in this host folder without problems from the
> guest. However I can only create/write/delete files on the host if
> 
>     I use a shell (Windows CMD or Cygwin bash) with *Administrator* rights
> on the guest
> OR
>     I change the folder permissions on the host, giving write permissions to
> "other". Neither of these options is acceptable as a permanent solution.
> 
> I already toyed with various settings for "user" in /etc/libvirt/qemu.conf,
> including root and the user owning the shared folder (myself), without
> success. I struggle to understand what ultimately determines the write
> permissions on the host folder.

Hi Michael,

FUSE protocol sends the uid/gid of the client to the server and server
switches to that uid/gid before performing file operation. I am not
sure how the concept of uid/gid works with windows client but if you
are sharing a directory owned by a uid/gid on host, guest will have
to use same uid/gid to be able to use it (or become root inside).

Vivek

> I had assumed this to be related to the UID
> of one of the hypervisor processes, so I do not see why running as
> Administrator or not on the guest should make a difference. Also, virtiofsd
> seems to be running as root anyway, so should have the necessary
> permissions. There's no SELinux on my system.
> 
> My Windows and Linux user names are different. I don't know if that matters,
> and whether the software attempts to map the two (as Cygwin does).
> 
> Do you have any ideas what the problem could be? I have seen various users
> reporting issues with write permissions from Windows guests in the recent
> past, but no solution which would solve the issue for me.
> 
> Best regards, Michael
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
> 

