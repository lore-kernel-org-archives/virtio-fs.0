Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
 :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
 :message-id:reply-to;
 bh=h9Hli6/J6woMHzWWxqg4iMfqtyy7Avj69wB+Ck4/WGU=;
 b=bXUyzDqLoLWZGtywefffhHIr0PsBVsefBPY7NR0PkBRVfSScXkxM3oKVJl0f4s4SSJ
 6ceWfnIyxsSyixXqmeZzybrsUi5Bl24AdHbAN3ueWYiqSw6iGwVZSEE/JEOwyQQnAylk
 mDh6h6r/PoXre2W+jvAATbOBcXqRlKfLpBMzJ0BGbkBjaIGIOMG/MmPnGCYAwknTpwzX
 8Ap8WTsOLIGmqaC0BqtYjMEXSIkzFnnTKl5IgUutUUki/bs/bdesIb7rzxmByI3TUgAY
 L0IPGCaRKkgByvvU7gzSkL+LPHcm8GGO1hFYrbZ/wKYbXbeA308pcMS6zy29aHYMZ2FC
 hWPg==
References: <20221108092308.1717426-1-alex.bennee@linaro.org>
 <20221108092308.1717426-6-alex.bennee@linaro.org>
 <20221108043249-mutt-send-email-mst@kernel.org>
 <8735atg2vh.fsf@linaro.org>
 <20221108052544-mutt-send-email-mst@kernel.org>
 <87y1slelmw.fsf@linaro.org>
 <20221108102011-mutt-send-email-mst@kernel.org>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Tue, 08 Nov 2022 16:41:17 +0000
In-reply-to: <20221108102011-mutt-send-email-mst@kernel.org>
Message-ID: <87tu39e6dk.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH v1 5/9] hw/virtio: introduce
 virtio_device_should_start
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: qemu-devel@nongnu.org, fam@euphon.net, berrange@redhat.com, f4bug@amsat.org, aurelien@aurel32.net, pbonzini@redhat.com, stefanha@redhat.com, crosa@redhat.com, Raphael Norwitz <raphael.norwitz@nutanix.com>, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, "open list:Block layer core" <qemu-block@nongnu.org>, "open list:virtiofs" <virtio-fs@redhat.com>


"Michael S. Tsirkin" <mst@redhat.com> writes:

> On Tue, Nov 08, 2022 at 11:21:26AM +0000, Alex Benn=C3=A9e wrote:
>>=20
>> "Michael S. Tsirkin" <mst@redhat.com> writes:
>>=20
>> > On Tue, Nov 08, 2022 at 10:23:15AM +0000, Alex Benn=C3=A9e wrote:
>> >>=20
>> >> "Michael S. Tsirkin" <mst@redhat.com> writes:
>> >>=20
>> >> > On Tue, Nov 08, 2022 at 09:23:04AM +0000, Alex Benn=C3=A9e wrote:
>> >> >> The previous fix to virtio_device_started revealed a problem in it=
s
>> >> >> use by both the core and the device code. The core code should be =
able
>> >> >> to handle the device "starting" while the VM isn't running to hand=
le
>> >> >> the restoration of migration state. To solve this dual use introdu=
ce a
>> >> >> new helper for use by the vhost-user backends who all use it to fe=
ed a
>> >> >> should_start variable.
>> >> >>=20
>> >> >> We can also pick up a change vhost_user_blk_set_status while we ar=
e at
>> >> >> it which follows the same pattern.
>> >> >>=20
>> >> >> Fixes: 9f6bcfd99f (hw/virtio: move vm_running check to virtio_devi=
ce_started)
>> >> >> Fixes: 27ba7b027f (hw/virtio: add boilerplate for vhost-user-gpio =
device)
>> >> >> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>> >> >> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>> >> >
>> >> > why is this in this patchset?
>> >>=20
>> >> As per my cover letter:
>> >>=20
>> >>   Most of these patches have been posted before as single patch RFCs.=
 A
>> >>   couple are already scheduled through other trees so will drop out i=
n
>> >>   due course
>> >>=20
>> >> but I keep them in my tree until they are merged so I can continue to
>> >> soak test them (and have a stable base for my other WIP trees).
>> >
>> > That's fine just pls don't double-post them on list, certainly
>> > not as part of a patchset.
>>=20
>> Why not? Is this breaking some tooling?
>
> Yes patchset breaks git am if you try to apply part of it.
>
> Reposting creates work for reviewers - why should they have to read the s=
ame
> patch twice?  In this case it also made me scratch my head trying to
> figure out what to do about it.
>
> But, if you are careful and maintain an ordered changelog after "---"
> and there it says=20
> =09changes since rfc:
> =09=09no changes, subject changed=20
>
> then this second part is less of a problem

Ahh yes, I should have updated to point out I added the extra Fixes line
as per the review. I guess you added that in your PR? Anyway it's
dropped now your PR has gone in.

--=20
Alex Benn=C3=A9e

