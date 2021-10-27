References: <20210923092526.72341-1-jefflexu@linux.alibaba.com>
	<YUzOADZvjv7IczrJ@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <d2a54a62-d6dc-0e41-694d-7a5f574f0f32@linux.alibaba.com>
Date: Wed, 27 Oct 2021 11:42:52 +0800
MIME-Version: 1.0
In-Reply-To: <YUzOADZvjv7IczrJ@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v5 0/5] fuse,virtiofs: support per-file DAX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, linux-fsdevel@vger.kernel.org


Sorry for the late reply, as your previous reply was moved to junk box
by the algorithm...

On 9/24/21 2:57 AM, Vivek Goyal wrote:
> On Thu, Sep 23, 2021 at 05:25:21PM +0800, Jeffle Xu wrote:
>> This patchset adds support of per-file DAX for virtiofs, which is
>> inspired by Ira Weiny's work on ext4[1] and xfs[2].
>>
>> Any comment is welcome.
>>
>> [1] commit 9cb20f94afcd ("fs/ext4: Make DAX mount option a tri-state")
>> [2] commit 02beb2686ff9 ("fs/xfs: Make DAX mount option a tri-state")
>>
>>
>> [Purpose]
>> DAX may be limited in some specific situation. When the number of usable
>> DAX windows is under watermark, the recalim routine will be triggered to
>> reclaim some DAX windows. It may have a negative impact on the
>> performance, since some processes may need to wait for DAX windows to be
>> recalimed and reused then. To mitigate the performance degradation, the
>> overall DAX window need to be expanded larger.
>>
>> However, simply expanding the DAX window may not be a good deal in some
>> scenario. To maintain one DAX window chunk (i.e., 2MB in size), 32KB
>> (512 * 64 bytes) memory footprint will be consumed for page descriptors
>> inside guest, which is greater than the memory footprint if it uses
>> guest page cache when DAX disabled. Thus it'd better disable DAX for
>> those files smaller than 32KB, to reduce the demand for DAX window and
>> thus avoid the unworthy memory overhead.
>>
>> Per-file DAX feature is introduced to address this issue, by offering a
>> finer grained control for dax to users, trying to achieve a balance
>> between performance and memory overhead.
>>
>>
>> [Note]
>> When the per-file DAX hint changes while the file is still *opened*, it
>> is quite complicated and maybe fragile to dynamically change the DAX
>> state, since dynamic switching needs to switch a_ops atomiclly. Ira
>> Weiny had ever implemented a so called i_aops_sem lock [3] but
>> eventually gave up since the complexity of the implementation [4][5][6][7].
>>
>> Hence mark the inode and corresponding dentries as DONE_CACHE once the
>> per-file DAX hint changes, so that the inode instance will be evicted
>> and freed as soon as possible once the file is closed and the last
>> reference to the inode is put. And then when the file gets reopened next
>> time, the new instantiated inode will reflect the new DAX state.
> 
> If we don't cache inode (if no fd is open), will it not have negative
> performance impact. When we cache inodes, we also have all the dax
> mappings cached as well. So if a process opens the same file again,
> it gets all the mappings already in place and it does not have
> to call FUSE_SETUPMAPPING again.
> 

What does 'all the dax mappings cached' mean when 'we cache inodes'?

If the per-file DAX hint indeed changes for a large sized file, with
quite many page caches or DAX mapping already in the address space, then
marking it DONT_CACHE means evicting the inode as soon as possible,
which means flushing the page caches or removing all DAX mappings. When
the inode is reopened next time, page cache is re-instantiated or
FUSE_SETUPMAPPING is called again. Then the negative performance impact
indeed exist in this case.

But this performance impact only exist when the per-file DAX hint
changes halfway, that is, the hint suddenly changes after the virtiofs
has already mounted in the guest.



-- 
Thanks,
Jeffle

