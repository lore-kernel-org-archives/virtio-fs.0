DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=v06lta4MYVBJBZLQ73bBpIez3Zzb0/6n6ZDJgeZvvFA=;
	b=Hc9GLAgOOnaaXsF3NrbM7AecX7f3q0LEmVqWdNl+cCygzK/RxeejM05rD+PoBYvpNy
	iCfIvK00i3nYnz/7hEF1IyoD0raYoTA0Fi7pIXSNsQiydr+b2RWwANqNTLEGdoi4TVze
	EI0HrSen2CJeJvMGU2pb8OzX9tm5amIQIkLoI=
MIME-Version: 1.0
References: <20190821173742.24574-1-vgoyal@redhat.com>
In-Reply-To: <20190821173742.24574-1-vgoyal@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 29 Aug 2019 11:28:27 +0200
Message-ID: <CAJfpegv_XS=kLxw_FzWNM2Xao5wsn7oGbk3ow78gU8tpXwo-sg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH v3 00/13] virtio-fs: shared file system for
	virtual machines
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org

On Wed, Aug 21, 2019 at 7:38 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Hi,
>
> Here are the V3 patches for virtio-fs filesystem. This time I have
> broken the patch series in two parts. This is first part which does
> not contain DAX support. Second patch series will contain the patches
> for DAX support.
>
> I have also dropped RFC tag from first patch series as we believe its
> in good enough shape that it should get a consideration for inclusion
> upstream.

Pushed out to

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git#for-next

Major changes compared to patchset:

 - renamed to "virtiofs".  Filesystem names don't usually have
underscore before "fs" postfix.

 - removed option parsing completely.  Virtiofs config is fixed to "-o
rootmode=040000,user_id=0,group_id=0,allow_other,default_permissions".
Does this sound reasonable?

There are miscellaneous changes, so needs to be thoroughly tested.

I think we also need something in
"Documentation/filesystems/virtiofs.rst" which describes the design
(how  request gets to userspace and back) and how to set up the
server, etc...  Stefan, Vivek can you do something like that?

Thanks,
Miklos

