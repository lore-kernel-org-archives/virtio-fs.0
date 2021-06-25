DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com; 
	s=selector2-intel-onmicrosoft-com;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=k3lo2yECSxCVf5ZNM+dwpjDz8AQHQyBFPtCQ/lM0kEc=;
	b=J7rFAVBfThfDlQG8+ZixhB6JxBUak2KdhF4Eb/NFsF/4kXIIWSxugEl9ZAtRsqAPDma6cTWo0xLlUEKrNPMcaJ2wMq+qBHz7JmNR10UQTZC8DqjjGrQI/huRyxcjZ+UG2zAwCowUM8MLOixfonrzqkDNfHTiYkd7TbqqFtdEq0k=
From: "Schaufler, Casey" <casey.schaufler@intel.com>
Date: Fri, 25 Jun 2021 21:49:51 +0000
Message-ID: <BN0PR11MB57275823CE05DED7BC755460FD069@BN0PR11MB5727.namprd11.prod.outlook.com>
References: <20210625191229.1752531-1-vgoyal@redhat.com>
In-Reply-To: <20210625191229.1752531-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [RFC PATCH 0/1] xattr: Allow user.* xattr on
 symlink/special files if caller has CAP_SYS_RESOURCE
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Cc: "berrange@redhat.com" <berrange@redhat.com>, "selinux@vger.kernel.org" <selinux@vger.kernel.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, linux-security-module <linux-security-module@vger.kernel.org>, "casey@schaufler-ca.com" <casey@schaufler-ca.com>

> -----Original Message-----
> From: Vivek Goyal <vgoyal@redhat.com>
> Sent: Friday, June 25, 2021 12:12 PM
> To: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
> viro@zeniv.linux.org.uk
> Cc: virtio-fs@redhat.com; dwalsh@redhat.com; dgilbert@redhat.com;
> berrange@redhat.com; vgoyal@redhat.com

Please include Linux Security Module list <linux-security-module@vger.kernel.org>
and selinux@vger.kernel.org on this topic.

> Subject: [RFC PATCH 0/1] xattr: Allow user.* xattr on symlink/special files if
> caller has CAP_SYS_RESOURCE
> 
> Hi,
> 
> In virtiofs, actual file server is virtiosd daemon running on host.
> There we have a mode where xattrs can be remapped to something else.
> For example security.selinux can be remapped to
> user.virtiofsd.securit.selinux on the host.

This would seem to provide mechanism whereby a user can violate
SELinux policy quite easily. 

> 
> This remapping is useful when SELinux is enabled in guest and virtiofs
> as being used as rootfs. Guest and host SELinux policy might not match
> and host policy might deny security.selinux xattr setting by guest
> onto host. Or host might have SELinux disabled and in that case to
> be able to set security.selinux xattr, virtiofsd will need to have
> CAP_SYS_ADMIN (which we are trying to avoid). Being able to remap
> guest security.selinux (or other xattrs) on host to something else
> is also better from security point of view.

Can you please provide some rationale for this assertion?
I have been working with security xattrs longer than anyone
and have trouble accepting the statement.

> But when we try this, we noticed that SELinux relabeling in guest
> is failing on some symlinks. When I debugged a little more, I
> came to know that "user.*" xattrs are not allowed on symlinks
> or special files.
> 
> "man xattr" seems to suggest that primary reason to disallow is
> that arbitrary users can set unlimited amount of "user.*" xattrs
> on these files and bypass quota check.
> 
> If that's the primary reason, I am wondering is it possible to relax
> the restrictions if caller has CAP_SYS_RESOURCE. This capability
> allows caller to bypass quota checks. So it should not be
> a problem atleast from quota perpective.
> 
> That will allow me to give CAP_SYS_RESOURCE to virtiofs deamon
> and remap xattrs arbitrarily.

On a Smack system you should require CAP_MAC_ADMIN to remap
security. xattrs. I sounds like you're in serious danger of running afoul
of LSM attribute policy on a reasonable general level.

> 
> Thanks
> Vivek
> 
> Vivek Goyal (1):
>   xattr: Allow user.* xattr on symlink/special files with
>     CAP_SYS_RESOURCE
> 
>  fs/xattr.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --
> 2.25.4


