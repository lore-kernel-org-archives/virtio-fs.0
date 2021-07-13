DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048;
	t=1626186524; bh=18BmMZkvH2tBvb+UvZGjk8mOAMpg1SXeFmAfTWxjld4=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To;
	b=ArUFeu3bkk7ikJdPTPJueCjsUsNpbGnjxSwelS9i7L/DrB4KXJUz/dqYE4JNW35+D6XK3AzgXY+0g7f7ArO3au+2ICbCxgoNRLuXQLxKmL6iScdccq84epNmKjLHIqZoaKGzgQW36CUMZ8oCPA4U5xEOtBiQPsNg2qe0Ny3GuKelz5R+eliIXOzLmYf+FYxxW5ZnBbPi+3idbcFMVhwK+YSharzRMuBkrtBFzRtXZmPpzyPrueYtkB9smlRaWVuyMTpUor75bkva50w4v2TcSVperlwbVoqsHW79Hanqeqa5J9W20jJ5WqJGgkAs4g0Ef/JkdmLtvTUz6e0eEBtniQ==
References: <20210708175738.360757-1-vgoyal@redhat.com>
	<20210708175738.360757-2-vgoyal@redhat.com>
	<20210709091915.2bd4snyfjndexw2b@wittgenstein>
	<20210709152737.GA398382@redhat.com>
	<710d1c6f-d477-384f-0cc1-8914258f1fb1@schaufler-ca.com>
	<20210712144849.121c948c@bahia.lan>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <cea2f545-ab2d-e9a8-0258-9c8bb443784f@schaufler-ca.com>
Date: Tue, 13 Jul 2021 07:28:38 -0700
MIME-Version: 1.0
In-Reply-To: <20210712144849.121c948c@bahia.lan>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH v2 1/1] xattr: Allow user.* xattr on symlink
 and special files
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: gscrivan@redhat.com, tytso@mit.edu, miklos@szeredi.hu, selinux@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk, Christoph Hellwig <hch@infradead.org>, casey.schaufler@intel.com, jack@suse.cz, Christian Brauner <christian.brauner@ubuntu.com>, Vivek Goyal <vgoyal@redhat.com>

On 7/12/2021 5:49 AM, Greg Kurz wrote:
> On Fri, 9 Jul 2021 08:34:41 -0700
> Casey Schaufler <casey@schaufler-ca.com> wrote:
>
>> On 7/9/2021 8:27 AM, Vivek Goyal wrote:
>>> On Fri, Jul 09, 2021 at 11:19:15AM +0200, Christian Brauner wrote:
>>>> On Thu, Jul 08, 2021 at 01:57:38PM -0400, Vivek Goyal wrote:
>>>>> Currently user.* xattr are not allowed on symlink and special files.
>>>>>
>>>>> man xattr and recent discussion suggested that primary reason for this
>>>>> restriction is how file permissions for symlinks and special files
>>>>> are little different from regular files and directories.
>>>>>
>>>>> For symlinks, they are world readable/writable and if user xattr were
>>>>> to be permitted, it will allow unpriviliged users to dump a huge amount
>>>>> of user.* xattrs on symlinks without any control.
>>>>>
>>>>> For special files, permissions typically control capability to read/write
>>>>> from devices (and not necessarily from filesystem). So if a user can
>>>>> write to device (/dev/null), does not necessarily mean it should be allowed
>>>>> to write large number of user.* xattrs on the filesystem device node is
>>>>> residing in.
>>>>>
>>>>> This patch proposes to relax the restrictions a bit and allow file owner
>>>>> or priviliged user (CAP_FOWNER), to be able to read/write user.* xattrs
>>>>> on symlink and special files.
>>>>>
>>>>> virtiofs daemon has a need to store user.* xatrrs on all the files
>>>>> (including symlinks and special files), and currently that fails. This
>>>>> patch should help.
>>>>>
>>>>> Link: https://lore.kernel.org/linux-fsdevel/20210625191229.1752531-1-vgoyal@redhat.com/
>>>>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>>>>> ---
>>>> Seems reasonable and useful.
>>>> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
>>>>
>>>> One question, do all filesystem supporting xattrs deal with setting them
>>>> on symlinks/device files correctly?
>>> Wrote a simple bash script to do setfattr/getfattr user.foo xattr on
>>> symlink and device node on ext4, xfs and btrfs and it works fine.
>> How about nfs, tmpfs, overlayfs and/or some of the other less conventional
>> filesystems?
>>
> How about virtiofs then ? :-)

One of the "less conventional filesystems", surely.
�

