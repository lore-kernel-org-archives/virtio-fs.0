DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=+IPm+NVwwklgzGdr0p96zVhLm/FyxrNAAUyP4ry1+WM=;
	b=BFsvtCwmjlnYspd0KU0kqzGIBobdnVtRlgLpZK/MzXz7F/7e3WcFekwmbG+ufA2GMH
	HKmGGsPG6OkvpR0ir5DdtlGcQmZp6nVtJUnBec33SWTIoh0O+EoO4QZNQeFAZ5/DGlBE
	qTHvnlpihkx8RLtuoVZhXIuu5uPRaiFXlvSL8=
MIME-Version: 1.0
References: <20210406140706.GB934253@redhat.com>
In-Reply-To: <20210406140706.GB934253@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 14 Apr 2021 13:25:14 +0200
Message-ID: <CAJfpegvY_xDe0th5L0uSViPauOk7z31eSZzR0+Li9Jh5tBqYRA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH] fuse: Invalidate attrs when page writeback
	completes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, eric.auger@redhat.com

On Tue, Apr 6, 2021 at 4:07 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> In fuse when a direct/write-through write happens we invalidate attrs because
> that might have updated mtime/ctime on server and cached mtime/ctime
> will be stale.
>
> What about page writeback path. Looks like we don't invalidate attrs there.
> To be consistent, invalidate attrs in writeback path as well. Only exception
> is when writeback_cache is enabled. In that case we strust local mtime/ctime
> and there is no need to invalidate attrs.
>
> Recently users started experiencing failure of xfstests generic/080,
> geneirc/215 and generic/614 on virtiofs. This happened only newer
> "stat" utility and not older one. This patch fixes the issue.
>
> So what's the root cause of the issue. Here is detailed explanation.
>
> generic/080 test does mmap write to a file, closes the file and then
> checks if mtime has been updated or not. When file is closed, it
> leads to flushing of dirty pages (and that should update mtime/ctime
> on server). But we did not explicitly invalidate attrs after writeback
> finished. Still generic/080 passed so far and reason being that we
> invalidated atime in fuse_readpages_end(). This is called in fuse_readahead()
> path and always seems to trigger before mmaped write.
>
> So after mmaped write when lstat() is called, it sees that atleast one
> of the fields being asked for is invalid (atime) and that results in
> generating GETATTR to server and mtime/ctime also get updated and test
> passes.
>
> But newer /usr/bin/stat seems to have moved to using statx() syscall now
> (instead of using lstat()). And statx() allows it to query only ctime
> or mtime (and not rest of the basic stat fields). That means when
> querying for mtime, fuse_update_get_attr() sees that mtime is not
> invalid (only atime is invalid). So it does not generate a new GETATTR
> and fill stat with cached mtime/ctime. And that means updated mtime
> is not seen by xfstest and tests start failing.
>
> Invalidating attrs after writeback completion should solve this problem
> in a generic manner.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Thanks, applied.

Miklos

