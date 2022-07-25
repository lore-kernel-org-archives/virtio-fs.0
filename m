Return-Path: <berrange@redhat.com>
Date: Mon, 25 Jul 2022 15:50:52 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <Yt6tzDw0R/UZL3NF@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220615155129.1025811-1-stefanha@redhat.com>
 <20220615155129.1025811-7-stefanha@redhat.com>
 <Ytkpiao5Zk8Pj5Lq@redhat.com>
 <97E1536C-58CF-4DDD-94C9-D44EF63C5AA5@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <97E1536C-58CF-4DDD-94C9-D44EF63C5AA5@oracle.com>
Subject: Re: [Virtio-fs] [PULL 06/18] vfio-user: build library
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jag Raman <jag.raman@oracle.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel <qemu-devel@nongnu.org>, Thomas Huth <thuth@redhat.com>, Aarushi Mehta <mehta.aaru20@gmail.com>, Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>, Elena Ufimtseva <elena.ufimtseva@oracle.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Laurent Vivier <lvivier@redhat.com>, "qemu-block@nongnu.org" <qemu-block@nongnu.org>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, Hanna Reitz <hreitz@redhat.com>, David Hildenbrand <david@redhat.com>, Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, Eric Blake <eblake@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Beraldo Leal <bleal@redhat.com>, Peter Xu <peterx@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Qiuhao Li <Qiuhao.Li@outlook.com>, Paolo Bonzini <pbonzini@redhat.com>, Markus Armbruster <armbru@redhat.com>, Bandan Das <bsd@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Alexander Bulekov <alxndr@bu.edu>, Julia Suvorova <jusual@redhat.com>, Darren Kenny <darren.kenny@oracle.com>, Wainer dos Santos Moschetta <wainersm@redhat.com>, John Johnson <john.g.johnson@oracle.com>

On Mon, Jul 25, 2022 at 02:45:09PM +0000, Jag Raman wrote:
> Hi Daniel,
> 
> We’ve created the following issue to update QEMU’s libvfio-user mirror
> to the latest:
> https://gitlab.com/qemu-project/libvfio-user/-/issues/1
> 
> Will update QEMU’s submodule once this mirror is updated.

That sounds good, thank you. We should be fine to get the
submodule reefreshed even in soft freeze, given that it is
fixing a test failure bug.

Oh and I just noticed I messed up your name in my message
below. I'm very sorry about that.

With regards,
Daniel 

> On Jul 21, 2022, at 6:25 AM, Daniel P. Berrangé <berrange@redhat.com<mailto:berrange@redhat.com>> wrote:
> 
> Hi Jay / Stefan,
> 
> We've got a non-determinsitic hang in QEMU CI since this series
> merged, which we tracked down to a libvfio-user test that is
> flakey:
> 
>  https://gitlab.com/qemu-project/qemu/-/issues/1114
> 
> John Levon has proposed a PR to libvfio-user to turn off the
> test, but we'll need one of you to update the git submodule
> for libvfio-user on the QEMU side, as I can't find a nice way
> to selectively skip the test from QEMU side alone.
> 
> With regards
> Daniel
> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|
