References: <20200214192705.GE18654@redhat.com> <20200214194130.GP3283@work-vm>
	<20200218133821.GE786556@stefanha-x1.localdomain>
	<a3880c0b-32b2-0197-822c-d78fcbfe177c@redhat.com>
	<47f62cf4-5b44-b2f0-52f3-5b889d1c3ac8@redhat.com>
	<20200218185831.GV3080@work-vm>
	<cfab5633-baa7-8dec-e5d3-3d660a8f8694@redhat.com>
	<20200219140628.GA19402@redhat.com>
From: Daniel Walsh <dwalsh@redhat.com>
Message-ID: <05c71006-38e9-f0b7-6bc5-dd4c79871510@redhat.com>
Date: Fri, 21 Feb 2020 10:38:02 -0500
MIME-Version: 1.0
In-Reply-To: <20200219140628.GA19402@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: Re: [Virtio-fs] Effect of nodev, noexec,
 nosuid mount options (Was: Re: One virtiofs daemon per exported dir
 requirement)
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

On 2/19/20 9:06 AM, Vivek Goyal wrote:
> On Tue, Feb 18, 2020 at 04:39:07PM -0500, Daniel Walsh wrote:
>
> [..]
>> What about noexec? nodev? nosuid?
> These flags will take affect on host (but not inside guest). These will
> protect host from guest (in case guest process drops some file in shared dir,
> escapes from guest somehow and take over host system).
>
> nodev will make sure even if guest drops a device file in shared dir,
> it can't open it (if running on host directly). If running inside guest,
> it will fail as device will not be in guest to begin with. If matching
> device in guest is available, guest process should be able to open it.

As we discussed in my office, this is unexpected behavior by the user.

I actually believe Kata inside of the container might be able to take
care of

some of these inside of the VM, but we really need to think in the long
run of

propagating this information to the kernel inside of the VM, so it will
act properly.

> nosuid, also will take affect on host. So if guest process drops a setuid
> root bindary and tries to execute it on host, setuid will not take affect.
> But running same setuid binary inside guest will continue to work.
Which as I pointed out above is a problem.
> noexec also takes affect on host. If guest drops an executable in shared
> directory and some process on host tries to execute it, it will fail. But
> if guest tries to execute that file inside guest, it works.
Same issue.
> IOW, all these flags work on host but have no affect inside guest, as of
> now.

Users will not view a virtiofs as a networked protocol.  So at least we
need to document these in

Kata as shortcomings when using virtiofs.

> Thanks
> Vivek


