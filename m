References: <47a35ffe-ef39-d098-2c29-34cf7d4eb7ef@redhat.com>
	<YFsnwtUqfmr3e7dI@stefanha-x1.localdomain> <YFtshUTbNF9omBGv@work-vm>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <a45982bc-a749-0eb6-27ce-4feb0c6ce103@redhat.com>
Date: Wed, 24 Mar 2021 17:57:13 +0100
MIME-Version: 1.0
In-Reply-To: <YFtshUTbNF9omBGv@work-vm>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] Current file handle status and open questions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

On 24.03.21 17:44, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
>> On Thu, Mar 18, 2021 at 06:09:58PM +0100, Max Reitz wrote:

[...]

>>> Final minor question that doesn’t really fit in fully elsewhere: When
>>> generating a MAC over a file handle, should the mount ID be included?
>>> I’m worried that this might definitely break persistency, but I think we
>>> should include some FS ID.  Maybe the kernel should query the FS UUID
>>> for this MAC calculation, and use that instead of the mount ID?
>>
>> This is a good point. If the file handle is not tied to a particular
>> file system mount then an application can stash a well-known file handle
>> (e.g. /) from one mount it has full access to and then use open a file
>> on a mount that it does not have full directory treeaccess to (e.g. a
>> bind mount/sub-tree?).
> 
> I'd be surprised if the mount-id was the same between two hosts.

True, and it’s also not persistent between reboots, that’s why I 
proposed for the kernel to query the FS UUID for the MAC calculation.

Max

