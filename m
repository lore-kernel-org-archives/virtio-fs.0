DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=mgazO6bfi1JYI28igOU36tjNtPL+9PMTbmUOsnqHc3k=;
	b=EnW+9fdNY+eBqndzJHKsb6d0dgzmLbzhAY9238ZjVsfjJYX1GWzGB9vFtC7AZ+hxQB
	f4hzRal2IH6AvOvLkqN8eT+jd2fLdeRe1ATZq2Ez9im53da7zBIWUBSf0OATMmPTQ6+3
	wjlBBhlAiNyWWPYuH0TT9urGokENEz81z3WEc=
MIME-Version: 1.0
References: <rprnspo3-119s-qnoo-2o93-sn40rq40ns@erqung.pbz>
	<20210114133424.GA299876@stefanha-x1.localdomain>
	<qn527287-65qq-227p-2r48-1528r6rr386@erqung.pbz>
	<20210118165541.GD255498@stefanha-x1.localdomain>
	<9qo964n3-7p75-7992-7s7p-3srrs4q650n@erqung.pbz>
In-Reply-To: <9qo964n3-7p75-7992-7s7p-3srrs4q650n@erqung.pbz>
From: Chirantan Ekbote <chirantan@chromium.org>
Date: Wed, 20 Jan 2021 14:49:52 +0900
Message-ID: <CAJFHJroGX7YYPK2KzxBtM3Pnf7heUxsjZXOvoH0GR7gMrDTuuQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [RFC] About non-root virtiofsd(1) process
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: P J P <ppandit@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On Tue, Jan 19, 2021 at 11:34 PM P J P <ppandit@redhat.com> wrote:
>
> +-- On Mon, 18 Jan 2021, Stefan Hajnoczi wrote --+
> | Guest applications may run with different uids/gids. The host has no control
> | over that.
> |
> | Imagine booting a guest form a virtio-fs root file system and installing
> | packages. The guest must be able to control uids/gids for that to work.
>
> * I see; I'll try to better understand how it's done.
>
> * With UID namespaces, I thought virtiofsd(1) would be able to operate files
>   with arbitrary uid/gid, even after dropping its root privileges to acquire
>   non-root privileges on the host; Because it has 'root' privileges under the
>   shared directory & UID namespace.
>

This is actually what we do in crosvm.  It works pretty well but has a
few limitations:

- Setting up the uidmap and gidmap requires CAP_SETUID and CAP_SETGID
(unless you're only mapping in the current euid/egid) so a user
without sudo access cannot do it.
- The daemon cannot do anything that requires caps in the init
namespace.  For example, it cannot set any security.* or trusted.*
xattrs but that can be worked around by re-mapping them into the
user.* xattr namespace.  Another example is anything to do with
filesystem quotas.  We deal with this by forwarding them to another
daemon running in the init namespace but it's not ideal.

Overall I think we're pretty happy with the user namespace sandbox.  I
think the benefit of dropping all privileges in the init namespace has
been worth the cost of dealing with the limitations we've run into so
far.

Chirantan

