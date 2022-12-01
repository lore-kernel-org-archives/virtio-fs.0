Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
 :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
 :message-id:reply-to;
 bh=XAyBhoz/alhq0qQkmUSt4I0if7PHnFXtkOIWbSuwCyw=;
 b=Z0FmOhqcxd0Hm8WExU0jhq0c8pewLk+lG6OaTUFMm//j0vXWTJypXqxHTZGLolp5mk
 2P8qtMcKqO0V3pfr1L3ERyC/QDXAeuxnqD0ngQiQfgo1HAjmJd40TtPW3FvanEfnkl1v
 yDc5juxnPJjtn/AEYUvzmctW3fgru1SV2JSQLl0tvyd40RdPTxZeoqi4+t7k8JFas6cS
 OyN3hErefcSqYsl0OltwUZvH+Y9+gLs2NMMYwhWyDuMBi1Hu6x2q6npH1pp2nqoZ7HI8
 3oKOUiM1YQMGLkxOe3/86jqZR5JRx4cDtelfY5Litt0ymz2p4banwkGfohalXJurRjPT
 G5KQ==
References: <20221123131630.52020-1-sgarzare@redhat.com>
 <Y3+5rfnNmR7R/h6/@fedora>
 <20221125081243.a3q7ep32o6g4r2vd@sgarzare-redhat>
 <Y4fFICp5tBrEPud1@fedora>
 <20221201080250.s3cugnnkf5f4kqvo@sgarzare-redhat>
 <87k03bctrj.fsf@linaro.org>
 <20221201052647-mutt-send-email-mst@kernel.org>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Thu, 01 Dec 2022 12:21:21 +0000
In-reply-to: <20221201052647-mutt-send-email-mst@kernel.org>
Message-ID: <874jufcnzi.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH for-7.2] vhost: enable vrings in
 vhost_dev_start() for vhost-user devices
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Kevin Wolf <kwolf@redhat.com>, virtio-fs@redhat.com, Mathieu Poirier <mathieu.poirier@linaro.org>, Fam Zheng <fam@euphon.net>, Viresh Kumar <viresh.kumar@linaro.org>, German Maglione <gmaglione@redhat.com>, Jason Wang <jasowang@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Hanna Reitz <hreitz@redhat.com>, qemu-block@nongnu.org, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>


"Michael S. Tsirkin" <mst@redhat.com> writes:

> On Thu, Dec 01, 2022 at 10:14:39AM +0000, Alex Benn=C3=A9e wrote:
>> Do you think rust-vmm's vhost crates have enough of the state
>> management to manage vhost and vhost-user backends? Maybe it would be a
>> good experiment in replacing a (small well defined) piece of
>> functionality with rust?
>>=20
>> That said there is a lot of deep magic in the vhost-net stuff which I
>> think is down to the interaction with things like vdpk and other network
>> optimisations that might be missing. For the rest of the devices most of
>> the code is basically boiler plate which has grown variations due to
>> code motion and change. This is the sort of thing that generics solves
>> well.
>
> Not sure what you want to replace with what though, libvhost-user or
> vhost-user bits in qemu?

The vhost-user bits in the main QEMU binary. We already don't use
libvhost-user for most of our backends anyway ;-)

--=20
Alex Benn=C3=A9e

