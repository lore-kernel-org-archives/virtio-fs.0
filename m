DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=lizzy; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=c67lafeT8pvBCjlA1iVegcBQYEjZ3KBj1IoX8n6PGHQ=;
	b=OGQ6DF3KX407eA+3tmLxeStyc7
	Qf4AixR2K1EmoOBPleA4hw3K9xChj9Vrx8KnlYYaJhfngCTHLJTL/H4obn9NboPqyDaTodsJDUeAj
	LlIgpEGXFz3hA9RPLKS5mm2ypvWfNBcIgzgCQvqDIeE+uA4toxjaYo+DnbrSAzr++SfHe2G5fvzSH
	g/fT7G2AOzZ/lH6D1+vcRzqS/QI/2GNJuQilPZJHtEoA8neepMPZN1qmHWPSuZDDPuf7UzYYYLzWa
	WcjOck5aUUCdu2Du6JL5BIcpG/0XnP6aUsolrhwdza8CZMR17RV110Ylve2znGlZCrxuoLr8l9FYK
	mwyVSL/g==
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Fri, 25 Sep 2020 18:05:17 +0200
Message-ID: <7085634.CctCyd8GvG@silver>
In-Reply-To: <20200925130538.GK2873@work-vm>
References: <20200918213436.GA3520@redhat.com> <4973513.bp6ERB8pJA@silver>
	<20200925130538.GK2873@work-vm>
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

On Freitag, 25. September 2020 15:05:38 CEST Dr. David Alan Gilbert wrote:
> > > 9p ( mount -t 9p -o trans=virtio kernel /mnt
> > > -oversion=9p2000.L,cache=mmap,msize=1048576 ) test: (g=0): rw=randrw,
> > 
> > Bottleneck ------------------------------^
> > 
> > By increasing 'msize' you would encounter better 9P I/O results.
> 
> OK, I thought that was bigger than the default;  what number should I
> use?

It depends on the underlying storage hardware. In other words: you have to try 
increasing the 'msize' value to a point where you no longer notice a negative 
performance impact (or almost). Which is fortunately quite easy to test on 
guest like:

	dd if=/dev/zero of=test.dat bs=1G count=12
	time cat test.dat > /dev/null

I would start with an absolute minimum msize of 10MB. I would recommend 
something around 100MB maybe for a mechanical hard drive. With a PCIe flash 
you probably would rather pick several hundred MB or even more.

That unpleasant 'msize' issue is a limitation of the 9p protocol: client 
(guest) must suggest the value of msize on connection to server (host). Server 
can only lower, but not raise it. And the client in turn obviously cannot see 
host's storage device(s), so client is unable to pick a good value by itself. 
So it's a suboptimal handshake issue right now.

Many users don't even know this 'msize' parameter exists and hence run with 
the Linux kernel's default value of just 8kB. For QEMU 5.2 I addressed this by 
logging a performance warning on host side for making users at least aware 
about this issue. The long-term plan is to pass a good msize value from host 
to guest via virtio (like it's already done for the available export tags) and 
the Linux kernel would default to that instead.

Best regards,
Christian Schoenebeck


