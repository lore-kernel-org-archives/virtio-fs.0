DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
	h=subject : to : cc :
	references : from : message-id : date : in-reply-to : content-type :
	content-transfer-encoding : mime-version; s=corp-2020-01-29;
	bh=CZksD+woiUFxuasOpc898fZGqaG2cWGYr37E3Ru6xBw=;
	b=CbbSsXx7aG5z1Cpbt5CU9JOiCgKZoYFig3r9O1JctOjMzSQ+c/Yb98G5WbsoxACC4EAJ
	umHgzVMjZ3vg9mMHXwyEg5uzfrZi9XSB5cD3h52psjJ7tKjSG/XxvVpZm6oJJE8dILY/
	OLrS1ekQJ8kikMoNKhx3MHY0RRpsnDKQg+J7VKwT4cHBMsSOLKBrvkHXBOfRygOu64nj
	8sCzdxNkilshK9dC64aRvTb7hQ68411g/pKX+0KOafxc8zitr8QMskUEl6JDLbzRdjiK
	73ujtIXoIEJkHe9/MK0w7M991/1cw6EuWVoDOqSPXmkmp82llyYAzmbQ6DnXsOeoqnQb
	rA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=CZksD+woiUFxuasOpc898fZGqaG2cWGYr37E3Ru6xBw=;
	b=sXwWRdKz0sVR63uJ3krBuUbfl5tDtw7g1wJ6/3ejMpid4I887yxSGKwKT7aN3i0+SGQG+ZP4XDUmeHRCaD0ysmBv8Ic486nOyV45AOMm1fd6wZULAG9SOgZcRnVDExum4LryiokZ4z4hN7ySCStXTE10wJ7iEokQL97c8HocnRo=
References: <20210126103502.260758-1-stefanha@redhat.com>
From: Liam Merwick <liam.merwick@oracle.com>
Message-ID: <a0e6ec06-14bb-29c4-7b6a-21b060a88de8@oracle.com>
Date: Tue, 26 Jan 2021 10:47:13 +0000
In-Reply-To: <20210126103502.260758-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v2] virtiofsd: prevent opening of special
 files (CVE-2020-35517)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org
Cc: Daniel Berrange <berrange@redhat.com>, P J P <ppandit@redhat.com>, virtio-fs@redhat.com, Alex Xu <alex@alxu.ca>, Laszlo Ersek <lersek@redhat.com>, vgoyal@redhat.com

On 26/01/2021 10:35, Stefan Hajnoczi wrote:
> A well-behaved FUSE client does not attempt to open special files with
> FUSE_OPEN because they are handled on the client side (e.g. device nodes
> are handled by client-side device drivers).
> 
> The check to prevent virtiofsd from opening special files is missing in
> a few cases, most notably FUSE_OPEN. A malicious client can cause
> virtiofsd to open a device node, potentially allowing the guest to
> escape. This can be exploited by a modified guest device driver. It is
> not exploitable from guest userspace since the guest kernel will handle
> special files inside the guest instead of sending FUSE requests.
> 
> This patch adds the missing checks to virtiofsd. This is a short-term
> solution because it does not prevent a compromised virtiofsd process
> from opening device nodes on the host.
> 
> Reported-by: Alex Xu <alex@alxu.ca>
> Fixes: CVE-2020-35517


Should this also explicitly

Cc: qemu-stable@nongnu.org

Or would only a long-term fix target that?

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>

> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Reviewed-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
> v2:
>   * Add doc comment clarifying that symlinks are traversed client-side
>     [Daniel]
> 
> This issue was diagnosed on public IRC and is therefore already known
> and not embargoed.
> 
> A stronger fix, and the long-term solution, is for users to mount the
> shared directory and any sub-mounts with nodev, as well as nosuid and
> noexec. Unfortunately virtiofsd cannot do this automatically because
> bind mounts added by the user after virtiofsd has launched would not be
> detected. I suggest the following:
> 
> 1. Modify libvirt and Kata Containers to explicitly set these mount
>     options.
> 2. Then modify virtiofsd to check that the shared directory has the
>     necessary options at startup. Refuse to start if the options are
>     missing so that the user is aware of the security requirements.
> 
> As a bonus this also increases the likelihood that other host processes
> besides virtiofsd will be protected by nosuid/noexec/nodev so that a
> malicious guest cannot drop these files in place and then arrange for a
> host process to come across them.
> 
> Additionally, user namespaces have been discussed. They seem like a
> worthwhile addition as an unprivileged or privilege-separated mode
> although there are limitations with respect to security xattrs and the
> actual uid/gid stored on the host file system not corresponding to the
> guest uid/gid.
> ---
>   tools/virtiofsd/passthrough_ll.c | 85 +++++++++++++++++++++-----------
>   1 file changed, 57 insertions(+), 28 deletions(-)
> 

