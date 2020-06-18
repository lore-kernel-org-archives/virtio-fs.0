Date: Thu, 18 Jun 2020 16:09:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200618200902.GA25727@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] podman + virtiofs + SElinux issues
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>, Daniel J Walsh <dwalsh@redhat.com>
Cc: Giuseppe Scrivano <gscrivan@redhat.com>

Hi Dan,

I tried to run podman with virtiofs and ran into SELinux issues.

# mount -t virtiofs myfs /mnt/virtiofs/
# mount --bind /mnt/virtiofs/containers /var/lib/containers/
# podman run -ti fedora bash

# podman run -ti fedora bash
Trying to pull registry.fedoraproject.org/fedora...
Getting image source signatures
Copying blob 1657ffead824 done
Copying config eb7134a03c done
Writing manifest to image destination
Storing signatures
bash: error while loading shared libraries: /lib64/libc.so.6: cannot apply additional memory protection after relocation: Permission denied

I see following in audit.logs

type=AVC msg=audit(1592510365.898:387): avc:  denied  { read } for  pid=5770 comm="bash" path="/usr/lib64/libc-2.31.so" dev="virtiofs" ino=2757637 scontext=system_u:system_r:container_t:s0:c211,c761 tcontext=system_u:object_r:unlabeled_t:s0 tclass=file permissive=0

We had discussed that we will need to disable SELinux in guest so that
host policy continues to work. Right now I don't think guest SELinux
labels are stored on host.

Can I do a context mount of virtiofs to fake the labels which are
compatible with system_u:system_r:container_t:s0:c211,c761. So that
I don't have to disable selinux for whole container.

Thanks
Vivek

