Message-ID: <dab8877d-54ad-9384-4a0f-34eae2c93b75@linux.alibaba.com>
Date: Wed, 8 Dec 2021 09:38:45 +0800
MIME-Version: 1.0
References: <20211102055646.103337-1-jefflexu@linux.alibaba.com>
	<Ya9y7uqsMoDfGIbc@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
In-Reply-To: <Ya9y7uqsMoDfGIbc@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v7 0/6] virtiofsd: support per inode DAX
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, miklos@szeredi.hu



On 12/7/21 10:42 PM, Vivek Goyal wrote:
> Hi Jeffle,
> 
> I noticed that you posted V8 of kernel patches. I was away from work
> so could not look at it. Now I am back and want to review and test
> those patches.

Thanks for reviewing and evaluating.

> 
> Is there a new version of patches for virtiofsd as well?

Nope. Patches for virtiofsd is not updated. v7 is the latest version.

> 
> As per v6 changelog, I see that you have rebased virtiofsd patches to.
> 
> https://gitlab.com/virtio-fs/qemu/-/commits/virtio-fs-dev
> 
> I am not sure if that's the branch where latest DAX patches are supposed
> to be.
> 
> David, could you please let us know which branch should we use for
> latest DAX patches you have. Or push your latest patches to virtio-fs-dev
> so that we are on same page.
> 


-- 
Thanks,
Jeffle

