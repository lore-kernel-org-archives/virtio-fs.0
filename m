Return-Path: <vgoyal@redhat.com>
Date: Wed, 5 Oct 2022 17:29:54 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <Yz33UikaqR4cagWK@redhat.com>
References: <CAJh=p+5rQDBJJC8VNGL10KYgDeq-Hg5WK7avONCti03eJGH+ow@mail.gmail.com>
 <798fe353-9537-44fe-a76a-819e8c93abb5@www.fastmail.com>
 <YzNZnPiUqySu6sGh@fedora>
 <20220928083340.eyizwu6mm3cc3bxu@mhamilton>
 <YzSgeDdpHOw1hTM0@redhat.com>
 <b963f623-aa85-4285-9bfa-5fcb4744c354@app.fastmail.com>
 <YzWnPZ5Y6ivS8e1v@redhat.com>
 <b1cf0d02-cc45-4f5c-bfef-fda3e750bef3@app.fastmail.com>
 <YzXP8XhCG5ta2Dvv@redhat.com>
 <aa26d28d-d352-467c-910c-ab5973a6d759@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa26d28d-d352-467c-910c-ab5973a6d759@app.fastmail.com>
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

On Mon, Oct 03, 2022 at 06:51:42PM -0400, Colin Walters wrote:
> 
> 
> On Thu, Sep 29, 2022, at 1:03 PM, Vivek Goyal wrote:
> > 
> > So rust version of virtiofsd, already supports running unprivileged
> > (inside a user namespace).
> 
> I know, but as I already said, the use case here is running inside an OpenShift unprivileged pod where *we are already in a container*.
> 
> > host$ podman unshare -- virtiofsd --socket-path=/tmp/vfsd.sock 
> > --shared-dir /mnt \
> >         --announce-submounts --sandbox chroot &
> 
> Yes, but in current OCP 4.11 our seccomp policy denies CLONE_NEWUSER:

Hmm..., no user namespaces allowed. 

So sandbox=none in theory should work once we fix it for unprivileged
user.

https://gitlab.com/virtio-fs/virtiofsd/-/merge_requests/136

Given you are already running inside a pod/container, not sure if
locking down virtiofsd with openat2(RESOLVE_IN_ROOT)/landlock is
must for you from security point of view. virtiofsd should not be
able to access anything outside the pod/container anyway and can
only affect things inside the pod/container.

Once we add support for openat2(). Next issue is do you need
arbitrary uid/gid support. By default it will be a single uid/gid
filesystem. Is that enough for your use case? Or inside the guest
you need to be able to switch between arbitrary uid/gid on this
virtiofs filesystem.



> 
> ```
> $ unshare -m
> unshare: unshare failed: Function not implemented
> ```
> 
> https://docs.openshift.com/container-platform/4.11/security/seccomp-profiles.html
> 
> > I think only privileged operation it needs is assigning a range of
> > subuid/subgid to the uid you are using on host.
> 
> We also turn on NO_NEW_PRIVILEGES by default in OCP pods.  
> 
> Now, I *could* in general get elevated permissions where I need to today.  But it's also really important to me to have a long term goal of having operating system builds and tests work well as "just another workload" in our production container platform (now, one *does* want to bind in /dev/kvm, but that's generally safe, and even that strictly speaking is optional if one can stomach the ~10x perf hit).

I am assuming this 10x performance hit is being compared with native
container build and test where no VM will be launched.


> 
> > Can you give rust virtiofsd (unprivileged) a try.
> 
> I admit to not actually trying it in a pod, but I think we all agree it can't work, and the only thing that can today is openat2.

Agreed. Right now we rely on using user namespace for unpriviliged use
case. 

We should be able to enable sandbox=none for unprivileged user (no user
namespace) and possibly add openat2() support as well. 

I think being able to provide arbitrary uid/gid support will be more
tricky and more work. It will need to store actual uid/gid into some
sort of user xattr. (as done by 9pfs and fuse-overlay and libkrun etc).
And I will not be surprised that there are bunch of corner cases using
that approach. (setuid/setgid automatic clearing etc.)

Thanks
Vivek
