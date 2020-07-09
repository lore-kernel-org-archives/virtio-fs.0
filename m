Date: Thu, 9 Jul 2020 15:44:14 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200709194414.GF150543@redhat.com>
References: <SN6PR11MB2943070029C7CA4BACE7438AEA810@SN6PR11MB2943.namprd11.prod.outlook.com>
	<20200617135229.GB26770@redhat.com>
	<SN6PR11MB2943CDD11BE8CB3F5E73794DEA9A0@SN6PR11MB2943.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SN6PR11MB2943CDD11BE8CB3F5E73794DEA9A0@SN6PR11MB2943.namprd11.prod.outlook.com>
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

I rebased virtiofs dax patches on top of 5.8-rc4. Give it a try.

https://gitlab.com/virtio-fs/linux/-/commits/vivek-july-09-2020

Thanks
Vivek

On Wed, Jun 17, 2020 at 01:58:54PM +0000, Boeuf, Sebastien wrote:
> Sounds good, thank you Vivek for the heads up 🙂
> 
> Sebastien
> ________________________________
> From: Vivek Goyal <vgoyal@redhat.com>
> Sent: Wednesday, June 17, 2020 3:52 PM
> To: Boeuf, Sebastien <sebastien.boeuf@intel.com>
> Cc: virtio-fs@redhat.com <virtio-fs@redhat.com>
> Subject: Re: Kernel patches on latest linux kernel
> 
> On Fri, Jun 12, 2020 at 09:00:50AM +0000, Boeuf, Sebastien wrote:
> > Hi folks,
> >
> > Just wondering when the kernel patch series will be rebased on top of latest kernel?
> 
> Hi Sebastien,
> 
> I will try to take care of this week or next week and rebase the patches
> on top of 5.8-rc1
> 
> Thanks
> Vivek
> 
> ---------------------------------------------------------------------
> Intel Corporation SAS (French simplified joint stock company)
> Registered headquarters: "Les Montalets"- 2, rue de Paris, 
> 92196 Meudon Cedex, France
> Registration Number:  302 456 199 R.C.S. NANTERRE
> Capital: 4,572,000 Euros
> 
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.

