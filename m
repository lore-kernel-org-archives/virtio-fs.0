DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=eLCyptLZMIUaP219LdO+JXDrTSP0YEWXNBxyuxqIqhI=;
	b=Jq4RI70P8u/vE5hkRTYGJDJKTLpcYegAGYKVZ0yvfJj2RBeZDhuS5EkR4wMS8TNAJg
	ofiMtouVtHMAHi9BRPYJrJNWp+e02IWxoTrdvUY1aP0z9QizBzNHklt/OBW6FwoRfYTO
	A0/zjCFG7ij519gJd+L3fEQqQWYNbMKsDxzbs=
MIME-Version: 1.0
References: <7331fd60-10c6-6076-4cf5-f5cce7bc6ef1@jp.fujitsu.com>
	<20191007143444.GA174343@work-vm> <20191009165116.GJ2893@work-vm>
	<27035e4a-bd12-e5d8-30d0-0df45e75457c@jp.fujitsu.com>
	<CAJFHJrr5Esq=cjZNW4qZRABtCCh_vpkFJEQO9kYb=Pg62O+weQ@mail.gmail.com>
	<20191011195935.GB13861@redhat.com>
	<CAJFHJrq6bQo=yvO0tAxH7RWg=U=ftpsePs3c7y-AcE90Wh4afg@mail.gmail.com>
	<20191011203647.GC13861@redhat.com>
	<20191014091108.GH22963@stefanha-x1.localdomain>
	<CAJFHJrrqfjQqMu-K99DiBYNmD1=hB710wRZ88w--SQ0GxQv9Tw@mail.gmail.com>
	<20191016140959.GA5487@stefanha-x1.localdomain>
In-Reply-To: <20191016140959.GA5487@stefanha-x1.localdomain>
From: Chirantan Ekbote <chirantan@chromium.org>
Date: Thu, 17 Oct 2019 04:36:33 +0900
Message-ID: <CAJFHJrrtVHJQr6tCRYJmL-roVo_dMekOLQPsb4ryc96Bf6hAJA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] xfstest results for virtio-fs on aarch64
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "masayoshi.mizuma@fujitsu.com" <masayoshi.mizuma@fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>

On Wed, Oct 16, 2019 at 11:10 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Tue, Oct 15, 2019 at 11:58:46PM +0900, Chirantan Ekbote wrote:
> >
> > As for the performance numbers, I don't have my test device with me
> > but if I remember correctly the blogbench scores almost doubled when
> > going from one queue to two queues.
>
> If I understand the code correctly each virtqueue is processed by a
> worker and the number of virtqueues is the vcpu count.  This means that
> requests are processed in a blocking fashion and the disk is unlikely to
> reach its maximum queue depth (e.g. often 64 requests).
>
> Going from 1 virtqueue to 2 virtqueues will improve performance, but
> it's still a far cry from the maximum queue depth that the host kernel
> and hardware supports.  This is why virtiofsd processes multiple
> requests in parallel on a single virtqueue using a thread pool.

Hmm, maybe I'm missing something but isn't this still limited by the
number of requests that can fit in the virtqueue?  Unlike virtio-net
there is no separate queue for sending data back from host -> guest.
Each request also includes a buffer for the response so once the
virtqueue is full all other requests block in the guest until a
request is completed and can be removed from the queue.  So even in a
thread pool model, going from 1 virtqueue to 2 virtqueues would double
the number of requests that can be handled in parallel.

>
> Stefan

