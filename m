Date: Fri, 10 Jul 2020 16:49:52 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200710204952.GC207113@redhat.com>
References: <SN6PR11MB2943070029C7CA4BACE7438AEA810@SN6PR11MB2943.namprd11.prod.outlook.com>
	<20200617135229.GB26770@redhat.com>
	<SN6PR11MB2943CDD11BE8CB3F5E73794DEA9A0@SN6PR11MB2943.namprd11.prod.outlook.com>
	<20200709194414.GF150543@redhat.com>
	<SN6PR11MB2943CD47285B0F02BC69E7CDEA650@SN6PR11MB2943.namprd11.prod.outlook.com>
	<DM6PR11MB2939E3D1A92076D657E54DE2EA650@DM6PR11MB2939.namprd11.prod.outlook.com>
	<20200710203851.GB207113@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200710203851.GB207113@redhat.com>
Subject: Re: [Virtio-fs] Kernel patches on latest linux kernel
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

Hi Sebastien,

I pushed new patches with the fix here.

https://gitlab.com/virtio-fs/linux/-/commits/vivek-july-10-2020

Give it a try.

Thanks
Vivek

On Fri, Jul 10, 2020 at 04:38:51PM -0400, Vivek Goyal wrote:
> Hi Sebastien,
> 
> I can't seem to remove the device. I get error saying pci bus does not
> support hot removal. But I tried "rmmod virtiofs" and that ran into
> similar issue. I think following patch should fix it. I will merge
> it one of the existing patches.
> 
> Thanks
> Vivek
> 
> 
> ---
>  fs/fuse/virtio_fs.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> Index: redhat-linux/fs/fuse/virtio_fs.c
> ===================================================================
> --- redhat-linux.orig/fs/fuse/virtio_fs.c	2020-07-10 20:25:25.679624830 +0000
> +++ redhat-linux/fs/fuse/virtio_fs.c	2020-07-10 20:28:02.169624830 +0000
> @@ -794,10 +794,10 @@ static const struct dax_operations virti
>  
>  static void virtio_fs_cleanup_dax(void *data)
>  {
> -	struct virtio_fs *fs = data;
> +	struct dax_device *dax_dev = data;
>  
> -	kill_dax(fs->dax_dev);
> -	put_dax(fs->dax_dev);
> +	kill_dax(dax_dev);
> +	put_dax(dax_dev);
>  }
>  
>  static int virtio_fs_setup_dax(struct virtio_device *vdev, struct virtio_fs *fs)
> @@ -852,7 +852,8 @@ static int virtio_fs_setup_dax(struct vi
>  	if (!fs->dax_dev)
>  		return -ENOMEM;
>  
> -	return devm_add_action_or_reset(&vdev->dev, virtio_fs_cleanup_dax, fs);
> +	return devm_add_action_or_reset(&vdev->dev, virtio_fs_cleanup_dax,
> +					fs->dax_dev);
>  }
>  
>  static int virtio_fs_probe(struct virtio_device *vdev)
> 
> 
> 
> 
> On Fri, Jul 10, 2020 at 09:51:23AM +0000, Boeuf, Sebastien wrote:
> > Huuh it seems I'm running into some issue wrt PCI hotplug.
> > If I remove my virtio-fs-pci device from my VM, I get the
> > following error from the guest kernel:
> > 
> > 
> > [  135.347517] general protection fault, probably for non-canonical address 0xa37366424f344963: 0000 [#1] SMP PTI
> > [  135.353330] CPU: 0 PID: 21 Comm: kworker/u2:2 Not tainted 5.8.0-rc4+ #317
> > [  135.357176] Hardware name: Cloud Hypervisor cloud-hypervisor, BIOS 0
> > [  135.360724] Workqueue: kacpi_hotplug acpi_hotplug_work_fn
> > [  135.363578] RIP: 0010:kill_dax+0xd/0x70
> > [  135.365642] Code: d0 02 00 00 04 c3 0f 1f 80 00 00 00 00 48 8b 87 d0 02 00 00 83 e0 01 c3 0f 1f 44 00 00 48 85 ff 74 60 55 48 89 e5 53 48 89 fb <3e> 80 a7 d0 02 00 00 fe 48 c7 c7 80 b2 07 ae e8 df 69 bd ff 48 c7
> > [  135.375052] RSP: 0018:ffffb464000b7b10 EFLAGS: 00010286
> > [  135.377791] RAX: ffffffffad3cdcf0 RBX: a37366424f344963 RCX: 0000000000000282
> > [  135.380378] RDX: ffff8e6c7976ec40 RSI: ffff8e6c7976ea98 RDI: a37366424f344963
> > [  135.382880] RBP: ffffb464000b7b18 R08: ffffb464000b7b78 R09: ffffb464000b7b78
> > [  135.384876] R10: ffff8e6c7c1e9e00 R11: 0000000000000001 R12: ffffb464000b7b78
> > [  135.386864] R13: ffff8e6c7976ea80 R14: ffff8e6c7976ea80 R15: ffff8e6c79744ab0
> > [  135.388623] FS:  0000000000000000(0000) GS:ffff8e6c7ec00000(0000) knlGS:0000000000000000
> > [  135.390417] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  135.391741] CR2: 00007fcf64d08db0 CR3: 000000003c112001 CR4: 00000000003606b0
> > [  135.393248] Call Trace:
> > [  135.393808]  virtio_fs_cleanup_dax+0x11/0x20
> > [  135.394666]  devm_action_release+0x10/0x20
> > [  135.395468]  release_nodes+0x22c/0x270
> > [  135.396216]  devres_release_all+0x3a/0x50
> > [  135.397016]  device_release_driver_internal+0xfb/0x1c0
> > [  135.397974]  device_release_driver+0xd/0x10
> > [  135.398681]  bus_remove_device+0xdc/0x150
> > [  135.399369]  device_del+0x16f/0x3f0
> > [  135.399981]  device_unregister+0x16/0x60
> > [  135.400662]  unregister_virtio_device+0x13/0x30
> > [  135.401446]  virtio_pci_remove+0x28/0x60
> > [  135.402119]  pci_device_remove+0x39/0xa0
> > [  135.402778]  device_release_driver_internal+0xeb/0x1c0
> > [  135.403535]  device_release_driver+0xd/0x10
> > [  135.404182]  pci_stop_bus_device+0x6b/0x90
> > [  135.404803]  pci_stop_and_remove_bus_device+0xe/0x20
> > [  135.405573]  disable_slot+0x4a/0x90
> > [  135.406123]  acpiphp_disable_and_eject_slot+0x15/0x80
> > [  135.406877]  acpiphp_hotplug_notify+0x184/0x280
> > [  135.407581]  ? free_bridge+0x130/0x130
> > [  135.408165]  acpi_device_hotplug+0xdd/0x390
> > [  135.408734]  acpi_hotplug_work_fn+0x1d/0x30
> > [  135.409313]  process_one_work+0x192/0x2e0
> > [  135.409856]  worker_thread+0x4b/0x3b0
> > [  135.410359]  kthread+0x10a/0x140
> > [  135.410823]  ? process_one_work+0x2e0/0x2e0
> > [  135.411390]  ? __kthread_parkme+0x60/0x60
> > [  135.411962]  ret_from_fork+0x22/0x30
> > [  135.412501] ---[ end trace bbfed4f67497ceb8 ]---
> > 
> > Any chance you already ran into this problem?
> > 
> > Thanks,
> > Sebastien
> > ________________________________
> > From: virtio-fs-bounces@redhat.com <virtio-fs-bounces@redhat.com> on behalf of Boeuf, Sebastien <sebastien.boeuf@intel.com>
> > Sent: Friday, July 10, 2020 8:47 AM
> > To: Vivek Goyal <vgoyal@redhat.com>
> > Cc: virtio-fs@redhat.com <virtio-fs@redhat.com>
> > Subject: Re: [Virtio-fs] Kernel patches on latest linux kernel
> > 
> > Oh cool! Thanks Vivek, I'll keep you posted if I run into any issue.
> > 
> > Sebastien
> > ________________________________
> > From: Vivek Goyal <vgoyal@redhat.com>
> > Sent: Thursday, July 9, 2020 9:44 PM
> > To: Boeuf, Sebastien <sebastien.boeuf@intel.com>
> > Cc: virtio-fs@redhat.com <virtio-fs@redhat.com>
> > Subject: Re: Kernel patches on latest linux kernel
> > 
> > Hi Sebastien,
> > 
> > I rebased virtiofs dax patches on top of 5.8-rc4. Give it a try.
> > 
> > https://gitlab.com/virtio-fs/linux/-/commits/vivek-july-09-2020
> > 
> > Thanks
> > Vivek
> > 
> > On Wed, Jun 17, 2020 at 01:58:54PM +0000, Boeuf, Sebastien wrote:
> > > Sounds good, thank you Vivek for the heads up 🙂
> > >
> > > Sebastien
> > > ________________________________
> > > From: Vivek Goyal <vgoyal@redhat.com>
> > > Sent: Wednesday, June 17, 2020 3:52 PM
> > > To: Boeuf, Sebastien <sebastien.boeuf@intel.com>
> > > Cc: virtio-fs@redhat.com <virtio-fs@redhat.com>
> > > Subject: Re: Kernel patches on latest linux kernel
> > >
> > > On Fri, Jun 12, 2020 at 09:00:50AM +0000, Boeuf, Sebastien wrote:
> > > > Hi folks,
> > > >
> > > > Just wondering when the kernel patch series will be rebased on top of latest kernel?
> > >
> > > Hi Sebastien,
> > >
> > > I will try to take care of this week or next week and rebase the patches
> > > on top of 5.8-rc1
> > >
> > > Thanks
> > > Vivek
> > >
> > > ---------------------------------------------------------------------
> > > Intel Corporation SAS (French simplified joint stock company)
> > > Registered headquarters: "Les Montalets"- 2, rue de Paris,
> > > 92196 Meudon Cedex, France
> > > Registration Number:  302 456 199 R.C.S. NANTERRE
> > > Capital: 4,572,000 Euros
> > >
> > > This e-mail and any attachments may contain confidential material for
> > > the sole use of the intended recipient(s). Any review or distribution
> > > by others is strictly prohibited. If you are not the intended
> > > recipient, please contact the sender and delete all copies.
> > 
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

