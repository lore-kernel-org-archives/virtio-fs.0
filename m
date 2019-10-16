Date: Wed, 16 Oct 2019 15:44:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20191016194443.GA18180@redhat.com>
References: <20191009165116.GJ2893@work-vm>
	<27035e4a-bd12-e5d8-30d0-0df45e75457c@jp.fujitsu.com>
	<CAJFHJrr5Esq=cjZNW4qZRABtCCh_vpkFJEQO9kYb=Pg62O+weQ@mail.gmail.com>
	<20191011195935.GB13861@redhat.com>
	<CAJFHJrq6bQo=yvO0tAxH7RWg=U=ftpsePs3c7y-AcE90Wh4afg@mail.gmail.com>
	<20191011203647.GC13861@redhat.com>
	<20191014091108.GH22963@stefanha-x1.localdomain>
	<CAJFHJrrqfjQqMu-K99DiBYNmD1=hB710wRZ88w--SQ0GxQv9Tw@mail.gmail.com>
	<20191016140959.GA5487@stefanha-x1.localdomain>
	<CAJFHJrrtVHJQr6tCRYJmL-roVo_dMekOLQPsb4ryc96Bf6hAJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJFHJrrtVHJQr6tCRYJmL-roVo_dMekOLQPsb4ryc96Bf6hAJA@mail.gmail.com>
Subject: Re: [Virtio-fs] xfstest results for virtio-fs on aarch64
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "masayoshi.mizuma@fujitsu.com" <masayoshi.mizuma@fujitsu.com>

On Thu, Oct 17, 2019 at 04:36:33AM +0900, Chirantan Ekbote wrote:
> On Wed, Oct 16, 2019 at 11:10 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> >
> > On Tue, Oct 15, 2019 at 11:58:46PM +0900, Chirantan Ekbote wrote:
> > >
> > > As for the performance numbers, I don't have my test device with me
> > > but if I remember correctly the blogbench scores almost doubled when
> > > going from one queue to two queues.
> >
> > If I understand the code correctly each virtqueue is processed by a
> > worker and the number of virtqueues is the vcpu count.  This means that
> > requests are processed in a blocking fashion and the disk is unlikely to
> > reach its maximum queue depth (e.g. often 64 requests).
> >
> > Going from 1 virtqueue to 2 virtqueues will improve performance, but
> > it's still a far cry from the maximum queue depth that the host kernel
> > and hardware supports.  This is why virtiofsd processes multiple
> > requests in parallel on a single virtqueue using a thread pool.
> 
> Hmm, maybe I'm missing something but isn't this still limited by the
> number of requests that can fit in the virtqueue?  Unlike virtio-net
> there is no separate queue for sending data back from host -> guest.
> Each request also includes a buffer for the response so once the
> virtqueue is full all other requests block in the guest until a
> request is completed and can be removed from the queue.  So even in a
> thread pool model, going from 1 virtqueue to 2 virtqueues would double
> the number of requests that can be handled in parallel.

Yes. But default queue size is big enough to pack good number of requests.
IIUC, it is 1024 on my VM. So 64 threads can do I/O on these 1024
requests.

But having multiple queue can make it even better and allow more I/O to
make progress in parallel.

We do have plans to implement another queue for notifying guest and
send notifications for things like lock has been acquired, possibly
metadata change notifications as well. 

Thanks
Vivek

