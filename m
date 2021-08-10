References: <20210730150134.216126-1-mreitz@redhat.com>
	<20210730150134.216126-9-mreitz@redhat.com>
	<YRFTWVC1vXwjky5v@redhat.com>
	<467c019d-42b9-1290-72f3-bd96bf44ddcf@redhat.com>
	<YRKIIpOQzXgl4Jax@redhat.com>
From: Hanna Reitz <hreitz@redhat.com>
Message-ID: <915cd307-e3db-1f62-22ac-8caeffd35ca1@redhat.com>
Date: Tue, 10 Aug 2021 16:13:44 +0200
MIME-Version: 1.0
In-Reply-To: <YRKIIpOQzXgl4Jax@redhat.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH v3 08/10] virtiofsd: Add inodes_by_handle
	hash table
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Max Reitz <mreitz@redhat.com>

On 10.08.21 16:07, Vivek Goyal wrote:
> On Mon, Aug 09, 2021 at 06:47:18PM +0200, Hanna Reitz wrote:
>> On 09.08.21 18:10, Vivek Goyal wrote:
>>> On Fri, Jul 30, 2021 at 05:01:32PM +0200, Max Reitz wrote:
>>>> Currently, lo_inode.fhandle is always NULL and so always keep an O_PATH
>>>> FD in lo_inode.fd.  Therefore, when the respective inode is unlinked,
>>>> its inode ID will remain in use until we drop our lo_inode (and
>>>> lo_inode_put() thus closes the FD).  Therefore, lo_find() can safely use
>>>> the inode ID as an lo_inode key, because any inode with an inode ID we
>>>> find in lo_data.inodes (on the same filesystem) must be the exact same
>>>> file.
>>>>
>>>> This will change when we start setting lo_inode.fhandle so we do not
>>>> have to keep an O_PATH FD open.  Then, unlinking such an inode will
>>>> immediately remove it, so its ID can then be reused by newly created
>>>> files, even while the lo_inode object is still there[1].
>>>>
>>>> So creating a new file can then reuse the old file's inode ID, and
>>>> looking up the new file would lead to us finding the old file's
>>>> lo_inode, which is not ideal.
>>>>
>>>> Luckily, just as file handles cause this problem, they also solve it:  A
>>>> file handle contains a generation ID, which changes when an inode ID is
>>>> reused, so the new file can be distinguished from the old one.  So all
>>>> we need to do is to add a second map besides lo_data.inodes that maps
>>>> file handles to lo_inodes, namely lo_data.inodes_by_handle.  For
>>>> clarity, lo_data.inodes is renamed to lo_data.inodes_by_ids.
>>>>
>>>> Unfortunately, we cannot rely on being able to generate file handles
>>>> every time.  Therefore, we still enter every lo_inode object into
>>>> inodes_by_ids, but having an entry in inodes_by_handle is optional.  A
>>>> potential inodes_by_handle entry then has precedence, the inodes_by_ids
>>>> entry is just a fallback.
>>>>
>>>> Note that we do not generate lo_fhandle objects yet, and so we also do
>>>> not enter anything into the inodes_by_handle map yet.  Also, all lookups
>>>> skip that map.  We might manually create file handles with some code
>>>> that is immediately removed by the next patch again, but that would
>>>> break the assumption in lo_find() that every lo_inode with a non-NULL
>>>> .fhandle must have an entry in inodes_by_handle and vice versa.  So we
>>>> leave actually using the inodes_by_handle map for the next patch.
>>>>
>>>> [1] If some application in the guest still has the file open, there is
>>>> going to be a corresponding FD mapping in lo_data.fd_map.  In such a
>>>> case, the inode will only go away once every application in the guest
>>>> has closed it.  The problem described only applies to cases where the
>>>> guest does not have the file open, and it is just in the dentry cache,
>>>> basically.
>>>>
>>>> Signed-off-by: Max Reitz <mreitz@redhat.com>
>>>> ---
>>>>    tools/virtiofsd/passthrough_ll.c | 81 +++++++++++++++++++++++++-------
>>>>    1 file changed, 65 insertions(+), 16 deletions(-)
>>>>
>>>> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
>>>> index 487448d666..f9d8b2f134 100644
>>>> --- a/tools/virtiofsd/passthrough_ll.c
>>>> +++ b/tools/virtiofsd/passthrough_ll.c
>>>> @@ -180,7 +180,8 @@ struct lo_data {
>>>>        int announce_submounts;
>>>>        bool use_statx;
>>>>        struct lo_inode root;
>>>> -    GHashTable *inodes; /* protected by lo->mutex */
>>>> +    GHashTable *inodes_by_ids; /* protected by lo->mutex */
>>>> +    GHashTable *inodes_by_handle; /* protected by lo->mutex */
>>>>        struct lo_map ino_map; /* protected by lo->mutex */
>>>>        struct lo_map dirp_map; /* protected by lo->mutex */
>>>>        struct lo_map fd_map; /* protected by lo->mutex */
>>>> @@ -263,8 +264,9 @@ static struct {
>>>>    /* That we loaded cap-ng in the current thread from the saved */
>>>>    static __thread bool cap_loaded = 0;
>>>> -static struct lo_inode *lo_find(struct lo_data *lo, struct stat *st,
>>>> -                                uint64_t mnt_id);
>>>> +static struct lo_inode *lo_find(struct lo_data *lo,
>>>> +                                const struct lo_fhandle *fhandle,
>>>> +                                struct stat *st, uint64_t mnt_id);
>>>>    static int xattr_map_client(const struct lo_data *lo, const char *client_name,
>>>>                                char **out_name);
>>>> @@ -1064,18 +1066,40 @@ out_err:
>>>>        fuse_reply_err(req, saverr);
>>>>    }
>>>> -static struct lo_inode *lo_find(struct lo_data *lo, struct stat *st,
>>>> -                                uint64_t mnt_id)
>>>> +static struct lo_inode *lo_find(struct lo_data *lo,
>>>> +                                const struct lo_fhandle *fhandle,
>>>> +                                struct stat *st, uint64_t mnt_id)
>>>>    {
>>>> -    struct lo_inode *p;
>>>> -    struct lo_key key = {
>>>> +    struct lo_inode *p = NULL;
>>>> +    struct lo_key ids_key = {
>>>>            .ino = st->st_ino,
>>>>            .dev = st->st_dev,
>>>>            .mnt_id = mnt_id,
>>>>        };
>>>>        pthread_mutex_lock(&lo->mutex);
>>>> -    p = g_hash_table_lookup(lo->inodes, &key);
>>>> +    if (fhandle) {
>>>> +        p = g_hash_table_lookup(lo->inodes_by_handle, fhandle);
>>>> +    }
>>>> +    if (!p) {
>>>> +        p = g_hash_table_lookup(lo->inodes_by_ids, &ids_key);
>>> So even if fhandle is not NULL, we will still lookup the inode
>>> object in lo->inodes_by_ids? I thought fallback was only required
>>> if we could not generate file handle to begin with and in that case
>>> fhandle will be NULL?
>> Well.  I think it depends again on when file handle generation can fail and
>> when it cannot.  If we assume it can randomly fail at any time, then it’s
>> possible we create an lo_inode with an O_PATH fd, but later we are able to
>> generate a file handle for it.  So we first try a lookup by file handle
>> here, which would fail, but we’d still have to try a lookup by IDs, so we
>> can find the O_PATH lo_inode.
>>
>> An example case would be if at first we weren’t able to open a mount fd
>> (because this file is a device node and the first lo_inode looked up on its
>> filesystem), and so we couldn’t generate a file handle that we would be sure
>> would work; but later for the lookup we can generate a file handle (because
>> some other node on that filesystem has been opened by then, so we have a
>> mount fd).
> Ok, got it. If we are assuming that file handle generation can fail
> randomly, then what will happen in following scenario.
>
> - lookup, file handle generated, inode added to both hash tables.
>
> - another lookup, handle generation failed. We call lo_find(), it
>    finds inode in lo->inodes_by_ids but rejects it because p->fd == -1.
>
> - Now lo_find() will return NULL and caller will assume inode could
>    not be found (despite the fact it is in there) and caller lo_do_lookup()
>    will try to add new inode to hash tables. So we will have two inode
>    instances in hash table with same st_dev, st_ino, mnt_id. One will
>    have file handle while other will have O_PATH fd.
>
> So we have two inodes in cache representing same file. One using file
> handle while other using O_PATH fd.
>
> One side affect of this is says guest has looked up a file (and got
> node id 1, fhandle based inode). And later guest is revalidating
> that inode, this time it could get inode 2 (O_PATH fd). Guest will
> think inode has changed and discard previous inode and trigger
> another lookup. This typically happens only if file has gone away.
> But now it will happen because we have two inodes in cache representing
> same file.
>
> There might be other cases where this is bad. I can't think of any
> at this point of time.
>
> If could solve the issue of mount_fd, then we have to use fallback
> path probably only for EOPNOTSUPP case. And then we can be sure
> that cache will always have one inode either fhandle based or
> O_PATH based (and not both).

OK, but can we truly solve the mount_fd issue?

What I think we could do is have two variants of the file handle 
generation function, one which is supposed to create a usable file 
handle (so this version will ensure mount_fds contains a valid fd for 
the mount ID), and one that just generates a file handle for lookup 
(i.e. it doesn’t look into mount_fds at all).  The latter version would 
practically only fail in the EOPNOTSUPP case.

Would that get around the issue?

Hanna

