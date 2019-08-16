References: <5D5649EA.20509@huawei.com>
	<20190816063921.GI52397@e18g06458.et15sqa>
From: piaojun <piaojun@huawei.com>
Message-ID: <5D5650C0.2090000@huawei.com>
Date: Fri, 16 Aug 2019 14:44:16 +0800
MIME-Version: 1.0
In-Reply-To: <20190816063921.GI52397@e18g06458.et15sqa>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [QUESTION] lots of testcases failed in pjdfstest
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

Hi Eryu,

On 2019/8/16 14:39, Eryu Guan wrote:
> On Fri, Aug 16, 2019 at 02:15:06PM +0800, piaojun wrote:
>> Hi,
>>
>> I got a lot of failed testcases when using pjdfstest, and I wonder if
>> my mount command is wrong? Most failed testcases are related with
>> authority.
>>
>> HostOS:
>> # ./virtiofsd -o vhost_user_socket=/tmp/vhostqemu -o source=/mnt/virtiofs/ -o cache=always -o writeback
>>
>> GuestOS:
>> # mount -t virtio_fs myfs /mnt/virtiofs -o rootmode=040000,user_id=0,group_id=0
> 
> Try adding "-o default_permissions,allow_other" mount options?
> 
> Thanks,
> Eryu

Thanks for your reply and most of the testcases get passed. And I will
look into the very few failed cases.

Jun

