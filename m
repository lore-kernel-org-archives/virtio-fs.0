MIME-Version: 1.0
References: <34a26a91-c73d-18cb-95ad-9b2c6192091c@redhat.com>
	<CAOssrKcY7o_LOabLiy+86LFZ1aQdqq8EOaM=qjRqHKGUqRup6w@mail.gmail.com>
	<2d94bc7c-e999-44b1-7813-6269cbfcf54e@redhat.com>
	<CAOssrKeVf-8pNyFuyVpTTUZbMaU9N8E-Q3-p7xfa=gsmQYk-1A@mail.gmail.com>
	<2622824d-5f59-0d4a-635b-4257ee7cab3c@redhat.com>
	<CAOssrKdn-RkxK4DjRy_36se=oE4edL3Yq5FsY3SknV-cYEY9Jg@mail.gmail.com>
	<fc44b1ac-6b9a-14c5-42f5-f7fc50fbfb74@redhat.com>
	<20210317131906.GB324911@redhat.com>
In-Reply-To: <20210317131906.GB324911@redhat.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Wed, 17 Mar 2021 16:13:37 +0100
Message-ID: <CAOssrKdnsRph+a1_qP_z2QT0i4NourtotUovdpV2uDDVKcN7Pw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] Securing file handles
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, "Howells,
	David" <dhowells@redhat.com>, Max Reitz <mreitz@redhat.com>

[CC] David Howells.

On Wed, Mar 17, 2021 at 2:19 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Tue, Mar 16, 2021 at 06:28:24PM +0100, Max Reitz wrote:

> > One thing that also needs to be solved is how to specify a persistent key.
> > I suppose the idea in your patch is to generate a random key for every new
> > process, but we would need a persistent key.  With a service process, it
> > could be configured by the user to use a specific key, or perhaps it has
> > kind of small database and virtiofsd selects its persistent key by a hash of
> > it or some other ID that it has received from the service process.
> >
> > I don’t know how you’d go making the kernel store persistent keys, though.
>
> Is it possible to load persistent key from user space into a keyring
> using keyctl.

Context for David:

We'd like unprivileged open_by_handle_at(2).   One idea is for the
kernel to authenticate file handles (add an authentication header)
using a secret key, so that unprivileged open_by_handle_at() only
works on handles obtained through file_to_handle_at(), and will reject
any maliciously crafted file handles.

So the question is how the authentication keys should be managed.

The unprivileged process must not have access to the key, obviously,
but it should be possible to save the key across restarts.

Any ideas?

Thanks,
Miklos


