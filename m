References: <20200416164907.244868-1-stefanha@redhat.com>
	<20200618190816.GD3814@redhat.com> <20200618191655.GI2769@work-vm>
	<20200618192717.GE3814@redhat.com>
	<CAJFHJrrJzPLatNvw2xC3WYLbzCW0+DB+4UczQHGPBF9p+WGYQA@mail.gmail.com>
	<20200619191540.GI3154@redhat.com>
	<CAJFHJroGNbfO-tXqrod_snCHcnN4NKjX8t9LTeroyiNEwjtVcQ@mail.gmail.com>
	<20200625125508.GB149340@redhat.com>
	<CAJFHJrpwvEMa_OkxRg3XHXp+=Wuzwwc8shhCZd3xDsmVVJG7aw@mail.gmail.com>
	<fa2f133f-ac79-7205-ad86-facf4f979e56@redhat.com>
	<20200714123307.GA324688@redhat.com>
From: Daniel Walsh <dwalsh@redhat.com>
Message-ID: <5de35399-7385-a7a9-c2b3-7f60819c280b@redhat.com>
Date: Tue, 14 Jul 2020 13:16:07 -0400
MIME-Version: 1.0
In-Reply-To: <20200714123307.GA324688@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: drop Linux capabilities(7)
Reply-To: dwalsh@redhat.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com

On 7/14/20 08:33, Vivek Goyal wrote:
> On Mon, Jul 13, 2020 at 05:39:05PM -0400, Daniel Walsh wrote:
>
> [..]
>>>> Otherwise we either have to disable selinux on host (if we want to
>>>> support it in guest) or somehow guest and how policies will have
>>>> to know about each other and be able to work together (which will
>>>> be hard for a generic use case).
>>> Yes, I agree this is hard to do for a generic case but unfortunately
>>> the more I understand how selinux works the less I feel that it works
>>> well with a passthrough style file system.  As you said it either
>>> needs to be turned off on the host or the host and guest need to work
>>> together.
>> Correct both kernels need to understand the labels, or one of the
>> kernels has to have SELinux disabled.
>>
>> That is the bottom line.  Same issue exists for labeled NFS so I don't
>> see this as a problem.
> Dan,
>
> So what does labeled NFS do. Server disables SELinux so that it can
> be enabled on client?
>
> Thanks
> Vivek

Labeled NFS does all three

Server Disabled, Client Enabled - Server does not care about the labels

Sever Enabled, Client Disabled  - Server selects the labels, Client
ignores them

Sever Enabled, Client Enabled  - All labels are seen on the client and
server and must be understood by the Server, if the client does not
understand the label, it will be marked as unlabeled_t on the client, if
the Client tries to create a label that is not understood on the Server,
the Server will block the creation.

The most usual case of labeled NFS is the Client and Server use the same
SELinux policy. Or one or the other is disabled.  The cases where each
is enabled with different policy is rare, in my experience.

