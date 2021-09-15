Date: Wed, 15 Sep 2021 11:33:27 -0500
From: "Dr. Greg" <greg@enjellic.com>
Message-ID: <20210915163327.GA2324@wind.enjellic.com>
References: <YTEEPZJ3kxWkcM9x@redhat.com> <YTENEAv6dw9QoYcY@redhat.com>
	<3bca47d0-747d-dd49-a03f-e0fa98eaa2f7@schaufler-ca.com>
	<YTEur7h6fe4xBJRb@redhat.com>
	<1f33e6ef-e896-09ef-43b1-6c5fac40ba5f@schaufler-ca.com>
	<YTYr4MgWnOgf/SWY@work-vm>
	<496e92bf-bf9e-a56b-bd73-3c1d0994a064@schaufler-ca.com>
	<YUCa6pWpr5cjCNrU@redhat.com>
	<CAPL3RVHB=E_s1AW1sQMEgrLYJ8ADCdr=qaKsDrpYjVzW-Apq8w@mail.gmail.com>
	<YUCybaYK/0RLvY9J@redhat.com>
Mime-Version: 1.0
In-Reply-To: <YUCybaYK/0RLvY9J@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH v3 0/1] Relax restrictions on user.* xattr
Reply-To: "Dr. Greg" <greg@enjellic.com>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Giuseppe Scrivano <gscrivan@redhat.com>, Bruce Fields <bfields@redhat.com>, Andreas Gruenbacher <agruenba@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, selinux@vger.kernel.org, stephen.smalley.work@gmail.com, Dave Chinner <david@fromorbit.com>, LKML <linux-kernel@vger.kernel.org>, virtio-fs@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LSM <linux-security-module@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Casey Schaufler <casey@schaufler-ca.com>, Theodore Ts'o <tytso@mit.edu>, Christian Brauner <christian.brauner@ubuntu.com>, Casey Schaufler <casey.schaufler@intel.com>

On Tue, Sep 14, 2021 at 10:32:13AM -0400, Vivek Goyal wrote:

Good morning, I hope the day is going well for everyone.

> On Tue, Sep 14, 2021 at 09:59:19AM -0400, Bruce Fields wrote:
> > On Tue, Sep 14, 2021 at 8:52 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > Same is the requirement for regular containers and that's why
> > > podman (and possibly other container managers), make top level
> > > storage directory only readable and searchable by root, so that
> > > unpriveleged entities on host can not access container root filesystem
> > > data.
> > 
> > Note--if that directory is on NFS, making it readable and searchable
> > by root is very weak protection, since it's often possible for an
> > attacker to guess filehandles and access objects without the need for
> > directory lookups.

> open_by_handle_at() requires CAP_DAC_READ_SEARCH. And if you have
> CAP_DAC_READ_SEARCH, you don't need to even guess file handles. You
> should be able to read/search through all directories, IIUC.
>
> So how does one make sure that shared directory on host is not
> accessible to unprivileged entities. If making directory accessible
> to root only is weaker security, what are the options for stronger
> security.

I've been watching this thread, with some interest, given what we have
been working on with respect to providing a new security framework
that merges IMA and LSM and external security co-processor technology.

Some observations based on those experiences and this thread.

Casey is an expert on MAC and capability based security systems,
unfortunately for our industry, particularly bog standard system
administrators, a rarefied set of skills.  It may be helpful to
consider his concerns and position on the issues involved in the
framework of the number of systems that have, and blog posts that
recommend, setting 'selinux=0' on the kernel command-line.

I believe the best summary of his position on this issue, is the
notion that placing security labels, even in transitive form in user
accessible attributes, subordinates the security of the guest system,
regardless of the MAC policy it implements, to the DAC based policy on
the host system.

Given that, there are no legitimate security guarantees that are
inferrable based on the guest MAC policy.

A legitimate pundit, could and probably should question, in the face
of container filesystems and virtual machine images, whether any type
of inferrable security guarantees are possible, but that is a question
and argument for another day.

I didn't see any mention of EVM brought up in these discussions, which
may provide some options to improve the security integrity state of
the guest.

The 800 pound gorilla in the corner in all of this, is that inferrable
security guarantees in guests require a certifiable chain of trust
from the creator of the object to the kernel context that is making
the security gating decisions on the object.  A hard to implement and
prove concept in bare metal trusted systems, let alone the myriad of
edge cases lurking in namespaced and virtual environments.

Which, in a nod to the other corner of the ring, may simply mean, with
our current state of deployable technology, you pay your money and
take your chances in these virtual environments.  Which would in turn
support the notion of a minimum security, ie. DAC, based effort.

> Vivek

Have a good remainder of the week.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker      Autonomously self-defensive
Enjellic Systems Development, LLC     IOT platforms and edge devices.
4206 N. 19th Ave.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: dg@enjellic.com
------------------------------------------------------------------------------
"This place is so screwed up.  It's just like the Titanic, only
 we don't even have a band playing.
                                -- Terrance George Wieland
                                   Resurrection.

