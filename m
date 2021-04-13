MIME-Version: 1.0
References: <47a35ffe-ef39-d098-2c29-34cf7d4eb7ef@redhat.com>
	<20210413140544.GD1235549@redhat.com>
	<0985ca36-2ba5-9913-99a2-a887d0eb96d2@redhat.com>
	<20210413145610.GG1235549@redhat.com>
In-Reply-To: <20210413145610.GG1235549@redhat.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Tue, 13 Apr 2021 17:10:14 +0200
Message-ID: <CAOssrKczuf5+P8nwYHOFMEP4vg=Zb0i8V1hQap7iKPwCJXfwLQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] Current file handle status and open questions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Max Reitz <mreitz@redhat.com>

On Tue, Apr 13, 2021 at 4:57 PM Vivek Goyal <vgoyal@redhat.com> wrote:

> I thought we are giving CAP_DAC_READ_SEARCH but I guest checked current
> source code and CAP_DAC_READ_SEARCH is not in the list. So that means
> either we or user will have to give it explicitly.

Looking at generic_permission() it appears that CAP_DAC_READ_SEARCH
gives a subset of CAP_DAC_OVERRIDE capabilities.  So it seems quite
safe at this point to enable CAP_DAC_READ_SEARCH too.

Thanks,
Miklos

