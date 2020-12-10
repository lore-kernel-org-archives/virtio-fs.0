MIME-Version: 1.0
References: <20201210161126.GA125438@redhat.com>
In-Reply-To: <20201210161126.GA125438@redhat.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Thu, 10 Dec 2020 20:29:21 +0100
Message-ID: <CAOssrKcKaosJo1W+sek0AOA3CdyE+ZUWzx8KPsn=Gz3Nor+_iQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] Some performance numbers for virtiofs,
	DAX and virtio-9p
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Venegas Munoz, Jose Carlos" <jose.carlos.venegas.munoz@intel.com>, Christian Schoenebeck <qemu_oss@crudebyte.com>, QEMU Developers <qemu-devel@nongnu.org>, virtio-fs-list <virtio-fs@redhat.com>

On Thu, Dec 10, 2020 at 5:11 PM Vivek Goyal <vgoyal@redhat.com> wrote:

> Conclusion
> -----------
> - virtiofs DAX seems to help a lot in many workloads.
>
>   Note, DAX performance well only if data fits in cache window. My total
>   data is 16G and cache window size is 16G as well. If data is larger
>   than DAX cache window, then performance of dax suffers a lot. Overhead
>   of reclaiming old mapping and setting up a new one is very high.

Which begs the question: what is the optimal window size?

What is the cost per GB of window to the host and guest?

Could we measure at what point does a large window size actually make
performance worse?

>
> NAME                    WORKLOAD                Bandwidth       IOPS
> 9p-none                 seqread-psync           98.6mb          24.6k
> 9p-mmap                 seqread-psync           97.5mb          24.3k
> 9p-loose                seqread-psync           91.6mb          22.9k
> vtfs-none               seqread-psync           98.4mb          24.6k
> vtfs-none-dax           seqread-psync           660.3mb         165.0k
> vtfs-auto               seqread-psync           650.0mb         162.5k
> vtfs-auto-dax           seqread-psync           703.1mb         175.7k
> vtfs-always             seqread-psync           671.3mb         167.8k
> vtfs-always-dax         seqread-psync           687.2mb         171.8k
>
> 9p-none                 seqread-psync-multi     397.6mb         99.4k
> 9p-mmap                 seqread-psync-multi     382.7mb         95.6k
> 9p-loose                seqread-psync-multi     350.5mb         87.6k
> vtfs-none               seqread-psync-multi     360.0mb         90.0k
> vtfs-none-dax           seqread-psync-multi     2281.1mb        570.2k
> vtfs-auto               seqread-psync-multi     2530.7mb        632.6k
> vtfs-auto-dax           seqread-psync-multi     2423.9mb        605.9k
> vtfs-always             seqread-psync-multi     2535.7mb        633.9k
> vtfs-always-dax         seqread-psync-multi     2406.1mb        601.5k

Seems like in all the -multi tests 9p-none performs consistently
better than vtfs-none.   Could that be due to the single queue?

Thanks,
Miklos

