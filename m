DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=/6jbIRjUAtVZGGk6gEYrACTLQuHei87M+7UfjHxjsLs=;
	b=nGUS9tRipgxyuo3hpvpRsY8ETE
	3hFpqgb614l0CQZNokZh+gDGqtw+VH8g/VPhtZpvLDlBV5QT7knBTPMJsKiLVsvx2He4oXpz9aWyR
	IgamL7pKWnzD89L0Z+8LQeTGWQNFw/w/aqpZCl0haVCss2uHNDMuujIViEAXMQhE7RFTlSEenmHKr
	aRC6DIB6pSEkJ9Lylpf/gocxrX/yz7orjg/mgpXDYv0e3m9vMx5KGeLRYN7a1b5B6/Ln5EVEpJUwA
	kpAg5uyqXnKch6qpHxmx1axAkHSNDiEzhQ1GuYr3w054LpDA1JLEN8g50j7jo9A+BFAY9+6xrJEAD
	gRvKeqO3uvgWsIg14kv3/5dzXIlz0IKK5hZ3vZhYj0ZIUCtf4j+8Kw2FNvPlT8NkxyesNkSn1slb+
	uhMyyzjgvvBnVgiepNPZ4jfipnThTzHUenB16p2mvxwLLjqtMbVMA57lyOrnbNyNvBdMzXMCIZcJ5
	1oKOImZocRc4jVN0LGMXkKvpxNpuVhgKJwiKN74E/rcp+tu8CLxPCsb0tO52sT7qR0CnvnV9/5vj3
	IsMNRoI1IZ/ycOw+CKs6d7zH5N1gspyDawemnIQBLiLaoo5kLGfxehtdx4EaA6t3XEHeQIXd0M3oi
	mvkXPErL245YI/9aSCKHNvrQbQY/KO7oIXND+xvfc=
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Tue, 29 Sep 2020 15:59:34 +0200
Message-ID: <6044656.UxkCsAYsKb@silver>
In-Reply-To: <20200929134942.GC220516@redhat.com>
References: <20200918213436.GA3520@redhat.com> <2302525.O3mciSdnpG@silver>
	<20200929134942.GC220516@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: Re: [Virtio-fs] virtiofs vs 9p performance(Re: tools/virtiofs:
	Multi threading seems to hurt performance)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "Venegas Munoz, Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, "cdupontd@redhat.com" <cdupontd@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, "Shinde,
	Archana M" <archana.m.shinde@intel.com>, Vivek Goyal <vgoyal@redhat.com>

On Dienstag, 29. September 2020 15:49:42 CEST Vivek Goyal wrote:
> > Depends on what's randomized. If read chunk size is randomized, then yes,
> > you would probably see less performance increase compared to a simple
> > 'cat foo.dat'.
> 
> We are using "fio" for testing and read chunk size is not being
> randomized. chunk size (block size) is fixed at 4K size for these tests.

Good to know, thanks!

> > If only the read position is randomized, but the read chunk size honors
> > iounit, a.k.a. stat's st_blksize (i.e. reading with the most efficient
> > block size advertised by 9P), then I would assume still seeing a
> > performance increase.
> 
> Yes, we are randomizing read position. But there is no notion of looking
> at st_blksize. Its fixed at 4K. (notice option --bs=4k in fio
> commandline).

Ah ok, then the results make sense.

With these block sizes you will indeed suffer a performance issue with 9p, due 
to several thread hops in Tread handling, which is due to be fixed.

Best regards,
Christian Schoenebeck


