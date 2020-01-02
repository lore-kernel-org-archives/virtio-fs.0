Message-ID: <5E0D8076.70308@cn.fujitsu.com>
Date: Thu, 2 Jan 2020 13:32:38 +0800
From: Xiao Yang <yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
References: <20200102035312.18507-1-yangx.jy@cn.fujitsu.com>
	<20200102045035.GC41863@e18g06458.et15sqa>
In-Reply-To: <20200102045035.GC41863@e18g06458.et15sqa>
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd/passthrough_ll: Pass errno to
	fuse_reply_err()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eryu Guan <eguan@linux.alibaba.com>
Cc: virtio-fs@redhat.com

On 2020/1/2 12:50, Eryu Guan wrote:
> On Thu, Jan 02, 2020 at 11:53:12AM +0800, Xiao Yang wrote:
>> >  lo_copy_file_range() passes -errno to fuse_reply_err() and then fuse_reply_err()
>> >  changes it to errno again, so that subsequent fuse_send_reply_iov_nofree() catches
>> >  the wrong errno.(i.e. reports "fuse: bad error value: ...").
>> >  
>> >  Make fuse_send_reply_iov_nofree() accept the correct -errno by passing errno
>> >  directly in lo_copy_file_range().
>> >  
>> >  Signed-off-by: Xiao Yang<yangx.jy@cn.fujitsu.com>
> Looks good to me.
>
> Reviewed-by: Eryu Guan<eguan@linux.alibaba.com>
>
> I also went through the other fuse_reply_err() calls and they all pass
> positive error number to the second arg.
Hi Eryu,

Thanks for your review. :-)

Best Regards,
Xiao Yang
> Thanks,
> Eryu
>




