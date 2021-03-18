References: <810089e0-3a09-0d8f-9f8e-be5b3ac70587@redhat.com>
	<20210318135600.GA368102@redhat.com>
From: Connor Kuehl <ckuehl@redhat.com>
Message-ID: <19c488d0-2006-4a96-610d-f4825aa43cb3@redhat.com>
Date: Thu, 18 Mar 2021 08:58:54 -0500
MIME-Version: 1.0
In-Reply-To: <20210318135600.GA368102@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] Question about sg_count_fuse_req() in
	linux/fs/fuse/virtio_fs.c
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org

On 3/18/21 8:56 AM, Vivek Goyal wrote:
> I think all the in args are being mapped into a single scatter gather
> element and that's why it does not matter whether in_numargs is 3, 2 or 1.
> They will be mapped in a single element.
> 
> sg_init_fuse_args()
> {
>          len = fuse_len_args(numargs - argpages, args);
>          if (len)
>                  sg_init_one(&sg[total_sgs++], argbuf, len);
> }
> 
>          out_sgs += sg_init_fuse_args(&sg[out_sgs], req,
>                                       (struct fuse_arg *)args->in_args,
>                                       args->in_numargs, args->in_pages,
>                                       req->argbuf, &argbuf_used);
> 
> When we are sending some data in some pages, then we set args->in_pages
> to true. And in that case, last element of args->in_args[] contains the
> total size of bytes in additional pages we are sending and is not part
> of in_args being mapped to scatter gather element. That's why this
> check.
> 
> 	if (args->in_numargs - args->in_pages)
> 		total_sgs += 1;

Aha! Thank you, Vivek. That makes sense.

> Not sure when we will have a case where args->in_numargs = 1 and
> args->in_pages=true. Do we ever hit that.

Not in my experience. My previous mail was examining this routine mainly 
in a vacuum.

Connor

> Thanks
> Vivek
> 
>>
>> Especially since the block right below it counts pages if args->in_pages is
>> true:
>>
>>          if (args->in_pages) {
>>                  size = args->in_args[args->in_numargs - 1].size;
>>                  total_sgs += sg_count_fuse_pages(ap->descs, ap->num_pages,
>>                                                   size);
>>          }
>>
>> The rest of the routine goes on similarly but for the 'out' components.
>>
>> I doubt incrementing 'total_sgs' in the first if-statement I showed above is
>> vestigial, I just think my mental model of what is happening here is
>> incomplete.
>>
>> Any clarification is much appreciated!
> 
>>
>> Connor
>>
> 

