Date: Tue, 7 Sep 2021 17:40:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YTfcT1JUactPhwSA@redhat.com>
References: <20210902152228.665959-1-vgoyal@redhat.com>
	<CAHc6FU4foW+9ZwTRis3DXSJSMAvdb4jXcq7EFFArYgX7FQ1QYg@mail.gmail.com>
	<YTYoEDT+YOtCHXW0@work-vm>
	<CAJfpegvbkmdneMxMjYMuNM4+RmWT8S7gaTiDzaq+TCzb0UrQrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegvbkmdneMxMjYMuNM4+RmWT8S7gaTiDzaq+TCzb0UrQrw@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v3 0/1] Relax restrictions on user.* xattr
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Giuseppe Scrivano <gscrivan@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, SElinux list <selinux@vger.kernel.org>, Stephen Smalley <stephen.smalley.work@gmail.com>, Dave Chinner <david@fromorbit.com>, LKML <linux-kernel@vger.kernel.org>, virtio-fs-list <virtio-fs@redhat.com>, casey.schaufler@intel.com, LSM <linux-security-module@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Fields,
	Bruce" <bfields@redhat.com>, Christian Brauner <christian.brauner@ubuntu.com>, "Eric W. Biederman" <ebiederm@xmission.com>

On Mon, Sep 06, 2021 at 04:56:44PM +0200, Miklos Szeredi wrote:
> On Mon, 6 Sept 2021 at 16:39, Dr. David Alan Gilbert
> <dgilbert@redhat.com> wrote:
> 
> > IMHO the real problem here is that the user/trusted/system/security
> > 'namespaces' are arbitrary hacks rather than a proper namespacing
> > mechanism that allows you to create new (nested) namespaces and associate
> > permissions with each one.
> 
> Indeed.
> 
> This is what Eric Biederman suggested at some point for supporting
> trusted xattrs within a user namespace:
> 
> | For trusted xattrs I think it makes sense in principle.   The namespace
> | would probably become something like "trusted<ns-root-uid>.".
> 
> Theory sounds simple enough.  Anyone interested in looking at the details?

So this namespaced trusted.* xattr domain will basically avoid the need
to have CAP_SYS_ADMIN in init_user_ns, IIUC.  I guess this is better
than giving CAP_SYS_ADMIN in init_user_ns.

Vivek

