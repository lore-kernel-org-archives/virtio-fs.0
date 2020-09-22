Date: Tue, 22 Sep 2020 14:16:35 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200922181635.GE57620@redhat.com>
References: <bd4b7ab761dcb47f3b6ebf7fc065f5040a314056.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd4b7ab761dcb47f3b6ebf7fc065f5040a314056.camel@intel.com>
Subject: Re: [Virtio-fs] Branch with patches on top of Linux 5.9-rcX
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

On Tue, Sep 22, 2020 at 09:10:27AM +0000, Boeuf, Sebastien wrote:
> Hi,
> 
> I was wondering if you had a branch ready with the virtio-fs patches
> rebased on top 5.9-rcX?
> 

Hi Sebastien,

I am waiting for DAX patches to be merged in 5.10 and then you can
pull from upstream directly.

In the meantime, everything is in Miklos's tree and you should be able
to pull from there as well.

https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git/log/?h=for-next

Is there still a need for me to take patches from Miklos's tree and
push on virtiof-fs-dev?

Vivek


> Thanks,
> Sebastien
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

