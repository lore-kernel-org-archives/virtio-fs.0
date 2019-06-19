Date: Wed, 19 Jun 2019 20:10:31 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190619191030.GI2844@work-vm>
References: <2D50E1B6-E051-42F1-8962-71B7436E4CF9@stackhpc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2D50E1B6-E051-42F1-8962-71B7436E4CF9@stackhpc.com>
Subject: Re: [Virtio-fs] Issues running fio tests against a network mount
 routed from the host
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Bharat Kunwar <bharat@stackhpc.com>
Cc: virtio-fs@redhat.com

* Bharat Kunwar (bharat@stackhpc.com) wrote:
> Hello

Hi,

> I am here to describe a problem that I’ve run into when trying to run `fio` against a network mount routed from the host using virtiofs. My wider context is that I am doing this in a kata-containerised Kubernetes environment using the new `kata-qemu` introduced in version 1.7. I have previously run the same tests with `kata-qemu` runtime with 9p filesystem and the same tests have run to completion.
> 
> Just to clarify, I can run the same fio tests to a local filesystem on the host and things run happily to completion. I have attached perf flame graphs corresponding to the failure cases, BeeGFS and CephFS and the successful case with host filesystem. The Fhgfs* process are related to BeeGFS.
> 
> I enabled debug on the kata side the the resulting systemd journal entries are captured in debug.log attached. Let me know if I can provide any more diagnostic info. I am currently attempting to build an image to boot up with symbols enabled so that I can capture some backtraces but that is all taking longer than expected (having never built a kernel tarball before). If there is a prebuilt image that I can use to boot up to use with virtiofs, let me know as that’d save me a ton of time.

For some reason the SVGs don't seem to want to open for me; but they're
probably the wrong thing anyway; and I don't see the log you say you
attacked - those sound potentially useful.

Which fio test fails exactly, and with what error?

Dave

> Best
> 
> Bharat
> 
> 
> 
> 
> 




> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

