DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=ALxyvIngDfZvVLBPon/VzH02LiJjVvS8J3vNx00anr4=;
	b=RyGJ9gRQW1SDGCNDf6Ji359rAI
	WeTGdW3xd3wrUML+TRM+9sgQZECsKG5666GDpaPFLiHB0aQPIk3pKDY+XT2SuGgGfYAG7XwDyyo0V
	IaaQz188lXIO2EMbpL5SUIc5NRwdKFdBQJdP8tjkSq5pm85e0XMZaj239vi2ZGcEd5qfbFeaM8Drh
	BGAyuja8V1inKlvXdZ97N2PblYlpdPFX9G1MqeHrs3sOotPCSsAkX+xIWP/+wxyb8cwwb2hhciuMm
	/Q2JmWabNlOlaiuDm7yEl+js2YYFt1Wiw+mxt/Fq5i6hH1m5NxgPdegbvGaO+EyZAPYJxU8qvrDd/
	FYG2pbNOtZjMUYpsW6g8b1WiFdgIdkJHJ5QwXabLehzGrCoEUHH0TsXEK5XK+46nGoAzGcx9Qmxuk
	sXNS9Sagdoo7aRNluGf8MGxue0HGnjGHoedpYhy18wgCRdybqFyVXLZiEczeNawi8Xk3oRrCJeGUj
	5xw3UzamSPJQG5Cad+Ox2zIfwO/8A6rCi5hLsmGZt4qiPhdnTGYwSSFVkYRygBnh+JTavhHWaBtFZ
	hvr2WcgNM2heSf0aQYAfukoSIcx/98DUw2z3UklXN0qR3/yXr2n5u2WMrh+PVMK+LI86OPxFwFe0j
	JxMwhaio3zQAlwx48DW85FyxRT/24I8dQo/KXueX8=
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Tue, 05 Oct 2021 13:10:56 +0200
Message-ID: <3198289.vhBqKWSW6W@silver>
In-Reply-To: <54ce3304-ee62-4e95-eb4c-7ea1a81f30a0@redhat.com>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<54ce3304-ee62-4e95-eb4c-7ea1a81f30a0@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: Re: [Virtio-fs] [PATCH v2 0/3] virtio: increase VIRTQUEUE_MAX_SIZE
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
Cc: Kevin Wolf <kwolf@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, David Hildenbrand <david@redhat.com>, Amit Shah <amit@kernel.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, virtio-fs@redhat.com, Eric Auger <eric.auger@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Gerd Hoffmann <kraxel@redhat.com>, =?ISO-8859-1?Q?Marc=2DAndr=E9?= Lureau <marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>

On Dienstag, 5. Oktober 2021 09:38:53 CEST David Hildenbrand wrote:
> On 04.10.21 21:38, Christian Schoenebeck wrote:
> > At the moment the maximum transfer size with virtio is limited to 4M
> > (1024 * PAGE_SIZE). This series raises this limit to its maximum
> > theoretical possible transfer size of 128M (32k pages) according to the
> > virtio specs:
> > 
> > https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-cs01.html#
> > x1-240006
> I'm missing the "why do we care". Can you comment on that?

Primary motivation is the possibility of improved performance, e.g. in case of 
9pfs, people can raise the maximum transfer size with the Linux 9p client's 
'msize' option on guest side (and only on guest side actually). If guest 
performs large chunk I/O, e.g. consider something "useful" like this one on 
guest side:

  time cat large_file_on_9pfs.dat > /dev/null

Then there is a noticable performance increase with higher transfer size 
values. That performance gain is continuous with rising transfer size values, 
but the performance increase obviously shrinks with rising transfer sizes as 
well, as with similar concepts in general like cache sizes, etc.

Then a secondary motivation is described in reason (2) of patch 2: if the 
transfer size is configurable on guest side (like it is the case with the 9pfs 
'msize' option), then there is the unpleasant side effect that the current 
virtio limit of 4M is invisible to guest; as this value of 4M is simply an 
arbitrarily limit set on QEMU side in the past (probably just implementation 
motivated on QEMU side at that point), i.e. it is not a limit specified by the 
virtio protocol, nor is this limit be made aware to guest via virtio protocol 
at all. The consequence with 9pfs would be if user tries to go higher than 4M, 
then the system would simply hang with this QEMU error:

  virtio: too many write descriptors in indirect table

Now whether this is an issue or not for individual virtio users, depends on 
whether the individual virtio user already had its own limitation <= 4M 
enforced on its side.

Best regards,
Christian Schoenebeck


