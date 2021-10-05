DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=oReEq7Yo56DFtHntIV6d5KmDT6OgjuS82n4nCjQNi8U=;
	b=oMlAqIAaW90Iv4PJ5eCPyC9Dvp
	w9Uly/n8xSkO5kWhjEilimFdvL9Uvss7JxkDpfdIneox3t9oaA5dWcetKUEBfYZ424fktxRIzAOmp
	DW/1aX5izX4gyViUA15NDwzKZ/E0eKYlM/5fwy9hxHbeH8nHzDIgFoVNO1KZUAqwcGAtx1d+I7/H0
	TLK4f3I5cUJUWHHlPiftBswh272KJujAwNIYN/JzPJUoa8VHijqpOZcrT98seurG2y/SnyPK8VE3Y
	anUSIuXafsmZil83WVeP1lzL3mRT5pLqG3FFAGeRkwqyJ9CTfnP/Ku43gx2IxYrsr83wIbNLiPnRn
	aj1yMaawGPbHtg01pfP6g1dqclLdLML9H/lEVHwSXILQs2mf/86KLn2xORE8c/qepzFp6vfaIO5VF
	k+ZcbXFIo51yJ3uRJL8OaP7D+NDw8QPLmIXD17OE4JM1m2JGsjXe7/m2OM2JXLNhTteskxzV+b0Zh
	PSGiTd/48oamd+grBEbNhzdxQLYFNnTAOekt7rWf1rYZ3rs3NvkEhA7P8NvMiFLThfjRhVjXaA5dj
	nNDV7soxy/BcNGsbwbhncZA289zIly9X5SBy66z1NhsAlWlnuCLfFx0PFHrUrQBO05yEuoH1HBh67
	JS4ua0mhbh/5lH5BXxJVBBukVtIwYsp6ogHf9PDAk=
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Tue, 05 Oct 2021 14:01:00 +0200
Message-ID: <3198295.vc1OghKV7D@silver>
In-Reply-To: <20211005072243-mutt-send-email-mst@kernel.org>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<2365616.UHP9OR3mgr@silver>
	<20211005072243-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: Re: [Virtio-fs] [PATCH v2 2/3] virtio: increase VIRTQUEUE_MAX_SIZE
	to 32k
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-block@nongnu.org, Amit Shah <amit@kernel.org>, Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, David Hildenbrand <david@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, virtio-fs@redhat.com, Eric Auger <eric.auger@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Gerd Hoffmann <kraxel@redhat.com>, =?ISO-8859-1?Q?Marc=2DAndr=E9?= Lureau <marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>

On Dienstag, 5. Oktober 2021 13:24:36 CEST Michael S. Tsirkin wrote:
> On Tue, Oct 05, 2021 at 01:17:59PM +0200, Christian Schoenebeck wrote:
> > On Dienstag, 5. Oktober 2021 09:16:07 CEST Michael S. Tsirkin wrote:
> > > On Mon, Oct 04, 2021 at 09:38:08PM +0200, Christian Schoenebeck wrote:
> > > > Raise the maximum possible virtio transfer size to 128M
> > > > (more precisely: 32k * PAGE_SIZE). See previous commit for a
> > > > more detailed explanation for the reasons of this change.
> > > > 
> > > > For not breaking any virtio user, all virtio users transition
> > > > to using the new macro VIRTQUEUE_LEGACY_MAX_SIZE instead of
> > > > VIRTQUEUE_MAX_SIZE, so they are all still using the old value
> > > > of 1k with this commit.
> > > > 
> > > > On the long-term, each virtio user should subsequently either
> > > > switch from VIRTQUEUE_LEGACY_MAX_SIZE to VIRTQUEUE_MAX_SIZE
> > > > after checking that they support the new value of 32k, or
> > > > otherwise they should replace the VIRTQUEUE_LEGACY_MAX_SIZE
> > > > macro by an appropriate value supported by them.
> > > > 
> > > > Signed-off-by: Christian Schoenebeck <qemu_oss@crudebyte.com>
> > > 
> > > I don't think we need this. Legacy isn't descriptive either.  Just leave
> > > VIRTQUEUE_MAX_SIZE alone, and come up with a new name for 32k.
> > 
> > Does this mean you disagree that on the long-term all virtio users should
> > transition either to the new upper limit of 32k max queue size or
> > introduce
> > their own limit at their end?
> 
> depends. if 9pfs is the only one unhappy, we can keep 4k as
> the default. it's sure a safe one.
> 
> > Independent of the name, and I would appreciate for suggestions for an
> > adequate macro name here, I still think this new limit should be placed in
> > the shared virtio.h file. Because this value is not something invented on
> > virtio user side. It rather reflects the theoretical upper limited
> > possible with the virtio protocol, which is and will be common for all
> > virtio users.
> We can add this to the linux uapi headers, sure.

Well, then I wait for few days, and if nobody else cares about this issue, 
then I just hard code 32k on 9pfs side exclusively in v3 for now and that's 
it.

Best regards,
Christian Schoenebeck


