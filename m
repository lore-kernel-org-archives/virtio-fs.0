DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048;
	t=1597419889; bh=ljMTuwKrqWkkWYdOmTtthmbN/XW+/rs+OF/GwBjGrBw=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject;
	b=ErpnedFsPZRbMGEsJw200Lp0vuzgd1/boPU1Rv+jwRb2wxSEC8ikJ5OThfSO10tR/S32c9QJbLg4y940/5xeUebxB474e6BA42w0CYFVFbLTqZ3B+N26Hn7JF3eBjpz5TQXH9q3ySFFQ+syK+1k6kv2VJ4ziJ9UnI8xT1SdkJ0GTMj2MZyLNZFjwxhyEuHF2aajeKHL3q11/W5fyaJcQSbKnABo+2Kekb8C2Ir1ADdSby+T5LBzfT32HezLFRgQl68O+2NvzAZIT6e9FLBmKDXyh8JCjMMEMARgAyOxs80LnGBWRELnEzpWhIzUIuccCbWeIBCRtJ2VYJkhtHlZ2qw==
References: <20200722090758.3221812-1-chirantan@chromium.org>
	<CAJFHJrr+B=xszNvdkmksG5ULPy_nKpn4_MS9_Pnq6ySkkb5y6g@mail.gmail.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <1dfa1ae5-bb5a-67ea-f38a-b9d9a545dd0a@schaufler-ca.com>
Date: Fri, 14 Aug 2020 08:44:47 -0700
MIME-Version: 1.0
In-Reply-To: <CAJFHJrr+B=xszNvdkmksG5ULPy_nKpn4_MS9_Pnq6ySkkb5y6g@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [RESEND] [PATCHv4 1/2] uapi: fuse: Add
	FUSE_SECURITY_CTX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>, Miklos Szeredi <miklos@szeredi.hu>, Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>, Casey Schaufler <casey@schaufler-ca.com>, Suleiman Souhlal <suleiman@chromium.org>, virtio-fs-list <virtio-fs@redhat.com>, SElinux list <selinux@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Dylan Reid <dgreid@chromium.org>, Vivek Goyal <vgoyal@redhat.com>

On 8/13/2020 10:20 PM, Chirantan Ekbote wrote:
> On Wed, Jul 22, 2020 at 6:09 PM Chirantan Ekbote <chirantan@chromium.org> wrote:
>> Add the FUSE_SECURITY_CTX flag for the `flags` field of the
>> fuse_init_out struct.  When this flag is set the kernel will append the
>> security context for a newly created inode to the request (create,
>> mkdir, mknod, and symlink).  The server is responsible for ensuring that
>> the inode appears atomically with the requested security context.
>>
>> For example, if the server is backed by a "real" linux file system then
>> it can write the security context value to
>> /proc/thread-self/attr/fscreate before making the syscall to create the
>> inode.
>>
> Friendly ping. Will this (and the next patch in the series) be merged into 5.9?

This really needed to go to the LSM List <linux-security-module@vger.kernel.org>.


>
> Chirantan
>
>
> Chirantan

