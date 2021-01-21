References: <20210121144429.58885-1-stefanha@redhat.com>
	<f5fc73e5-334e-c1ef-3982-227715efc26b@redhat.com>
	<1611243688.4854bsewsj.none@localhost>
From: Laszlo Ersek <lersek@redhat.com>
Message-ID: <8d4f7c40-95c7-feed-1744-73ca2349c1f2@redhat.com>
Date: Thu, 21 Jan 2021 18:07:26 +0100
MIME-Version: 1.0
In-Reply-To: <1611243688.4854bsewsj.none@localhost>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: prevent opening of special files
 (CVE-2020-35517)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Alex Xu <alex@alxu.ca>, qemu-devel@nongnu.org
Cc: P J P <ppandit@redhat.com>, virtio-fs@redhat.com, vgoyal@redhat.com

On 01/21/21 16:52, Alex Xu wrote:
> Excerpts from Laszlo Ersek's message of January 21, 2021 10:32 am:
>> Assuming a benign / trusted guest, is there going to be an override for
>> this?
>>
>> Asked differently -- if we don't want to set up a separate block device
>> on the host, to contain the filesystem that is mounted as the shared
>> directory, can unionfs (?) / overlayfs be used to re-mount an existent
>> host-side directory as the shared directory, but with
>> "noexec,nosuid,nodev" *bolted-on*?
>>
>> If people have to create separate block devices (on the host side) for
>> innocent use cases such as running tests in a trusted guest, that's not
>> going to qualify as "usability progress" relative to having a qcow2 (or
>> raw) image file.
>>
>> "nodev,nosuid" is kind of a no-brainer for any host-side *data* volume
>> anyway (such as the one underlying "/home", even), so I don't see those
>> options as a challenge. But "noexec" is different.
>>
>> Thanks,
>> Laszlo
> 
> On Linux, there are two types of mount options: per-superblock, and 
> per-point. Most filesystem-specific options are per-superblock, and 
> apply to all mounts of that device. noexec, nosuid, and nodev are 
> per-mount options, and apply individually to each mount, bind or 
> otherwise, of a given device. Bind mounts copy the parent per-mount 
> options, but can be individually altered. Note also that it is not 
> required to create a new location for a bind mount.
> 
> For example, invoking:
> 
> mount --bind -o noexec,nosuid,nodev /var/lib/vms/source1 /var/lib/vms/source1
> 
> would effectively secure a source directory. This can also be inserted 
> in /etc/fstab, such as:
> 
> /var/lib/vms/source1 /var/lib/vms/source1 none bind,noexec,nosuid,nodev 0 0
> 
> Note that, as explained in Stefan's initial email, this hides any 
> submounts below source. Each of those must be individually protected, 
> either by initially mounting with the security options or by creating a 
> new bind mount as above. Although these cases should be infrequent, they 
> are common enough that Stefan and I think that they should be supported, 
> or at the very least not silently behave in unexpected or insecure ways.
> 
> Additionally, while it's possible to use overlayfs for this purpose, 
> it's overkill, and as far as I understand, doesn't solve the problem of 
> hiding sub-mounts.

Awesome, this is the best answer I could possibly get. Thank you!
Laszlo

