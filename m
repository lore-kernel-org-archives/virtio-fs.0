Return-Path: <sgarzare@redhat.com>
Date: Mon, 5 Dec 2022 10:29:49 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
Message-ID: <20221205092949.goyo76dy76u2d4ie@sgarzare-redhat>
References: <20221123131630.52020-1-sgarzare@redhat.com>
 <Y3+5rfnNmR7R/h6/@fedora>
 <20221125081243.a3q7ep32o6g4r2vd@sgarzare-redhat>
 <Y4fFICp5tBrEPud1@fedora>
 <20221201080250.s3cugnnkf5f4kqvo@sgarzare-redhat>
 <87k03bctrj.fsf@linaro.org>
 <20221201052647-mutt-send-email-mst@kernel.org>
 <874jufcnzi.fsf@linaro.org>
 <20221201164750-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20221201164750-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
Content-Disposition: inline
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
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Kevin Wolf <kwolf@redhat.com>, virtio-fs@redhat.com, Mathieu Poirier <mathieu.poirier@linaro.org>, Fam Zheng <fam@euphon.net>, Viresh Kumar <viresh.kumar@linaro.org>, German Maglione <gmaglione@redhat.com>, Jason Wang <jasowang@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Hanna Reitz <hreitz@redhat.com>, qemu-block@nongnu.org, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>

On Thu, Dec 01, 2022 at 04:49:37PM -0500, Michael S. Tsirkin wrote:
>On Thu, Dec 01, 2022 at 12:21:21PM +0000, Alex Benn=E9e wrote:
>>
>> "Michael S. Tsirkin" <mst@redhat.com> writes:
>>
>> > On Thu, Dec 01, 2022 at 10:14:39AM +0000, Alex Benn=E9e wrote:
>> >> Do you think rust-vmm's vhost crates have enough of the state
>> >> management to manage vhost and vhost-user backends? Maybe it would be=
 a
>> >> good experiment in replacing a (small well defined) piece of
>> >> functionality with rust?

I honestly don't know, but I think they are not 100% complete.
I do agree that an experiment would be nice though, maybe a GSoC?
Or maybe not, since it's not very clear whether we get to the end or not....

>> >>
>> >> That said there is a lot of deep magic in the vhost-net stuff which I
>> >> think is down to the interaction with things like vdpk and other netw=
ork
>> >> optimisations that might be missing. For the rest of the devices most=
 of
>> >> the code is basically boiler plate which has grown variations due to
>> >> code motion and change. This is the sort of thing that generics solves
>> >> well.
>> >
>> > Not sure what you want to replace with what though, libvhost-user or
>> > vhost-user bits in qemu?
>>
>> The vhost-user bits in the main QEMU binary. We already don't use
>> libvhost-user for most of our backends anyway ;-)
>
>Mixing C and Rust like this is far from trivial. I'd start with
>something much less ambitious that virtio.

We recently merged libblkio [1] support in QEMU [2], where we did
something similar.
libblkio provides a C API, but the library is totally written in Rust.
Writing the C interface was not too complicated.

The advantage here is that the Rust code is already part of the rust-vmm
crates.
I think it needs adjustments, but it's not a bad idea in my opinion.

Anyway, I don't think it's an easy job, though, so maybe GSoC could just
be about writing the C interface and adapting Rust crates. Touching QEMU
might require too much knowledge of the current code.

Thanks,
Stefano

[1] https://libblkio.gitlab.io/libblkio/
[2] https://lists.nongnu.org/archive/html/qemu-devel/2022-10/msg02215.html

