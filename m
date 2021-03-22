DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com;
	h=from : content-type :
	content-transfer-encoding : mime-version : subject : message-id : date
	:
	to; s=20180706; bh=tUR2UuUAU8a/E51vFwFSb3CwaxOQRA9Kt/R62ysnxco=;
	b=pLRosZiCAh8lH+IhoIM7DWn+imQH4mfqVE0p/Au9bH2Vxst47+G2khbHc5u9Tg93Z4yt
	tqbQ/ZAhA2Da23m7xl015At491xER/MIJBKBTsGozepLYHwVKeOzocwdUEUWAhtZDQrA
	/iEWcsOYqxmKV0txUspFjp1aEwxNNX6naylaXy7AGrwEA6lipdxMUtC/Mpoz2EmzAnnO
	vgTelsyUqlet1P2HfzBYkicVaaj/mbDfooKWrpouIrRaKALYB7ihqqQNw+favTxlzMaY
	QctfpR3nv8Ch7Ar9KEoW+Liy3rQRXRgdHuQqr2b1RM2BVuFufyAbc/9wD2dE6GaViJwj
	IQ==
From: Eric Ernst <eric_ernst@apple.com>
MIME-version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Message-id: <2148A6EA-09CC-4DD2-8E03-8D51633D4137@apple.com>
Date: Sun, 21 Mar 2021 21:09:49 -0700
Content-type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] Large memory consumption by virtiofsd,
 suspecting fd's aren't being closed?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Hey ya’ll,

One challenge I’ve been looking at is how to setup an appropriate memory cgroup limit for workloads that are leveraging virtiofs (ie, running pods with Kata Containers). I noticed that memory usage of the daemon itself can grow considerably depending on the workload; though much more than I’d expect.

I’m running workload that simply runs a build on kernel sources with -j3. In doing this, the source of the linux kernel are shared via virtiofs (no DAX), so as the build goes on, there are a lot of files opened, closed, as well as created. The rss memory of virtiofsd grows into several hundreds of MBs.

When taking a look, I’m suspecting that virtiofsd is carrying out the opens, but never actually closing fds. In the guest, I’m seeing fd’s on the order of 10-40 for all the container processes as it runs, whereas I see the number of fds for virtiofsd continually increasing, reaching over 80,000 fds. I’m guessing this isn’t expected?

Can any ya’ll help shed some light, or where I can look?

Thanks,
Eric


