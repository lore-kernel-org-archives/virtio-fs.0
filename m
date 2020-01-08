Date: Wed, 8 Jan 2020 10:50:02 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200108155002.GE1995@redhat.com>
References: <20200108152425.GD1995@redhat.com>
	<CAOssrKdomzxQsMh3FeQYN+HdLt-MSoZOi_MnWAbbf3P=U8ToPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKdomzxQsMh3FeQYN+HdLt-MSoZOi_MnWAbbf3P=U8ToPA@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Enable xattr support by default
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On Wed, Jan 08, 2020 at 04:42:46PM +0100, Miklos Szeredi wrote:
> On Wed, Jan 8, 2020 at 4:24 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > Enable xattr support by default. Currently it is disabled by defaut
> > and that makes getfattr/setfattr fail in guest.
> 
> I think the reason this was disabled by default is that it's a
> significant performance hit for "ls" due to missing xattr caching.
> Not sure how much it affects other workloads.
> 

Aha... so this is intentional and not just an oversight. So maybe we can
leave it disabled by default for now and let people enable it as need be
(-o xattr).

Thanks
Vivek

