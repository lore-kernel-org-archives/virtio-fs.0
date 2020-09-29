MIME-Version: 1.0
References: <20200918213436.GA3520@redhat.com> <20200921153243.GK3221@work-vm>
	<20200922102531.GA2837@work-vm> <20200922174733.GD57620@redhat.com>
	<46D726A6-72F3-40FE-9382-A189513F783D@intel.com>
	<20200924221023.GB132653@redhat.com>
	<20200925124139.GJ2873@work-vm> <20200929131753.GB220516@redhat.com>
In-Reply-To: <20200929131753.GB220516@redhat.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Tue, 29 Sep 2020 15:49:04 +0200
Message-ID: <CAOssrKcVNs=uiU2U1-ScowogFan8W=iw7kyTCnaz-vL8r9gLmw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "Venegas Munoz,
	Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, "cdupontd@redhat.com" <cdupontd@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, "Shinde,
	Archana M" <archana.m.shinde@intel.com>

On Tue, Sep 29, 2020 at 3:18 PM Vivek Goyal <vgoyal@redhat.com> wrote:

> - virtiofs cache=none mode is faster than cache=auto mode for this
>   workload.

Not sure why.  One cause could be that readahead is not perfect at
detecting the random pattern.  Could we compare total I/O on the
server vs. total I/O by fio?

Thanks,
Millos

