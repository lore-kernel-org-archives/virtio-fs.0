DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=lizzy; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=F6mcedIpg5w876yARFX2BeCE/zuKLgBW/YTc2xMOwYs=;
	b=h2bq8GujGL2lRk3oXTBBG8LRo8
	YxCYpUvZ4nmv7Bq1Vx88aab5lfs2CqRroM8CqZkZBUW/gsAYArsiWo0BZIIsDf5+AH2o5QuO+7RZ1
	/k7SMz0jYc8w83BOc2syySLFu2zCRQ/9+qvUzRghQwSaZiIq4Zb8IEyW7rJ+grsyMvaW+J9AgM6bv
	hA5UW6G+nNchQej3TCia3nnFTk7ldZ3V98OINeZRo9OpSaIPfvO7NO56EXRaMIvd/RypOLJmBWhHr
	sTOqVnJN+XI7ut2FKRW30mQbbau/2H8ne7kclMNWYLNgSoQ7iE0RcN7rY+dOUI1rtxC2Uf4sKfnsq
	yLpTKUPQ==
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Fri, 25 Sep 2020 17:47:21 +0200
Message-ID: <4615316.mGufCYyPMH@silver>
In-Reply-To: <20200925131356.GD132653@redhat.com>
References: <20200918213436.GA3520@redhat.com> <17216624.eqST2d0sUl@silver>
	<20200925131356.GD132653@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: Re: [Virtio-fs] virtiofs vs 9p performance
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "cdupontd@redhat.com" <cdupontd@redhat.com>, "Venegas Munoz,
	Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, Greg Kurz <groug@kaod.org>, virtio-fs-list <virtio-fs@redhat.com>, "Shinde,
	Archana M" <archana.m.shinde@intel.com>, Vivek Goyal <vgoyal@redhat.com>

On Freitag, 25. September 2020 15:13:56 CEST Vivek Goyal wrote:
> On Fri, Sep 25, 2020 at 10:06:41AM +0200, Christian Schoenebeck wrote:
> > On Freitag, 25. September 2020 00:10:23 CEST Vivek Goyal wrote:
> > > In my testing, with cache=none, virtiofs performed better than 9p in
> > > all the fio jobs I was running. For the case of cache=auto  for virtiofs
> > > (with xattr enabled), 9p performed better in certain write workloads. I
> > > have identified root cause of that problem and working on
> > > HANDLE_KILLPRIV_V2 patches to improve WRITE performance of virtiofs
> > > with cache=auto and xattr enabled.
> > 
> > Please note, when it comes to performance aspects, you should set a
> > reasonable high value for 'msize' on 9p client side:
> > https://wiki.qemu.org/Documentation/9psetup#msize
> 
> Interesting. I will try that. What does "msize" do?

Simple: it's the "maximum message size" ever to be used for communication 
between host and guest, in both directions that is.

So if that 'msize' value is too small, a potential large 9p message would be 
split into several smaller 9p messages, and each message adds latency which is 
the main problem.

Keep in mind: The default value with Linux clients for msize is still only 
8kB!

Think of doing 'dd bs=8192 if=/src.dat of=/dst.dat count=...' as analogy, 
which probably makes its impact on performance clear.

However the negative impact of a small 'msize' value is not just limited to 
raw file I/O like that; calling readdir() for instance on a guest directory 
with several hundred files or more, will likewise slow down in the same way 
tremendously as both sides have to transmit a large amount of 9p messages back 
and forth instead of just 2 messages (Treaddir and Rreaddir).

> > I'm also working on performance optimizations for 9p BTW. There is plenty
> > of headroom to put it mildly. For QEMU 5.2 I started by addressing
> > readdir requests:
> > https://wiki.qemu.org/ChangeLog/5.2#9pfs
> 
> Nice. I guess this performance comparison between 9p and virtiofs is good.
> Both the projects can try to identify weak points and improve performance.

Yes, that's indeed handy being able to make comparisons.

Best regards,
Christian Schoenebeck


