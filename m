References: <4bfe8bbd-282f-f271-735d-8892791327e1@huawei.com>
	<20201110114548.GA1084668@stefanha-x1.localdomain>
From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <f020aab3-2f11-3eba-fe43-42a5f3bf1f68@huawei.com>
Date: Tue, 10 Nov 2020 21:06:35 +0800
MIME-Version: 1.0
In-Reply-To: <20201110114548.GA1084668@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v2 0/2] virtiofsd: fix some accessing NULL
 pointer problem
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>, Haotian Li <lihaotian9@huawei.com>
Cc: virtio-fs@redhat.com, linfeilong@huawei.com, qemu-devel@nongnu.org



On 2020/11/10 19:45, Stefan Hajnoczi wrote:
> On Tue, Nov 10, 2020 at 02:32:17PM +0800, Haotian Li wrote:
>> Haotian Li (2):
>>   tools/virtiofsd/buffer.c: check whether buf is NULL in
>>     fuse_bufvec_advance func
>>   virtiofsd/passthrough_ll.c: check whether lo_map_reserve returns NULL
>>     in main func
>>
>>  tools/virtiofsd/buffer.c         |  4 ++++
>>  tools/virtiofsd/passthrough_ll.c | 10 +++++++++-
>>  2 files changed, 13 insertions(+), 1 deletion(-)
> 
> Please consider printing an error message in Patch 2 so that users can
> easily tell why the program refused to start.
> 
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> 
Thanks for your review.
We will add error message in Patch2, and then send the v3-patch series.

Regards
Zhiqiang Liu.
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
> 

