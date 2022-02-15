Date: Tue, 15 Feb 2022 12:27:46 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YgvikrLzWLfVAePx@redhat.com>
References: <20220214135820.43897-1-groug@kaod.org>
	<20220214135820.43897-4-groug@kaod.org>
	<YgqfCtcjhApw5Fyw@redhat.com> <YgqlyP5M7NF/bMoj@redhat.com>
	<Ygqo+24vo1z7rSvk@redhat.com> <20220215101803.14206a48@bahia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215101803.14206a48@bahia>
Subject: Re: [Virtio-fs] [PATCH v5 3/3] virtiofsd: Add support for
 FUSE_SYNCFS request without announce_submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Tue, Feb 15, 2022 at 10:18:03AM +0100, Greg Kurz wrote:
> On Mon, 14 Feb 2022 14:09:47 -0500
> Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > On Mon, Feb 14, 2022 at 01:56:08PM -0500, Vivek Goyal wrote:
> > > On Mon, Feb 14, 2022 at 01:27:22PM -0500, Vivek Goyal wrote:
> > > > On Mon, Feb 14, 2022 at 02:58:20PM +0100, Greg Kurz wrote:
> > > > > This adds the missing bits to support FUSE_SYNCFS in the case submounts
> > > > > aren't announced to the client.
> > > > > 
> > > > > Iterate over all inodes and call syncfs() on the ones marked as submounts.
> > > > > Since syncfs() can block for an indefinite time, we cannot call it with
> > > > > lo->mutex held as it would prevent the server to process other requests.
> > > > > This is thus broken down in two steps. First build a list of submounts
> > > > > with lo->mutex held, drop the mutex and finally process the list. A
> > > > > reference is taken on the inodes to ensure they don't go away when
> > > > > lo->mutex is dropped.
> > > > > 
> > > > > Signed-off-by: Greg Kurz <groug@kaod.org>
> > > > > ---
> > > > >  tools/virtiofsd/passthrough_ll.c | 38 ++++++++++++++++++++++++++++++--
> > > > >  1 file changed, 36 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> > > > > index e94c4e6f8635..7ce944bfe2a0 100644
> > > > > --- a/tools/virtiofsd/passthrough_ll.c
> > > > > +++ b/tools/virtiofsd/passthrough_ll.c
> > > > > @@ -3400,8 +3400,42 @@ static void lo_syncfs(fuse_req_t req, fuse_ino_t ino)
> > > > >          err = lo_do_syncfs(lo, inode);
> > > > >          lo_inode_put(lo, &inode);
> > > > >      } else {
> > > > > -        /* Requires the sever to track submounts. Not implemented yet */
> > > > > -        err = ENOSYS;
> > > > > +        g_autoptr(GSList) submount_list = NULL;
> > > > > +        GSList *elem;
> > > > > +        GHashTableIter iter;
> > > > > +        gpointer key, value;
> > > > > +
> > > > > +        pthread_mutex_lock(&lo->mutex);
> > > > > +
> > > > > +        g_hash_table_iter_init(&iter, lo->inodes);
> > > > > +        while (g_hash_table_iter_next(&iter, &key, &value)) {
> > > > 
> > > > Going through all the inodes sounds very inefficient. If there are large
> > > > number of inodes (say 1 million or more), and if frequent syncfs requests
> > > > are coming this can consume lot of cpu cycles.
> > > > 
> > > > Given C virtiofsd is slowly going away, so I don't want to be too
> > > > particular about it. But, I would have thought to put submount
> > > > inodes into another list or hash map (using mount id as key) and just
> > > > traverse through that list instead. Given number of submounts should
> > > > be small, it should be pretty quick to walk through that list.
> > > > 
> > > > > +            struct lo_inode *inode = value;
> > > > > +
> > > > > +            if (inode->is_submount) {
> > > > > +                g_atomic_int_inc(&inode->refcount);
> > > > > +                submount_list = g_slist_prepend(submount_list, inode);
> > > > > +            }
> > > > > +        }
> > > > > +
> > > > > +        pthread_mutex_unlock(&lo->mutex);
> > > > > +
> > > > > +        /* The root inode is always present and not tracked in the hash table */
> > > > > +        err = lo_do_syncfs(lo, &lo->root);
> > > > > +
> > > > > +        for (elem = submount_list; elem; elem = g_slist_next(elem)) {
> > > > > +            struct lo_inode *inode = elem->data;
> > > > > +            int r;
> > > > > +
> > > > > +            r = lo_do_syncfs(lo, inode);
> > > > > +            if (r) {
> > > > > +                /*
> > > > > +                 * Try to sync as much as possible. Only one error can be
> > > > > +                 * reported to the client though, arbitrarily the last one.
> > > > > +                 */
> > > > > +                err = r;
> > > > > +            }
> > > > > +            lo_inode_put(lo, &inode);
> > > > > +        }
> > > > 
> > > > One more minor nit. What happens if virtiofsd is processing syncfs list
> > > > and then somebody hard reboots qemu and mounts virtiofs again. That
> > > > will trigger FUSE_INIT and will call lo_destroy() first.
> > > > 
> > > > fuse_lowlevel.c
> > > > 
> > > > fuse_session_process_buf_int()
> > > > {
> > > >             fuse_log(FUSE_LOG_DEBUG, "%s: reinit\n", __func__);
> > > >             se->got_destroy = 1;
> > > >             se->got_init = 0;
> > > >             if (se->op.destroy) {
> > > >                 se->op.destroy(se->userdata);
> > > >             }
> > > > }
> > > > 
> > > > IIUC, there is no synchronization with this path. If we are running with
> > > > thread pool enabled, it could very well happen that one thread is still
> > > > doing syncfs while other thread is executing do_init(). That sounds
> > > > like little bit of a problem. It will be good if there is a way
> > > > to either abort syncfs() or do_destroy() waits for all the previous
> > > > syncfs() to finish.
> > > > 
> > > > Greg, if you like, you could break down this work in two patch series.
> > > > First patch series just issues syncfs() on inode id sent with FUSE_SYNCFS.
> > > > That's easy fix and can get merged now.
> > > 
> > > Actually I think even single "syncfs" will have synchronization issue
> > > with do_init() upon hard reboot if we drop lo->mutex during syncfs().
> > 
> > Actually, we have similar issues with ->fsync(). We take lo->mutex,
> > and then take a reference on inode. Call fsync() on this. Now it is
> > possible that guest hard reboots, triggers, FUSE_INIT and lo_destroy()
> > is called. It will take lo->mutex and drop its referene on inode.
> > 
> > So it looks like in extreme case a new connection can start looking
> > up inodes which we still have old inodes in hash table because
> > some thread is blocked doing operation and has not dropped its
> > reference.
> > 
> > David, do I understand it right?
> > 
> > We probably need to have a notion of keeping track of number of requests
> > which are in progress. And lo_destroy() should wait till number of
> > requests in progress come to zero. This will be equivalent of draining
> > the queues operation in virtiofs kernel driver.
> > 
> > Anyway, given we already have the issue w.r.t lo_destroy(), and C code
> > is going away, I will be fine even if you don't fix races with FUSE_INIT.
> > 
> > Vivek
> 
> As you pointed out, this can affect other type of requests as well, so
> this would probably deserve a more generic fix than just making it
> work for syncfs(). This would most likely call for cycles that I don't
> have. Thanks ! ;-)
> 
> BTW, does the rust implementation have the same flaw ?

I don't think Rust implementation drops any locks at all while syncfs()
is called. So next FUSE_INIT might just serialize completely and
wait for syncfs() to finish first. But don't quote me on this because
I don't understand rust virtiofsd locking well yet. It is more of a 
guess.

Vivek

> 
> > > 
> > > Vivek
> > > 
> > > > 
> > > > And second patch series take care of above issues and will be little bit
> > > > more work.
> > > > 
> > > > Thanks
> > > > Vivek
> > 
> 

