Date: Tue, 14 Sep 2021 10:32:13 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YUCybaYK/0RLvY9J@redhat.com>
References: <79dcd300-a441-cdba-e523-324733f892ca@schaufler-ca.com>
	<YTEEPZJ3kxWkcM9x@redhat.com> <YTENEAv6dw9QoYcY@redhat.com>
	<3bca47d0-747d-dd49-a03f-e0fa98eaa2f7@schaufler-ca.com>
	<YTEur7h6fe4xBJRb@redhat.com>
	<1f33e6ef-e896-09ef-43b1-6c5fac40ba5f@schaufler-ca.com>
	<YTYr4MgWnOgf/SWY@work-vm>
	<496e92bf-bf9e-a56b-bd73-3c1d0994a064@schaufler-ca.com>
	<YUCa6pWpr5cjCNrU@redhat.com>
	<CAPL3RVHB=E_s1AW1sQMEgrLYJ8ADCdr=qaKsDrpYjVzW-Apq8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPL3RVHB=E_s1AW1sQMEgrLYJ8ADCdr=qaKsDrpYjVzW-Apq8w@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v3 0/1] Relax restrictions on user.* xattr
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Bruce Fields <bfields@redhat.com>
Cc: Giuseppe Scrivano <gscrivan@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, selinux@vger.kernel.org, stephen.smalley.work@gmail.com, Dave Chinner <david@fromorbit.com>, LKML <linux-kernel@vger.kernel.org>, virtio-fs@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Casey Schaufler <casey@schaufler-ca.com>, Christian Brauner <christian.brauner@ubuntu.com>, Casey Schaufler <casey.schaufler@intel.com>

On Tue, Sep 14, 2021 at 09:59:19AM -0400, Bruce Fields wrote:
> On Tue, Sep 14, 2021 at 8:52 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > Same is the requirement for regular containers and that's why
> > podman (and possibly other container managers), make top level
> > storage directory only readable and searchable by root, so that
> > unpriveleged entities on host can not access container root filesystem
> > data.
> 
> Note--if that directory is on NFS, making it readable and searchable
> by root is very weak protection, since it's often possible for an
> attacker to guess filehandles and access objects without the need for
> directory lookups.

open_by_handle_at() requires CAP_DAC_READ_SEARCH. And if you have
CAP_DAC_READ_SEARCH, you don't need to even guess file handles. You
should be able to read/search through all directories, IIUC.

So how does one make sure that shared directory on host is not
accessible to unprivileged entities. If making directory accessible
to root only is weaker security, what are the options for stronger
security.

Vivek

