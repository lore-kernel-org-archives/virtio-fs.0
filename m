References: <4bfe8bbd-282f-f271-735d-8892791327e1@huawei.com>
	<20201110114548.GA1084668@stefanha-x1.localdomain>
From: Haotian Li <lihaotian9@huawei.com>
Message-ID: <78a36bd0-4091-31bc-f8a3-b62bbe52b595@huawei.com>
Date: Tue, 10 Nov 2020 21:10:23 +0800
MIME-Version: 1.0
In-Reply-To: <20201110114548.GA1084668@stefanha-x1.localdomain>
Content-Type: text/plain; charset="windows-1252"
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
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, linfeilong@huawei.com, qemu-devel@nongnu.org

Thanks for your suggestion. New patches will be resent.

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

