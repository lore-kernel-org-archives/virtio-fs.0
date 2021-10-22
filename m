References: <20211011030052.98923-1-jefflexu@linux.alibaba.com>
	<20211011030052.98923-3-jefflexu@linux.alibaba.com>
	<YW2AU/E0pLHO5Yl8@redhat.com>
	<652ac323-6546-01b8-992e-460ad59577ca@linux.alibaba.com>
	<YXAzB5sOrFRUzTC5@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <96956132-fced-5739-d69a-7b424dc65f7c@linux.alibaba.com>
Date: Fri, 22 Oct 2021 14:54:03 +0800
MIME-Version: 1.0
In-Reply-To: <YXAzB5sOrFRUzTC5@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v6 2/7] fuse: make DAX mount option a
	tri-state
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, Dave Chinner <dchinner@redhat.com>, ira.weiny@intel.com
Cc: miklos@szeredi.hu, virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, linux-fsdevel@vger.kernel.org

cc [Ira Weiny], author of per inode DAX on xfs/ext4

On 10/20/21 11:17 PM, Vivek Goyal wrote:
> On Wed, Oct 20, 2021 at 10:52:38AM +0800, JeffleXu wrote:
>>
>>
>> On 10/18/21 10:10 PM, Vivek Goyal wrote:
>>> On Mon, Oct 11, 2021 at 11:00:47AM +0800, Jeffle Xu wrote:
>>>> We add 'always', 'never', and 'inode' (default). '-o dax' continues to
>>>> operate the same which is equivalent to 'always'. To be consistemt with
>>>> ext4/xfs's tri-state mount option, when neither '-o dax' nor '-o dax='
>>>> option is specified, the default behaviour is equal to 'inode'.
>>>
>>> Hi Jeffle,
>>>
>>> I am not sure when  -o "dax=inode"  is used as a default? If user
>>> specifies, "-o dax" then it is equal to "-o dax=always", otherwise
>>> user will explicitly specify "-o dax=always/never/inode". So when
>>> is dax=inode is used as default?
>>
>> That means when neither '-o dax' nor '-o dax=always/never/inode' is
>> specified, it is actually equal to '-o dax=inode', which is also how
>> per-file DAX on ext4/xfs works.
> 
> [ CC dave chinner] 
> 
> Is it not change of default behavior for ext4/xfs as well. My
> understanding is that prior to this new dax options, "-o dax" enabled
> dax on filesystem and if user did not specify it, DAX is disbaled
> by default.
> 
> Now after introduction of "-o dax=always/never/inode", if suddenly
> "-o dax=inode" became the default if user did not specify anything,
> that's change of behavior. Is that intentional. If given a choice,
> I would rather not change default and ask user to opt-in for
> appropriate dax functionality.
> 
> Dave, you might have thoughts on this. It makes me uncomfortable to
> change virtiofs dax default now just because other filesytems did it.
> 

I can only find the following discussions about the earliest record on
this tri-state mount option:

https://lore.kernel.org/lkml/20200316095509.GA13788@lst.de/
https://lore.kernel.org/lkml/20200401040021.GC56958@magnolia/


Hi, Ira Weiny,

Do you have any thought on this, i.e. why the default behavior has
changed after introduction of per inode dax?

-- 
Thanks,
Jeffle

