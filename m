References: <20190801165409.20121-1-stefanha@redhat.com>
	<5D4799E5.6020006@huawei.com>
	<20190805080156.GA22337@stefanha-x1.localdomain>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D47F98A.5060807@huawei.com>
Date: Mon, 5 Aug 2019 17:40:26 +0800
MIME-Version: 1.0
In-Reply-To: <20190805080156.GA22337@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
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
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

Hi Stefan,

On 2019/8/5 16:01, Stefan Hajnoczi wrote:
> On Mon, Aug 05, 2019 at 10:52:21AM +0800, piaojun wrote:
>> # fio -direct=1 -time_based -iodepth=1 -rw=randwrite -ioengine=libaio -bs=1M -size=1G -numjob=1 -runtime=30 -group_reporting -name=file -filename=/mnt/9pshare/file
> 
> This benchmark configuration (--iodepth=1 --numjobs=1) cannot benefit
> from virtiofsd multithreading.  Have you measured a regression when this
> patch series is applied?
> 
> If your benchmark is unrelated to this patch series, let's discuss it in
> a separate email thread.  fuse_buf_copy() can be optimized to use
> pwritev().
> 
> Thanks,
> Stefan

Yes, I have not applied your patch series and test. As you said, I will
discuss *pwritev* in another email.

Thanks,
Jun

> 

