Return-Path: <berrange@redhat.com>
Date: Tue, 12 Jul 2022 16:44:21 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Message-ID: <Ys2W1bm7LQVk7ifa@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220615155129.1025811-1-stefanha@redhat.com>
 <20220615155129.1025811-7-stefanha@redhat.com>
 <Ys0zQiFvsLozii7U@redhat.com>
 <5CF345CD-94BE-452C-A817-4A8AD3CD734A@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5CF345CD-94BE-452C-A817-4A8AD3CD734A@oracle.com>
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

On Tue, Jul 12, 2022 at 03:27:09PM +0000, Jag Raman wrote:
> 
> 
> On Jul 12, 2022, at 4:39 AM, Daniel P. Berrangé <berrange@redhat.com<mailto:berrange@redhat.com>> wrote:
> 
> On Wed, Jun 15, 2022 at 04:51:17PM +0100, Stefan Hajnoczi wrote:
> From: Jagannathan Raman <jag.raman@oracle.com<mailto:jag.raman@oracle.com>>
> 
> add the libvfio-user library as a submodule. build it as a meson
> subproject.
> 
> libvfio-user is distributed with BSD 3-Clause license and
> json-c with MIT (Expat) license
> 
> Signed-off-by: Elena Ufimtseva <elena.ufimtseva@oracle.com<mailto:elena.ufimtseva@oracle.com>>
> Signed-off-by: John G Johnson <john.g.johnson@oracle.com<mailto:john.g.johnson@oracle.com>>
> Signed-off-by: Jagannathan Raman <jag.raman@oracle.com<mailto:jag.raman@oracle.com>>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com<mailto:stefanha@redhat.com>>
> Message-id: c2adec87958b081d1dc8775d4aa05c897912f025.1655151679.git.jag.raman@oracle.com<mailto:c2adec87958b081d1dc8775d4aa05c897912f025.1655151679.git.jag.raman@oracle.com>
> 
> [Changed submodule URL to QEMU's libvfio-user mirror on GitLab. The QEMU
> project mirrors its dependencies so that it can provide full source code
> even in the event that its dependencies become unavailable. Note that
> the mirror repo is manually updated, so please contact me to make newer
> libvfio-user commits available. If I become a bottleneck we can set up a
> cronjob.
> 
> Updated scripts/meson-buildoptions.sh to match the meson_options.txt
> change. Failure to do so can result in scripts/meson-buildoptions.sh
> being modified by the build system later on and you end up with a dirty
> working tree.
> --Stefan]
> 
> snip
> 
> diff --git a/tests/docker/dockerfiles/centos8.docker b/tests/docker/dockerfiles/centos8.docker
> index 4b20925bbf..10618bfa83 100644
> --- a/tests/docker/dockerfiles/centos8.docker
> +++ b/tests/docker/dockerfiles/centos8.docker
> @@ -51,6 +51,7 @@ RUN dnf update -y && \
> libbpf-devel \
> libcacard-devel \
> libcap-ng-devel \
> + libcmocka-devel \
> libcurl-devel \
> libdrm-devel \
> libepoxy-devel \
> @@ -59,6 +60,7 @@ RUN dnf update -y && \
> libgcrypt-devel \
> libiscsi-devel \
> libjpeg-devel \
> + json-c-devel \
> libnfs-devel \
> libpmem-devel \
> libpng-devel \
> 
> Per the big warning message at the top of this file, this package listing
> is entirely auto-generated so should not be hand editted like this. Its
> content is all driven by mappings in the tests/lcitool/libvirt-ci submodule,
> which is what should have been updated. It would have then ensured these
> new packages were added to all the dockerfiles, and that the changes are
> not losted when the dockerfile is re-generated.
> 
> Thanks for pointing this out, Daniel!
> 
> Will update the libvirt-ci project with this, and update QEMU
> once that change is pulled into libvirt-ci.

Don't worry, I've just got a libvirt-ci update merged:

  https://gitlab.com/libvirt/libvirt-ci/-/merge_requests/293

as I need to fix QEMU CI for FreeBSD already.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|
