DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=date:from:to:cc:subject:message-id:references:mime-version
	:content-disposition:in-reply-to:user-agent;
	bh=dhDgHNG5a9/PpetauAfy6fD41aZHq7Bf07H9DI6pC7w=;
	b=HqRyAcW6sGrfgKtLqDanxOuXs5lhIkYyC286FlpSEVYqrlXza33sWimrCQuaeH9Re6
	LFQwhY3tbENbGuoEmIw8EKBsyojgCJ7g9mV9ndF+qU5ZTrlTcsq8uGkQ2tffFrL5Z0dF
	B8PEJdOT2nJU/ZA9jF3FU3wFlofcrdX9bT9UqJHKyURTn7elktzHQSpJuPwM3TkSd2Xy
	VybumEVxhCM87UQnzf/le6tbgh89yPQWqGGpNl7fk9ySrL9uuqbC0fgUHP84+t+mmYmO
	tQ4QHq95+HvDHUzbQZbEb9svaT7JfncvXi158C5HpMG+87JURmN1z16c11mHr61nH3o7
	rUOg==
Date: Mon, 5 Aug 2019 09:01:56 +0100
From: Stefan Hajnoczi <stefanha@gmail.com>
Message-ID: <20190805080156.GA22337@stefanha-x1.localdomain>
References: <20190801165409.20121-1-stefanha@redhat.com>
	<5D4799E5.6020006@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D4799E5.6020006@huawei.com>
Subject: Re: [Virtio-fs] [Qemu-devel] [PATCH 0/4] virtiofsd: multithreading
 preparation part 3
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Mon, Aug 05, 2019 at 10:52:21AM +0800, piaojun wrote:
> # fio -direct=1 -time_based -iodepth=1 -rw=randwrite -ioengine=libaio -bs=1M -size=1G -numjob=1 -runtime=30 -group_reporting -name=file -filename=/mnt/9pshare/file

This benchmark configuration (--iodepth=1 --numjobs=1) cannot benefit
from virtiofsd multithreading.  Have you measured a regression when this
patch series is applied?

If your benchmark is unrelated to this patch series, let's discuss it in
a separate email thread.  fuse_buf_copy() can be optimized to use
pwritev().

Thanks,
Stefan

