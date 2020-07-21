DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=sAystsUrInZeIyvgRCsT3l9cU39g2GRQq1EYFX9E4bg=;
	b=S4+t+rbjdOqBhu/c2PKCReBBiCDKjC8SDuFsSpoO9iJO8s57ckBcaGRgGLeEi61rnU
	j2pMUWya4frGQvlqFU83oJtS5W0Cd1VtRd5RG5yEIYt2JCXDToWXlUn1b11n8OQAj+O+
	4VOQp70DZVK4Fl51pJOzSGaZcSB0BF+zojZFE=
MIME-Version: 1.0
References: <20200713090921.312962-1-chirantan@chromium.org>
	<20200713095700.350234-1-chirantan@chromium.org>
	<20200713095700.350234-2-chirantan@chromium.org>
	<CAJFHJrqEU=k2dLkKAD-SsKwkVeQ3KPf5wveph9u86BxdbM7q8w@mail.gmail.com>
In-Reply-To: <CAJFHJrqEU=k2dLkKAD-SsKwkVeQ3KPf5wveph9u86BxdbM7q8w@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 21 Jul 2020 16:23:24 +0200
Message-ID: <CAJfpegsOgZfWAoe6x4vH+NoWbyEys2ruRYRRhJhhwwxS2brweQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCHv4 2/2] fuse: Call security hooks on new
	inodes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>, Suleiman Souhlal <suleiman@chromium.org>, virtio-fs-list <virtio-fs@redhat.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Dylan Reid <dgreid@chromium.org>, Vivek Goyal <vgoyal@redhat.com>

On Tue, Jul 21, 2020 at 10:07 AM Chirantan Ekbote
<chirantan@chromium.org> wrote:
>
> On Mon, Jul 13, 2020 at 6:57 PM Chirantan Ekbote <chirantan@chromium.org> wrote:
> >
> > Add a new `init_security` field to `fuse_conn` that controls whether we
> > initialize security when a new inode is created.  Set this to true when
> > the `flags` field of the fuse_init_out struct contains
> > FUSE_SECURITY_CTX.
> >
> > When set to true, get the security context for a newly created inode via
> > `security_dentry_init_security` and append it to the create, mkdir,
> > mknod, and symlink requests.
> >
>
> Are there any other concerns with this patch? Or can I expect that it
> will get merged eventually?

Looks good to me.  Can you resend with the security/selinux folks in the CC?

Thanks,
Miklos

