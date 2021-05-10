Date: Mon, 10 May 2021 09:10:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210510131030.GA150402@horse>
References: <20210507185909.GA40951@redhat.com>
	<BY5PR12MB3809FCC8174D1FF664762209C5579@BY5PR12MB3809.namprd12.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB3809FCC8174D1FF664762209C5579@BY5PR12MB3809.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] Few queries about virtiofsd read implementation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Edward McClanahan <emcclanahan@nvidia.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On Fri, May 07, 2021 at 02:14:54PM -0700, Edward McClanahan wrote:
> I concur... Client usermode code is required to deal with ret < requested length... In this case, the requested length being the sum of the lengths of each iov segment.

Apart from client user mode, guest kernel also uses this to read pages
into page cache. If number of bytes read are less than bytes requested,
then it assumes EOF and truncates file. (fuse_short_read()).

So that probably means that we should only handle EINTR in server and
retry otherwise there should not be a need to retry in file server.

I am not sure if we need to handle EINTR explicitly or it is already
taken care of by library/kernel and restart system call.

Thanks
Vivek

> 
> There are two cases where this can occure:
> 1) the offset+Len > file size, and
> 2) the process intercepted an EINTR before all requested data became available
> 
> For file systems, we don't deal with #2...but we .just deal with #1.
> 
> Get Outlook for Android<https://aka.ms/AAb9ysg>
> ________________________________
> From: virtio-fs-bounces@redhat.com <virtio-fs-bounces@redhat.com> on behalf of Vivek Goyal <vgoyal@redhat.com>
> Sent: Friday, May 7, 2021 1:59:09 PM
> To: Dr. David Alan Gilbert <dgilbert@redhat.com>; Stefan Hajnoczi <stefanha@redhat.com>
> Cc: virtio-fs-list <virtio-fs@redhat.com>
> Subject: [Virtio-fs] Few queries about virtiofsd read implementation
> 
> External email: Use caution opening links or attachments
> 
> 
> Hi David/Stefan,
> 
> I am browsing through the code of read requests (FUSE_READ) in virtiofsd
> (and in virtiofs) and I have few questions. You folks probably know the
> answers.
> 
> 1. virtio_send_data_iov(), reads the data from file into the scatter list.
>   Some of the code looks strange.
> 
>   We seem to be retrying read if we read less number of bytes than what
>   client asked for. I am wondering shoudl this really be our
>   responsibility or client should deal with it. I am assuming that client
>   should be ready to deal with less number of bytes read.
> 
>   So what was the thought process behind retrying.
> 
>           if (ret < len && ret) {
>             fuse_log(FUSE_LOG_DEBUG, "%s: ret < len\n", __func__);
>             /* Skip over this much next time around */
>             skip_size = ret;
>             buf->buf[0].pos += ret;
>             len -= ret;
> 
>             /* Lets do another read */
>             continue;
>         }
> 
> - After this we have code where if number of bytes read are not same
>   as we expect to, then we return EIO.
> 
>           if (ret != len) {
>             fuse_log(FUSE_LOG_DEBUG, "%s: ret!=len\n", __func__);
>             ret = EIO;
>             free(in_sg_cpy);
>             goto err;
>         }
> 
>   When do we hit this. IIUC, preadv() will return.
> 
>   A. Either number of bytes we expected (no issues)
>   B. 0 in case of EOF (We break out of loop and just return to client with
>                       number of bytes we have read so far).
>   C. <0 (This is error case and we return error to client)
>   D. X bytes which is less than len.
> 
> To handle D we have code to retry. So when do we hit the above if
> condition where "ret !=len). Is this a dead code. Or I missed something.
> 
> 2. When client sent FUSE_READ, we put pointer to pages into sglist. IIUC,
>    we put pointer to "struct page *" and not actual page. So who converts
>    these struct page pointer to memory belong to page.
> 
>    sg_init_fuse_pages() {
>         sg_set_page(&sg[i], pages[i], this_len, page_descs[i].offset);
>    }
> 
> 3. Who converts guest memory address (when) into qemu process address which is
>    accessible by virtiofsd.
> 
> Thanks
> Vivek
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
> 

