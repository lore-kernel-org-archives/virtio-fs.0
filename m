DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1635341000;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=o/3Nbz49/kyQ2NEUZpXzOGtQ57B0/FoxfakRAxW6Cek=;
	b=z79qK7ImJM9M3P0lN+P+TvwlZtk/o3DnybsO7hyOOwmdvvs41paBEdtSP+NcYUyqE3corR
	e5s66EYhw4IhKabsTDEkW4lAysMXPQAYeIZJSPNDqc7GaobU7fbuXbU8XMYZMIcXHshdQW
	2ESKiKGRFCf01Upmi5QTCEdMA+5Ffi4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1635341000;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=o/3Nbz49/kyQ2NEUZpXzOGtQ57B0/FoxfakRAxW6Cek=;
	b=XOERzLFZuhMxAo6qingMdKXRnYFUzy5dEBlNzYCVL2lwyjpZ/6xK3aOigRB07UPV0m6J9m
	sCm+X2hCwUcJy2Cw==
Date: Wed, 27 Oct 2021 15:23:19 +0200
From: Jan Kara <jack@suse.cz>
Message-ID: <20211027132319.GA7873@quack2.suse.cz>
References: <20211025204634.2517-1-iangelak@redhat.com>
	<CAOQ4uxieK3KpY7pf0YTKcrNHW7rnTATTDZdK9L4Mqy32cDwV8w@mail.gmail.com>
	<YXgqRb21hvYyI69D@redhat.com>
	<CAOQ4uxhpCKK2MYxSmRJYYMEWaHKy5ezyKgxaM+YAKtpjsZkD-g@mail.gmail.com>
	<YXhIm3mOvPsueWab@redhat.com>
	<CAO17o20sdKAWQN6w7Oe0Ze06qcK+J=6rrmA_aWGnY__MRVDCKw@mail.gmail.com>
	<CAOQ4uxhA+f-GZs-6SwNtSYZvSwfsYz4_=8_tWAUqt9s-49bqLw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhA+f-GZs-6SwNtSYZvSwfsYz4_=8_tWAUqt9s-49bqLw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [RFC PATCH 0/7] Inotify support in FUSE and virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Steve French <sfrench@samba.org>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, linux-kernel <linux-kernel@vger.kernel.org>, virtio-fs-list <virtio-fs@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Wed 27-10-21 08:59:15, Amir Goldstein wrote:
> On Tue, Oct 26, 2021 at 10:14 PM Ioannis Angelakopoulos
> <iangelak@redhat.com> wrote:
> > On Tue, Oct 26, 2021 at 2:27 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > The problem here is that the OPEN event might still be travelling towards the guest in the
> > virtqueues and arrives after the guest has already deleted its local inode.
> > While the remote event (OPEN) received by the guest is valid, its fsnotify
> > subsystem will drop it since the local inode is not there.
> >
> 
> I have a feeling that we are mixing issues related to shared server
> and remote fsnotify.

I don't think Ioannis was speaking about shared server case here. I think
he says that in a simple FUSE remote notification setup we can loose OPEN
events (or basically any other) if the inode for which the event happens
gets deleted sufficiently early after the event being generated. That seems
indeed somewhat unexpected and could be confusing if it happens e.g. for
some directory operations.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

