DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=+wm+1SxyPhgZ2xyPaqVHOlIIYUpLoXtqsuq+0VC3Sjc=;
	b=moj6OWG2vw6GntXNWeTQgm7Smvy1QpBa4fBHcAMupAuzUukRol/FdrWgU5z93l3NPQ
	6MKcKRVOHIc1gnlY06/SaTKFIeV+7N4mqBXunJXSVgBRCYLv1sIi2A1t7PSoceroEu42
	nlrzfwR/cKNVYtbEIrt0+iEauNFt1iHYtCXY0=
MIME-Version: 1.0
References: <20210902152228.665959-1-vgoyal@redhat.com>
	<CAHc6FU4foW+9ZwTRis3DXSJSMAvdb4jXcq7EFFArYgX7FQ1QYg@mail.gmail.com>
	<YTYoEDT+YOtCHXW0@work-vm>
In-Reply-To: <YTYoEDT+YOtCHXW0@work-vm>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 6 Sep 2021 16:56:44 +0200
Message-ID: <CAJfpegvbkmdneMxMjYMuNM4+RmWT8S7gaTiDzaq+TCzb0UrQrw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v3 0/1] Relax restrictions on user.* xattr
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Giuseppe Scrivano <gscrivan@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, SElinux list <selinux@vger.kernel.org>, Stephen Smalley <stephen.smalley.work@gmail.com>, Dave Chinner <david@fromorbit.com>, LKML <linux-kernel@vger.kernel.org>, virtio-fs-list <virtio-fs@redhat.com>, casey.schaufler@intel.com, LSM <linux-security-module@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Fields,
	Bruce" <bfields@redhat.com>, Christian Brauner <christian.brauner@ubuntu.com>, Vivek Goyal <vgoyal@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>

On Mon, 6 Sept 2021 at 16:39, Dr. David Alan Gilbert
<dgilbert@redhat.com> wrote:

> IMHO the real problem here is that the user/trusted/system/security
> 'namespaces' are arbitrary hacks rather than a proper namespacing
> mechanism that allows you to create new (nested) namespaces and associate
> permissions with each one.

Indeed.

This is what Eric Biederman suggested at some point for supporting
trusted xattrs within a user namespace:

| For trusted xattrs I think it makes sense in principle.   The namespace
| would probably become something like "trusted<ns-root-uid>.".

Theory sounds simple enough.  Anyone interested in looking at the details?

Thanks,
Miklos

