References: <5D53D882.5090803@huawei.com> <5D5A4692.9060006@huawei.com>
	<20190820153926.GC4233@redhat.com> <20190820175610.GD4233@redhat.com>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D5CA2E2.9000802@huawei.com>
Date: Wed, 21 Aug 2019 09:48:18 +0800
MIME-Version: 1.0
In-Reply-To: <20190820175610.GD4233@redhat.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH RESEND][RFC] virtiofsd: do not fall back to
 buffer io when cache=auto/always
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com



On 2019/8/21 1:56, Vivek Goyal wrote:
> On Tue, Aug 20, 2019 at 11:39:26AM -0400, Vivek Goyal wrote:
>> On Mon, Aug 19, 2019 at 02:49:54PM +0800, piaojun wrote:
>>> When O_DIRECT flags is set by Guest, virtiofsd will open file with
>>> O_DIRECT, but unset 'fi->direct_io' which makes Guest go buffer io path.
>>
>> Where is virtiofsd unset fi->direct_io flag? All I can see is that it
>> sets this flag if cache=none?
>>
> 
> Ok, I looked at it little bit more closely and I don't think it is a
> problem. With cache=always/auto, we don't set fi->direct_io. That means
> server is not enforcing a direct I/O policy on client.
> 
> Now if client decides to direct I/O by opening file with O_DIRECT, it
> will still take direct I/O path and call fuse_direct_IO(). Look at
> fuse_file_aops->fuse_direct_IO().

The problem is that when Guest open with O_DIRECT, the Host won't set
open_flags with FOPEN_DIRECT_IO if CACHE_AUTO is set. It makes Guest
goes into fuse_cache_write_iter() rather than fuse_direct_write_iter().
In other words, the Guest's I/O mode will be changed by virtiofsd.

You cleared my first doubt that 'fi->direct_io' and 'fi->keep_cache'
are used to control Guest I/O mode together, and there may be different
I/O modes between Guest and Host if I undersatnd it correctly. I admit
this offers a more flexible config to user, but also introduces more
complex option. Maybe we could just use *keep_cache* to handle all
these options.

My second doubt is that *keep_cache* is used to control whether reusing
the cache of last open(). IMO, it has nothing to do with the following
I/O path.

Jun

> 
> Thanks
> Vivek
> 
>> Thanks
>> Vivek
>>
>>> That causes inconsistency between Guest and Host.
>>>
>>> The cache option in virtiofsd should not affect the file io mode, so
>>> set 'fi->direct_io' according to 'fi->flags'.
>>>
>>> Signed-off-by: Jun Piao <piaojun@huawei.com>
>>> ---
>>>  contrib/virtiofsd/passthrough_ll.c | 9 +++++++--
>>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
>>> index ca11764..a9c98d0 100644
>>> --- a/contrib/virtiofsd/passthrough_ll.c
>>> +++ b/contrib/virtiofsd/passthrough_ll.c
>>> @@ -1774,8 +1774,10 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
>>>  		fi->fh = fh;
>>>  		err = lo_do_lookup(req, parent, name, &e);
>>>  	}
>>> -	if (lo->cache == CACHE_NONE)
>>> +	if (fi->flags & O_DIRECT)
>>>  		fi->direct_io = 1;
>>> +	if (lo->cache == CACHE_NONE)
>>> +		fi->keep_cache = 0;
>>>  	else if (lo->cache == CACHE_ALWAYS)
>>>  		fi->keep_cache = 1;
>>>
>>> @@ -1982,8 +1984,11 @@ static void lo_open(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
>>>  	}
>>>
>>>  	fi->fh = fh;
>>> -	if (lo->cache == CACHE_NONE)
>>> +
>>> +	if (fi->flags & O_DIRECT)
>>>  		fi->direct_io = 1;
>>> +	if (lo->cache == CACHE_NONE)
>>> +		fi->keep_cache = 0;
>>>  	else if (lo->cache == CACHE_ALWAYS)
>>>  		fi->keep_cache = 1;
>>>  	fuse_reply_open(req, fi);
>>> -- 
>>>
>>> _______________________________________________
>>> Virtio-fs mailing list
>>> Virtio-fs@redhat.com
>>> https://www.redhat.com/mailman/listinfo/virtio-fs
> .
> 

