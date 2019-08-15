DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048;
	t=1565830576; bh=x17L5Sqy2ZSt8rwbeOibabFQ+XtkAaG8z2OsU6HiUsA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From:Subject;
	b=kUck1hwkfUXgt5FTMUxSRNWo/aRpa0EcpBdcBxUQ7WqyH22C0zpWR/RpJx1vk6fiULVNc+BQHCfjnQqg8uy40QUXCt0zFuR/saUSidLutPa09bwGvecppNEzJiR62IdoER+WgIT8YxJq0bn8SvIb65tQH4kq3FMVPe9fb2bD36462Meeh7dhWOP9IUrBsMpqBdI6GfoetKuO8uDbFOf6SW2Ab4rR/Q2xdCL2j7Z7qR6IOu2T/34iV/v9bHsEDIDgMoWURMLxRH96UDr1ZUIAyPijWD1tr1/yUQLyGwVO7/G6UfuXrW9CNJ8Y4XpxCIY9Mh8AK8fAylbSo5m58uIIBA==
Date: Thu, 15 Aug 2019 08:56:05 +0800
From: Gao Xiang <hsiangkao@aol.com>
Message-ID: <20190815005559.GA14118@hsiangkao-HP-ZHAN-66-Pro-G1>
References: <5abd7616-5351-761c-0c14-21d511251006@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5abd7616-5351-761c-0c14-21d511251006@huawei.com>
Subject: Re: [Virtio-fs] [QUESTION] A performance problem for buffer write
 compared with 9p
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: wangyan <wangyan122@huawei.com>
Cc: linux-fsdevel@vger.kernel.org, "virtio-fs@redhat.com" <virtio-fs@redhat.com>

On Thu, Aug 15, 2019 at 08:30:43AM +0800, wangyan wrote:

[]

> 
> I found that the judgement statement 'if (!TestSetPageDirty(page))' always
> true in function '__set_page_dirty_nobuffers', it will waste much time
> to mark inode dirty, no one page is dirty when write it the second time.
> The buffer write stack:
>     fuse_file_write_iter
>       ->fuse_cache_write_iter
>         ->generic_file_write_iter
>           ->__generic_file_write_iter
>             ->generic_perform_write
>               ->fuse_write_end
>                 ->set_page_dirty
>                   ->__set_page_dirty_nobuffers
> 
> The reason for 'if (!TestSetPageDirty(page))' always true may be the pdflush
> process will clean the page's dirty flags in clear_page_dirty_for_io(),
> and call fuse_writepages_send() to flush all pages to the disk of the host.
> So when the page is written the second time, it always not dirty.
> The pdflush stack for fuse:
>     pdflush
>       ->...
>         ->do_writepages
>           ->fuse_writepages
>             ->write_cache_pages         // will clear all page's dirty flags
>               ->clear_page_dirty_for_io // clear page's dirty flags
>             ->fuse_writepages_send      // write all pages to the host, but
> don't wait the result
> Why not wait for getting the result of writing back pages to the host
> before cleaning all page's dirty flags?
> 

As my understanding, I personally think there's nothing wrong with
the above process from your words above.

Thanks,
Gao Xiang

> As for 9p, pdflush will call clear_page_dirty_for_io() to clean the page's
> dirty flags. Then call p9_client_write() to write the page to the host,
> waiting for the result, and then flush the next page. In this case, buffer
> write of 9p will hit the dirty page many times before it is being write
> back to the host by pdflush process.
> The pdflush stack for 9p:
>     pdflush
>       ->...
>         ->do_writepages
>           ->generic_writepages
>             ->write_cache_pages
>               ->clear_page_dirty_for_io // clear page's dirty flags
>               ->__writepage
>                 ->v9fs_vfs_writepage
>                   ->v9fs_vfs_writepage_locked
>                     ->p9_client_write   // it will get the writing back
> page's result
> 
> 
> According to the test result, is the handling method of 9p for page writing
> back more reasonable than virtiofs?
> 
> Thanks,
> Yan Wang
> 

