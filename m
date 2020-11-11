References: <20201103164135.169325-1-mreitz@redhat.com>
	<20201110185749.GH3108@work-vm>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <50b9de71-017f-1253-f912-a1568f733958@redhat.com>
Date: Wed, 11 Nov 2020 13:07:47 +0100
MIME-Version: 1.0
In-Reply-To: <20201110185749.GH3108@work-vm>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH for-5.2] virtiofsd: Announce submounts even
 without statx()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On 10.11.20 19:57, Dr. David Alan Gilbert wrote:
> * Max Reitz (mreitz@redhat.com) wrote:
>> Contrary to what the check (and warning) in lo_init() claims, we can
>> announce submounts just fine even without statx() -- the check is based
>> on comparing both the mount ID and st_dev of parent and child.  Without
>> statx(), we will not have the mount ID; but we always have st_dev.
>>
>> The only problems we have (without statx() and its mount ID) are:
>>
>> (1) Mounting the same device twice may lead to both trees being treated
>>      as exactly the same tree by virtiofsd.  But that is a problem that
>>      is completely independent of mirroring host submounts in the guest.
>>      Both submount roots will still show the FUSE_SUBMOUNT flag, because
>>      their st_dev still differs from their respective parent.
>>
>> (2) There is only one exception to (1), and that is if you mount a
>>      device inside a mount of itself: Then, its st_dev will be the same
>>      as that of its parent, and so without a mount ID, virtiofsd will not
>>      be able to recognize the nested mount's root as a submount.
>>      However, thanks to virtiofsd then treating both trees as exactly the
>>      same tree, it will be caught up in a loop when the guest tries to
>>      examine the nested submount, so the guest will always see nothing
>>      but an ELOOP there.  Therefore, this case is just fully broken
>>      without statx(), whether we check for submounts (based on st_dev) or
>>      not.
>>
>> All in all, checking for submounts works well even without comparing the
>> mount ID (i.e., without statx()).  The only concern is an edge case
>> that, without statx() mount IDs, is utterly broken anyway.
>>
>> Thus, drop said check in lo_init().
>>
>> Reported-by: Miklos Szeredi <mszeredi@redhat.com>
>> Signed-off-by: Max Reitz <mreitz@redhat.com>
> 
> OK, that seems to have been the outcome of the discussion here:
>    https://lists.gnu.org/archive/html/qemu-devel/2020-11/msg00500.html

That’s right.

> so
> 
> 
> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

Thanks :)

Max

