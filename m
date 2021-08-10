References: <20210730150134.216126-1-mreitz@redhat.com>
	<20210730150134.216126-11-mreitz@redhat.com>
	<YRF9Q+MSjrbeybd2@redhat.com>
From: Hanna Reitz <hreitz@redhat.com>
Message-ID: <dfebe39a-35d4-1e1c-c63f-2312586aa97d@redhat.com>
Date: Tue, 10 Aug 2021 10:38:32 +0200
MIME-Version: 1.0
In-Reply-To: <YRF9Q+MSjrbeybd2@redhat.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH v3 10/10] virtiofsd: Add lazy lo_do_find()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, Max Reitz <mreitz@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On 09.08.21 21:08, Vivek Goyal wrote:
> On Fri, Jul 30, 2021 at 05:01:34PM +0200, Max Reitz wrote:
>> lo_find() right now takes two lookup keys for two maps, namely the file
>> handle for inodes_by_handle and the statx information for inodes_by_ids.
>> However, we only need the statx information if looking up the inode by
>> the file handle failed.
>>
>> There are two callers of lo_find(): The first one, lo_do_lookup(), has
>> both keys anyway, so passing them does not incur any additional cost.
>> The second one, lookup_name(), though, needs to explicitly invoke
>> name_to_handle_at() (through get_file_handle()) and statx() (through
>> do_statx()).  We need to try to get a file handle as the primary key, so
>> we cannot get rid of get_file_handle(), but we only need the statx
>> information if looking up an inode by handle failed; so we can defer
>> that until the lookup has indeed failed.
> So IIUC, this patch seems to be all about avoiding do_statx()
> call in lookup_name() if file handle could be successfully
> generated.
>
> So can't we just not modify lookup_name() to not call statx()
> if file handle could be generated. And also modfiy lo_find()
> to use st/mnt_id only if fhandle==NULL.
>
> That probably is much simpler change as compared to passing function
> pointers around.

Definitely, but I don’t know whether it’s correct.

Or, we can just drop this patch and say that we don’t need to 
over-optimize C virtiofsd.

Hanna

