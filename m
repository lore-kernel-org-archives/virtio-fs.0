Date: Tue, 20 Apr 2021 09:19:25 +0200
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210420091925.08054e8b@bahia.lan>
In-Reply-To: <20210419213636.1514816-2-vgoyal@redhat.com>
References: <20210419213636.1514816-1-vgoyal@redhat.com>
	<20210419213636.1514816-2-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v3 1/3] dax: Add an enum for specifying dax
 wakup mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jack@suse.cz, miklos@szeredi.hu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, willy@infradead.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, dan.j.williams@intel.com

On Mon, 19 Apr 2021 17:36:34 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> Dan mentioned that he is not very fond of passing around a boolean true/false
> to specify if only next waiter should be woken up or all waiters should be
> woken up. He instead prefers that we introduce an enum and make it very
> explicity at the callsite itself. Easier to read code.
> 
> This patch should not introduce any change of behavior.
> 
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---

Reviewed-by: Greg Kurz <groug@kaod.org>

>  fs/dax.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index b3d27fdc6775..00978d0838b1 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -144,6 +144,16 @@ struct wait_exceptional_entry_queue {
>  	struct exceptional_entry_key key;
>  };
>  
> +/**
> + * enum dax_entry_wake_mode: waitqueue wakeup toggle
> + * @WAKE_NEXT: entry was not mutated
> + * @WAKE_ALL: entry was invalidated, or resized
> + */
> +enum dax_entry_wake_mode {
> +	WAKE_NEXT,
> +	WAKE_ALL,
> +};
> +
>  static wait_queue_head_t *dax_entry_waitqueue(struct xa_state *xas,
>  		void *entry, struct exceptional_entry_key *key)
>  {
> @@ -182,7 +192,8 @@ static int wake_exceptional_entry_func(wait_queue_entry_t *wait,
>   * The important information it's conveying is whether the entry at
>   * this index used to be a PMD entry.
>   */
> -static void dax_wake_entry(struct xa_state *xas, void *entry, bool wake_all)
> +static void dax_wake_entry(struct xa_state *xas, void *entry,
> +			   enum dax_entry_wake_mode mode)
>  {
>  	struct exceptional_entry_key key;
>  	wait_queue_head_t *wq;
> @@ -196,7 +207,7 @@ static void dax_wake_entry(struct xa_state *xas, void *entry, bool wake_all)
>  	 * must be in the waitqueue and the following check will see them.
>  	 */
>  	if (waitqueue_active(wq))
> -		__wake_up(wq, TASK_NORMAL, wake_all ? 0 : 1, &key);
> +		__wake_up(wq, TASK_NORMAL, mode == WAKE_ALL ? 0 : 1, &key);
>  }
>  
>  /*
> @@ -268,7 +279,7 @@ static void put_unlocked_entry(struct xa_state *xas, void *entry)
>  {
>  	/* If we were the only waiter woken, wake the next one */
>  	if (entry && !dax_is_conflict(entry))
> -		dax_wake_entry(xas, entry, false);
> +		dax_wake_entry(xas, entry, WAKE_NEXT);
>  }
>  
>  /*
> @@ -286,7 +297,7 @@ static void dax_unlock_entry(struct xa_state *xas, void *entry)
>  	old = xas_store(xas, entry);
>  	xas_unlock_irq(xas);
>  	BUG_ON(!dax_is_locked(old));
> -	dax_wake_entry(xas, entry, false);
> +	dax_wake_entry(xas, entry, WAKE_NEXT);
>  }
>  
>  /*
> @@ -524,7 +535,7 @@ static void *grab_mapping_entry(struct xa_state *xas,
>  
>  		dax_disassociate_entry(entry, mapping, false);
>  		xas_store(xas, NULL);	/* undo the PMD join */
> -		dax_wake_entry(xas, entry, true);
> +		dax_wake_entry(xas, entry, WAKE_ALL);
>  		mapping->nrexceptional--;
>  		entry = NULL;
>  		xas_set(xas, index);
> @@ -937,7 +948,7 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
>  	xas_lock_irq(xas);
>  	xas_store(xas, entry);
>  	xas_clear_mark(xas, PAGECACHE_TAG_DIRTY);
> -	dax_wake_entry(xas, entry, false);
> +	dax_wake_entry(xas, entry, WAKE_NEXT);
>  
>  	trace_dax_writeback_one(mapping->host, index, count);
>  	return ret;

