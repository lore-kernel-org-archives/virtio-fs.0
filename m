Return-Path: <vgoyal@redhat.com>
Date: Thu, 29 Sep 2022 13:03:45 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YzXP8XhCG5ta2Dvv@redhat.com>
References: <YzMmu3xfOtQwuFUx@redhat.com> <YzMrYAJQeSP2hDSs@redhat.com>
 <CAJh=p+5rQDBJJC8VNGL10KYgDeq-Hg5WK7avONCti03eJGH+ow@mail.gmail.com>
 <798fe353-9537-44fe-a76a-819e8c93abb5@www.fastmail.com>
 <YzNZnPiUqySu6sGh@fedora>
 <20220928083340.eyizwu6mm3cc3bxu@mhamilton>
 <YzSgeDdpHOw1hTM0@redhat.com>
 <b963f623-aa85-4285-9bfa-5fcb4744c354@app.fastmail.com>
 <YzWnPZ5Y6ivS8e1v@redhat.com>
 <b1cf0d02-cc45-4f5c-bfef-fda3e750bef3@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1cf0d02-cc45-4f5c-bfef-fda3e750bef3@app.fastmail.com>
Subject: Re: [Virtio-fs] virtiofsd: Any reason why there's not an "openat2"
 sandbox mode?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Colin Walters <walters@verbum.org>
Cc: Sergio Lopez <slp@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org, German Maglione <gmaglione@redhat.com>

On Thu, Sep 29, 2022 at 11:47:32AM -0400, Colin Walters wrote:
> 
> 
> On Thu, Sep 29, 2022, at 10:10 AM, Vivek Goyal wrote:
> 
> > What's your use case. How do you plan to use virtiofs.
> 
> At the current time, the Kubernetes that we run does not support user namespaces.  We want to do the production builds of our operating system (Fedora CoreOS and RHEL CoreOS) today inside an *unprivileged* Kubernetes pod (actually in OpenShift using anyuid, i.e. random unprivileged uid too), just with /dev/kvm exposed from the host (which is safe).  Operating system builds *and* tests in qemu are just another workload that can be shared with other tenants.
> 
> qemu works fine in this model, as does 9p.  It's just the virtiofs isolation requires privileges to be used today.

[ cc German ]

Hi Colin,

So rust version of virtiofsd, already supports running unprivileged
(inside a user namespace).

https://gitlab.com/virtio-fs/virtiofsd/-/blob/main/README.md#running-as-non-privileged-user

host$ podman unshare -- virtiofsd --socket-path=/tmp/vfsd.sock --shared-dir /mnt \
        --announce-submounts --sandbox chroot &

I think only privileged operation it needs is assigning a range of
subuid/subgid to the uid you are using on host.

I think that should be usable for you as of now.

Having said that, openat2() and landlock are interesting improvements,
especially when somebody does not want to use user namespaces. Without
user namespaces, one will not be able to do arbitrary swithing of uid/gid.
IOW, inside guest, you will be limited to one uid/gid.

I am hoping German or somebody else can have a look openat2() and landlock
improvements in near future.

I am assuming you are fine with using user namespaces on host. And by
assigning subuid/subgid range, it will allow you arbitrary swithching
of uid/gid inside guest.

Can you give rust virtiofsd (unprivileged) a try.

Thanks
Vivek
