References: <2234280.ElGaqSPkdT@subpop>
From: Connor Kuehl <ckuehl@redhat.com>
Message-ID: <ebd44751-333c-cb7a-5776-c63501558af6@redhat.com>
Date: Wed, 2 Jun 2021 15:55:40 -0500
MIME-Version: 1.0
In-Reply-To: <2234280.ElGaqSPkdT@subpop>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] virtiofs mounted filesystems & SELinux
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Link Dupont <link@sub-pop.net>
Cc: virtio-fs-list <virtio-fs@redhat.com>, libvirt-users@redhat.com

On 5/21/21 11:59 AM, Link Dupont wrote:

Adding the virtio-fs mailing list.

> I am mounting a filesystem into a domain using the virtiofs driver.
> 
> <filesystem accessmode="passthrough" type="mount">
>       <source dir="/home"/>
>       <target dir="/home"/>
>       <driver type="virtiofs"/>
> </filesystem>
> 
> Both my host (Fedora 34) and guest (CentOS 8.4) are running with SELinux 
> enforcing. From my host, I can see that the SELinux context type is set to 
> user_home_dir_t.
> 
> $ ls -ldZ /home/link
> drwxr-xr-x. 61 link link system_u:object_r:user_home_dir_t:s0 8192 May 21 
> 12:41 /home/link
> 
>>From within the guest however, the volume is unlabeled_t
> 
> $ ls -lZd /home/link
> drwxr-xr-x. 61 link link system_u:object_r:unlabeled_t:s0 8192 May 21 12:53 /
> home/link
> 
> Is there a way to pass the SELinux context through to the guest? Or mount the 
> volume with the correct options to map SELinux contexts?
> 
> 

Hi,

I'm afraid I actually don't know that much about SELinux but I read
that it relies on using extended attributes in the file system to
accomplish its labeling.

Do you still experience this issue when you enable extended attribute
support[1] in virtiofsd? The example in the optional parameters snippet
enables extended attributes with the xattr='on' element.

Connor

[1] https://libvirt.org/kbase/virtiofs.html#optional-parameters

