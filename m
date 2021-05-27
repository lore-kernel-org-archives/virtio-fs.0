References: <20210512125544.9536-1-mreitz@redhat.com>
	<20210512125544.9536-2-mreitz@redhat.com>
	<20210526181324.GA1222711@redhat.com> <20210526185017.GB1225492@horse>
From: Max Reitz <mreitz@redhat.com>
Message-ID: <b066027e-1733-8ca3-00e2-68e58aa8e563@redhat.com>
Date: Thu, 27 May 2021 17:00:31 +0200
MIME-Version: 1.0
In-Reply-To: <20210526185017.GB1225492@horse>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 1/3] virtiofsd: Find original inode ID of
 mount points
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

On 26.05.21 20:50, Vivek Goyal wrote:
> On Wed, May 26, 2021 at 02:13:24PM -0400, Vivek Goyal wrote:
>> On Wed, May 12, 2021 at 02:55:42PM +0200, Max Reitz wrote:
>>> Mount point directories represent two inodes: On one hand, they are a
>>> normal directory on their parent filesystem.  On the other, they are the
>>> root node of the filesystem mounted there.  Thus, they have two inode
>>> IDs.
>>>
>>> Right now, we only report the latter inode ID (i.e. the inode ID of the
>>> mounted filesystem's root node).  This is fine once the guest has
>>> auto-mounted a submount there (so this inode ID goes with a device ID
>>> that is distinct from the parent filesystem), but before the auto-mount,
>>> they have the device ID of the parent and the inode ID for the submount.
>>> This is problematic because this is likely exactly the same
>>> st_dev/st_ino combination as the parent filesystem's root node.  This
>>> leads to problems for example with `find`, which will thus complain
>>> about a filesystem loop if it has visited the parent filesystem's root
>>> node before, and then refuse to descend into the submount.
>>>
>>> There is a way to find the mount directory's original inode ID, and that
>>> is to readdir(3) the parent directory, look for the mount directory, and
>>> read the dirent.d_ino field.  Using this, we can let lookup and
>>> readdirplus return that original inode ID, which the guest will thus
>>> show until the submount is auto-mounted.
>>
>>> (Then, it will invoke getattr
>>> and that stat(2) call will return the inode ID for the submount.)
>>
>> Hi Max,
>>
>> How are we sure that GETATTR() will always be called and that will
>> allow us to return inode number in mounted filesystem (instead of
>> parent filesystem). I thought GETATTR will be called only if cached
>> attrs have expired. (1 second default for cache=auto). Otherwise
>> stat() will fill inode->i_no from cache and return. And I am afraid
>> that in that case we will return inode number from parent fs,
>> instead of mounted fs.
>>
>> Say following sequence of events happens pretty fast one after the
>> other. Say /mnt/virtiofs/foo is a mount point in server but client
>> has not created submount yet.
>>
>> A. stat(/mnt/virtiofs/foo, AT_NO_AUTOMOUNT)
>>     -> This should get inode number in parent filesystem on host and
>>        store in guest inode->i_no and return to user space. Say inode
>>        in guest is called a_ino.
>> B. stat(/mnt/virtiofs/foo)
>>     -> This should create submount and create new inode (say b_ino), using
>>        properties from a_ino. IOW, this should copy a_ino->i_no to
>>        b_ino->b_ino given current code, IIUC.
>>
>>     -> Assume timeout has not happened and cached attrs have not expired.
>>
>>     -> And now b_ino->i_no (or ->orig_ino) will be returned to user space.

Well, I mean, this sounds easy enough to test.  For example, this passes 
for me:

count=1000
root_st_ino=128
tag=host
mountpoint=/mnt
submount_path=submount

for i in $(seq $count)
do
     mount -t virtiofs $tag $mountpoint || break
     if [ $(stat -c '%i' $mountpoint/$submount_path) -eq $root_st_ino ]
     then
         echo 'fail 0'
         break
     fi
     ls $mountpoint/$submount_path > /dev/null
     if [ $(stat -c '%i' $mountpoint/$submount_path) -ne $root_st_ino ]
     then
         echo 'fail 1'
         break
     fi
     umount $mountpoint || break
done
if [ $i -ne $count ]
then
     echo 'Something failed'
else
     echo 'OK'
fi

>> Am I missing something. Do we need to always expire inode attrs when
>> we create submount so that client is forced to issue GETATTR.
> 
> Looks like while initialzing b_ino, we are setting attr_valid=0, which
> should set fi->i_time=0 and force issuing GETATTR later.
> 
> fuse_fill_super_submount()
>    root = fuse_iget(sb, parent_fi->nodeid, 0, &root_attr, 0, 0);
>                                                           ^
>      fuse_iget(attr_valid=0)
>         fuse_change_attributes(attr_valid=0)
> 	  fuse_change_attributes_common(attr_valid=0)
>              fi->i_time = attr_valid;
> 
> So may be this will force GETATTR and fetch new inode id when second
> stat() is called.

i_time is at least what fuse_update_get_attr() uses to decide whether to 
invoke GETATTR or not – although AT_STATX_DONT_SYNC can override that, 
but I don’t think that’s a problem.  If i_time is 0, that function will 
always invoke GETATTR (unless AT_STATX_DONT_SYNC).

So I think it works in practice.  When the inode ID is looked up through 
some stat-y function, this should go through fuse_update_get_attr(), 
which will fetch the st_ino on the submount.  There is still i_ino, 
though...

To be absolutely certain, we could invoke fuse_update_attributes() in 
fuse_fill_super_submount(), but then again, fuse_fill_super_common() 
doesn’t do that either for its root node.  It just initializes i_ino to 
FUSE_ROOT_ID, i.e. 1.

Max

