Date: Thu, 13 May 2021 09:26:22 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YJzirr/g1DlZr4X8@work-vm>
References: <BY5PR11MB44018CADDC7A5C04F3D32BC4EA539@BY5PR11MB4401.namprd11.prod.outlook.com>
	<CAFQAk7jhNzMqh9VcsxUmsqxM25K=cR546hpNUY+5M50-UHSg-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFQAk7jhNzMqh9VcsxUmsqxM25K=cR546hpNUY+5M50-UHSg-A@mail.gmail.com>
Subject: Re: [Virtio-fs] host-user reconnection and crash recovery
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, Yongji Xie <xieyongji@bytedance.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, fam.zheng@bytedance.com

* Jiachen Zhang (zhangjiachen.jaycee@bytedance.com) wrote:
> Hi Stefan and Sebastien,
> 
> I think I should give some background context from my perspective.
> 
> For the virtiofsd crash reconnection (recovery) to QEMU, as said by
> Stefan, we discussed the possible implementation on the bi-weekly virtio-fs
> call. I had also sent an RFC patch to the virtio-fs mail-list (
> https://patchwork.kernel.org/project/qemu-devel/cover/20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com/),
> we also have some discussion on the further revision direction in that
> mail.
> 
> We also have some needs to support virtiofsd crash recovery when it is used
> with cloud-hypervisor (https://github.com/cloud-hypervisor/cloud-hypervisor).
> However, the virtiofsd crash reconnection RFC patch relies on
> QEMU's vhost-user socket reconnection feature and QEMU's vhost-user
> inflight I/O tracking feature, which are both not supported by
> cloud-hypervisor.
> 
> So I also issued an initial pull-request of cloud-hypervisor vhost-user
> socket reconnection (
> https://github.com/cloud-hypervisor/cloud-hypervisor/pull/2387), which is
> reviewed by Sebastien. Based on vhost-user socket reconnection, we also
> want to further develop vhost-user inflight I/O tracking feature for
> cloud-hypervisor, and finally to support virtiofsd crash reconnection.
> 
> I am sorry for the delayed patch-revision of the two patch sets. I hope I
> can free up some time in these two months to make some further progress.

I'm curious what your use case is for virtiofsd crash
recovery/reconnection - is there some reason you expect the daemon to
crash or need to be restarted more than the whole VM?

In the case of vhost-user networking with dpdk I can see the case where
there is a central networking switch process shared between many VMs; so
wanting to restart that without restarting all the VMs makes sense to
me; where each VM has it's own virtiofsd I don't understand the use as
much.

Dave

> All the best,
> Jiachen
> 
> On Tue, May 11, 2021 at 11:02 PM Boeuf, Sebastien <sebastien.boeuf@intel.com>
> wrote:
> 
> > Hi Stefan,
> >
> > Thanks for the explanation.
> >
> > So reconnection for vhost-user is not a well defined behavior,
> > and QEMU is doing its best to retry when possible, depending
> > on each device.
> >
> > The guest does not know about it, so it's never notified that
> > the device needs to be reset.
> >
> > But what about the vhost-user backend initialization? Does
> > QEMU go again through initializing memory table, vrings, etc...
> > since it can't assume anything from the backend?
> >
> > Thanks,
> > Sebastien
> >
> > ------------------------------
> > *From:* Stefan Hajnoczi
> > *Sent:* Tuesday, May 11, 2021 2:45 PM
> > *To:* Boeuf, Sebastien
> > *Cc:* virtio-fs@redhat.com; qemu-devel@nongnu.org
> > *Subject:* vhost-user reconnection and crash recovery
> >
> > Hi Sebastien,
> > On #virtio-fs IRC you asked:
> >
> >  I have a vhost-user question regarding disconnection/reconnection. How
> >  should this be handled? Let's say the vhost-user backend disconnects,
> >  and reconnects later on, does QEMU reset the virtio device by notifying
> >  the guest? Or does it simply reconnects to the backend without letting
> >  the guest know about what happened?
> >
> > The vhost-user protocol does not have a generic reconnection solution.
> > Reconnection is handled on a case-by-case basis because device-specific
> > and implementation-specific state is involved.
> >
> > The vhost-user-fs-pci device in QEMU has not been tested with
> > reconnection as far as I know.
> >
> > The ideal reconnection behavior is to resume the device from its
> > previous state without disrupting the guest. Device state must survive
> > reconnection in order for this to work. Neither QEMU virtiofsd nor
> > virtiofsd-rs implement this today.
> >
> > virtiofs has a lot of state, making it particularly difficult to support
> > either DEVICE_NEEDS_RESET or transparent vhost-user reconnection. We
> > have discussed virtiofs crash recovery on the bi-weekly virtiofs call
> > (https://etherpad.opendev.org/p/virtiofs-external-meeting). If you want
> > to work on this then joining the call would be a good starting point to
> > coordinate with others.
> >
> > One approach for transparent crash recovery is for virtiofsd to keep its
> > state in tmpfs (e.g. inode/fd mappings) and open fds shared with a
> > clone(2) process via CLONE_FILES. This way the virtiofsd process can
> > terminate but its state persists in memory thanks to its clone process.
> > The clone can then be used to launch the new virtiofsd process from the
> > old state. This would allow the device to resume transparently with QEMU
> > only reconnecting the vhost-user UNIX domain socket. This is an idea
> > that we discussed in the bi-weekly virtiofs call.
> >
> > You mentioned device reset. VIRTIO 1.1 has the Device Status Field
> > DEVICE_NEEDS_RESET flat that the device can use to tell the driver that
> > a reset is necessary. This feature is present in the specification but
> > not implemented in the Linux guest drivers. Again the reason is that
> > handling it requires driver-specific logic for restoring state after
> > reset...otherwise the device reset would be visible to userspace.
> >
> > Stefan
> >
> > ---------------------------------------------------------------------
> > Intel Corporation SAS (French simplified joint stock company)
> > Registered headquarters: "Les Montalets"- 2, rue de Paris,
> > 92196 Meudon Cedex, France
> > Registration Number:  302 456 199 R.C.S. NANTERRE
> > Capital: 4,572,000 Euros
> >
> > This e-mail and any attachments may contain confidential material for
> > the sole use of the intended recipient(s). Any review or distribution
> > by others is strictly prohibited. If you are not the intended
> > recipient, please contact the sender and delete all copies.
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://listman.redhat.com/mailman/listinfo/virtio-fs
> >

> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs

-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

