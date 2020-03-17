Date: Tue, 17 Mar 2020 10:41:51 +0100
From: Igor Mammedov <imammedo@redhat.com>
Message-ID: <20200317104151.414e2a0b@redhat.com>
In-Reply-To: <OFACFEEE57.45B9F1BC-ON0025852E.0026B45E-8525852E.0026EB59@notes.na.collabserv.com>
References: <OFACFEEE57.45B9F1BC-ON0025852E.0026B45E-8525852E.0026EB59@notes.na.collabserv.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] virtio-fs on zLinux (s390x)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Gong Su <gongsu@us.ibm.com>
Cc: virtio-fs@redhat.com, Cornelia Huck <cohuck@redhat.com>

On Tue, 17 Mar 2020 02:05:06 -0500
"Gong Su" <gongsu@us.ibm.com> wrote:

> 
> 
> Hi Igor, just wondering if there is any updates on getting the patches that
> will allow shared memory without -numa (not supported on s390 yet)? Thanks.

it's already upstream.

there is a new upstream option -machine memory-backend=...
that allows to set custom backend for main RAM

> __________________
> 
> Hi Igor, that would be great. Thanks.
> 
> 
> 
> From:	Igor Mammedov <imammedo@redhat.com>
> To:	"Gong Su" <gongsu@us.ibm.com>
> Cc:	"Dr. David Alan Gilbert" <dgilbert@redhat.com>, Cornelia Huck
>             <cohuck@redhat.com>, virtio-fs@redhat.com
> Date:	12/13/2019 08:17 AM
> Subject:	[EXTERNAL] Re: [Virtio-fs] virtio-fs on zLinux (s390x)
> 
> 
> 
> On Thu, 12 Dec 2019 14:10:32 -0500
> "Gong Su" <gongsu@us.ibm.com> wrote:
> 
> >
> > Thanks Dave. That was quick!
> >
> > Igor, any idea when this will happen? :-)
> If you need early sneak peek, I can post common + s390 patches.
> 
> 
> > From:		 "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > To:		 Gong Su <gongsu@us.ibm.com>
> > Cc:		 virtio-fs@redhat.com, Cornelia Huck <cohuck@redhat.com>
> > Date:		 12/12/2019 01:59 PM
> > Subject:		 [EXTERNAL] Re: [Virtio-fs] virtio-fs on zLinux (s390x)
> >
> >
> >
> > * Gong Su (gongsu@us.ibm.com) wrote:
> > >
> > >
> > > Hi Stefan, I'm resending my questions to the list per your request.
> > >
> > > Basically, I'm trying to see if I can get virtio-fs to work on zLinux.
> > > Following the instructions on
> >
> https://urldefense.proofpoint.com/v2/url?u=https-3A__virtio-2Dfs.gitlab.io_howto-2Dqemu.html&d=DwIFAg&c=jf_iaSHvJObTbx-siA1ZOg&r=tf-1fDxgEPUcSzS0GcREznaRLLY6eGivTqJEnr2bEmQ&m=bKfrjedGnP-cXu2BPH6ynhTbdi5nm0VW1nx6Qb5Q_7M&s=pkvbWd3P-tWRpKPww5iwoPHLE_HnkenEEJhywABpRuc&e=
> 
> >   I
> > > was able to compile all the pieces but when I tried to run qemu I
> > realized
> > > that it needs -numa option which isn't supported on s390x yet.
> > >
> > > I have talked to Christian Borntraeger (whom I worked with on other
> > > projects before) and he indicated that he had a plan to add -numa
> support
> > > for s390x but currently is busy on other things.
> > >
> > > So I'm trying to see if there are other ways for me to go forward
> without
> > > having to wait for Christian. I see two options:
> > >
> > > 1. Merge virtiofsd into qemu itself. In the "Interchangeability"
> section
> > of
> > > the virtio-fs design page (
> >
> https://urldefense.proofpoint.com/v2/url?u=https-3A__virtio-2Dfs.gitlab.io_design.html&d=DwIFAg&c=jf_iaSHvJObTbx-siA1ZOg&r=tf-1fDxgEPUcSzS0GcREznaRLLY6eGivTqJEnr2bEmQ&m=bKfrjedGnP-cXu2BPH6ynhTbdi5nm0VW1nx6Qb5Q_7M&s=2VrG3dsgZcdW8uO6ZBiGtRgNp4X1z3d8TMXnUdHhfCc&e=
> 
> >  ), it
> > > mentioned that "It is also possible to forego vhost-user and emulate
> the
> > > virtio-fs device directly inside the hypervisor, although this may
> result
> > > in poor isolation and security." Since each guest typically gets its
> own
> > > qemu process, maybe this is acceptable for some use cases. In exchange,
> > you
> > > get the benefit of not having to carve out a chunk of memory
> > from /dev/shm
> > > (and maybe simpler communication between virtiofsd and qemu).
> > > 2. Use something other than -numa to share memory between virtiofsd and
> > > qemu that's supported on zLinux. I'm not entirely familiar with qemu so
> I
> > > have no idea whether this is possible or not.
> >
> > Hi,
> >   My understanding is that Igor Mammedov (imammedo@redhat.com) has plans
> > to allow 'shared' to be set on main memory, so we wouldn't need the numa
> > code.
> >
> > Dave
> >
> > > Thanks.
> >
> > > _______________________________________________
> > > Virtio-fs mailing list
> > > Virtio-fs@redhat.com
> > >
> >
> https://urldefense.proofpoint.com/v2/url?u=https-3A__www.redhat.com_mailman_listinfo_virtio-2Dfs&d=DwIFAg&c=jf_iaSHvJObTbx-siA1ZOg&r=tf-1fDxgEPUcSzS0GcREznaRLLY6eGivTqJEnr2bEmQ&m=bKfrjedGnP-cXu2BPH6ynhTbdi5nm0VW1nx6Qb5Q_7M&s=O41fLQGJCOR0-Aj2Y4nziy3aTYTOCzaH8Lahe7xhBK8&e=
> 
> >
> >
> > --
> > Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> >
> >
> >
> >
> 
> 
> 

