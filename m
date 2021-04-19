DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=intel-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=0pRdHORbMnYGgpAEqFhWtNH9/sxU/zrFmn1etVSS8ec=;
	b=pbgttAEz2va7NMNY0DPCjAIrN3cvwgh1vLPTHCTYGogu5LS30biP0lrPVzo2ndKVug
	c910hP3lyskv2p9CsZZmtyPWoONAJwqaunWQvnjFhjIX0Q5yZ5SChmgdBzPdhSyUJoj1
	N3Sg+EygRrSverxWz+odjeJVoGWYQmzDyrbb4Xso5/JC8GcrmocAQUAI9cAzpzoQutzT
	2xRp+1GLcu4i3ZpQVcRvSUUEnMYkP6bhFS1FBvK2WyY2dmofMG+PRGN1HZzKDoVhs+od
	o9kzI7900pFwR78M2AFerahttXmuiaLedpc5P76RshFxO1Y3+hRfMsGLOUEcZgyZvF35
	hCSQ==
MIME-Version: 1.0
References: <20210419184516.GC1472665@redhat.com>
In-Reply-To: <20210419184516.GC1472665@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 19 Apr 2021 12:48:58 -0700
Message-ID: <CAPcyv4jR5d+-99wVMm9SHxNBOsp0FUi7wzDNsefkZ1oqUZ7joQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [Virtio-fs] [PATCH][v2] dax: Fix missed wakeup during dax entry
	invalidation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux kernel mailing list <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, virtio-fs-list <virtio-fs@redhat.com>, Linux fsdevel mailing list <linux-fsdevel@vger.kernel.org>

On Mon, Apr 19, 2021 at 11:45 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> This is V2 of the patch. Posted V1 here.
>
> https://lore.kernel.org/linux-fsdevel/20210416173524.GA1379987@redhat.com/
>
> Based on feedback from Dan and Jan, modified the patch to wake up
> all waiters when dax entry is invalidated. This solves the issues
> of missed wakeups.

Care to send a formal patch with this commentary moved below the --- line?

One style fixup below...

>
> I am seeing missed wakeups which ultimately lead to a deadlock when I am
> using virtiofs with DAX enabled and running "make -j". I had to mount
> virtiofs as rootfs and also reduce to dax window size to 256M to reproduce
> the problem consistently.
>
> So here is the problem. put_unlocked_entry() wakes up waiters only
> if entry is not null as well as !dax_is_conflict(entry). But if I
> call multiple instances of invalidate_inode_pages2() in parallel,
> then I can run into a situation where there are waiters on
> this index but nobody will wait these.
>
> invalidate_inode_pages2()
>   invalidate_inode_pages2_range()
>     invalidate_exceptional_entry2()
>       dax_invalidate_mapping_entry_sync()
>         __dax_invalidate_entry() {
>                 xas_lock_irq(&xas);
>                 entry = get_unlocked_entry(&xas, 0);
>                 ...
>                 ...
>                 dax_disassociate_entry(entry, mapping, trunc);
>                 xas_store(&xas, NULL);
>                 ...
>                 ...
>                 put_unlocked_entry(&xas, entry);
>                 xas_unlock_irq(&xas);
>         }
>
> Say a fault in in progress and it has locked entry at offset say "0x1c".
> Now say three instances of invalidate_inode_pages2() are in progress
> (A, B, C) and they all try to invalidate entry at offset "0x1c". Given
> dax entry is locked, all tree instances A, B, C will wait in wait queue.
>
> When dax fault finishes, say A is woken up. It will store NULL entry
> at index "0x1c" and wake up B. When B comes along it will find "entry=0"
> at page offset 0x1c and it will call put_unlocked_entry(&xas, 0). And
> this means put_unlocked_entry() will not wake up next waiter, given
> the current code. And that means C continues to wait and is not woken
> up.
>
> This patch fixes the issue by waking up all waiters when a dax entry
> has been invalidated. This seems to fix the deadlock I am facing
> and I can make forward progress.
>
> Reported-by: Sergio Lopez <slp@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/dax.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> Index: redhat-linux/fs/dax.c
> ===================================================================
> --- redhat-linux.orig/fs/dax.c  2021-04-16 14:16:44.332140543 -0400
> +++ redhat-linux/fs/dax.c       2021-04-19 11:24:11.465213474 -0400
> @@ -264,11 +264,11 @@ static void wait_entry_unlocked(struct x
>         finish_wait(wq, &ewait.wait);
>  }
>
> -static void put_unlocked_entry(struct xa_state *xas, void *entry)
> +static void put_unlocked_entry(struct xa_state *xas, void *entry, bool wake_all)
>  {
>         /* If we were the only waiter woken, wake the next one */
>         if (entry && !dax_is_conflict(entry))
> -               dax_wake_entry(xas, entry, false);
> +               dax_wake_entry(xas, entry, wake_all);
>  }
>
>  /*
> @@ -622,7 +622,7 @@ struct page *dax_layout_busy_page_range(
>                         entry = get_unlocked_entry(&xas, 0);
>                 if (entry)
>                         page = dax_busy_page(entry);
> -               put_unlocked_entry(&xas, entry);
> +               put_unlocked_entry(&xas, entry, false);

I'm not a fan of raw true/false arguments because if you read this
line in isolation you need to go read put_unlocked_entry() to recall
what that argument means. So lets add something like:

/**
 * enum dax_entry_wake_mode: waitqueue wakeup toggle
 * @WAKE_NEXT: entry was not mutated
 * @WAKE_ALL: entry was invalidated, or resized
 */
enum dax_entry_wake_mode {
        WAKE_NEXT,
        WAKE_ALL,
}

...and use that as the arg for dax_wake_entry(). So I'd expect this to
be a 3 patch series, introduce dax_entry_wake_mode for
dax_wake_entry(), introduce the argument for put_unlocked_entry()
without changing the logic, and finally this bug fix. Feel free to add
'Fixes: ac401cc78242 ("dax: New fault locking")' in case you feel this
needs to be backported.

