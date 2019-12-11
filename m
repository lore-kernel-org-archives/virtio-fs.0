From: "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Date: Wed, 11 Dec 2019 12:41:18 +0000
Message-ID: <3aabf82e359bb24dcfb97b31d9652b36cf70abcc.camel@intel.com>
References: <20191211121630.GD3875@work-vm>
In-Reply-To: <20191211121630.GD3875@work-vm>
Content-Language: en-US
Content-ID: <DD7DD97CEA2BC74D96D68C2AB213615F@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] Changes in -dev branch
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "dgilbert@redhat.com" <dgilbert@redhat.com>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>

Hi Dave,

I've just checked the codebase and I can see it includes the libvhost-
user fixes "libvhost-user: fix SLAVE_SEND_FD handling" and "libvhost-
user: introduce and use vu_has_protocol_feature()", that's great!

Unfortunately, through the virtio-fs development (based on previous
libvhost-user code), a new bug has been introduced here: 
https://gitlab.com/virtio-fs/qemu/blob/virtio-fs-dev/contrib/libvhost-user/libvhost-user.c#L2558

Instead, it needs to follow the new code format (which fixes the bug)
like here: 
https://gitlab.com/virtio-fs/qemu/blob/virtio-fs-dev/contrib/libvhost-user/libvhost-user.c#L1136

Do you think that's something we can quickly fix on your branch?

I can push a patch if you need me to :)

Thanks,
Sebastien

On Wed, 2019-12-11 at 12:16 +0000, Dr. David Alan Gilbert wrote:
> Hi,
>   I've just pushed a new version of the virtio-fs-dev branch in
> https://gitlab.com/virtio-fs/qemu
> 
> some things to note:
> 
>   a) It's now rebased on upstream qemu 4.2-rc5
>   b) The virtiofsd is now in tools/virtiofsd rather than contrib
>      (after a long discussion on qemu-devel about where people
>       want it)
>   c) I've reformatted all the files to match qemu's coding style
>      guidelines; mostly.  This is a mostly automatic process
>      with some hand tweaking.  There's the possibility some stuff
>      is screwed up so I need to check on it.
>   d) It now uses libcap-ng rather libcap; that's the way qemu is
>      moving, allthough the change is a bit hairy.
>   e) If you're missing either libseccomp or libcapng during build
>      it will omit virtiofsd rather than failing the build.
> 
> Dave
> 
> 
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
> 
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

