Date: Tue, 24 Mar 2020 19:52:30 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20200324195230.GH2645@work-vm>
References: <cb5bc383-a669-ebaa-3919-a5f860e10a52@redhat.com>
	<20200323184309.GE3017@work-vm>
	<1c152d0a-cd7c-9474-708b-fa825e97cd4a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1c152d0a-cd7c-9474-708b-fa825e97cd4a@redhat.com>
Subject: Re: [Virtio-fs] xfstest generic/503 hangs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>

* Max Reitz (mreitz@redhat.com) wrote:
> On 23.03.20 19:43, Dr. David Alan Gilbert wrote:
> > * Max Reitz (mreitz@redhat.com) wrote:
> >> Hi,
> >>
> >> I have this bug report here:
> >> https://bugzilla.redhat.com/show_bug.cgi?id=1813885
> >>
> >> And I’m afraid I’m not really making progress on debugging it, so I was
> >> wondering whether any of you might have some insights.
> >>
> >> The problem is that the generic/503 xfstest hangs on virtio-fs.  Now, I
> >> don’t know how the reporter got that test to run in the first place,
> >> because for me, it requires fcollapse and fzero, which as far as I can
> >> tell are currently not supported for virtio-fs.
> >>
> >> So I first had to disable those requirements, and then let the helper
> >> program (src/t_mmap_collision.c) not test those operations.
> >>
> >> Then, the test hangs.  What I could find out so far is that the hang
> >> occurs in src/t_mmap_collision.c’s truncate_down_fn() (run through
> >> run_test(&truncate_down_fn), namely in one of the pread()s.  I can also
> >> see that some of the pread()s before fail with EFAULT.
> >>
> >> A bit more context: t_mmap_collision.c opens a test file twice (I think
> >> the idea is that you open it once on an FS with DAX, and once without,
> >> but AFAIU it should work either way).  For the relevant test, it mmap()s
> >> the DAX FD, truncates it, then fallocates it to increase the size again.
> >>  Then it reads from the non-DAX FD.
> > 
> > Can you just confirm where the DAX is happening here?  As I read that bz
> > entry it's using the qemu which doesn't have DAX code yet.
> 
> I actually don’t know whether it really uses DAX.  When I say “DAX” here
> (and “dax_fd”), I mean it in the spirit of the test, which tries to open
> a file once with DAX and once without.  But it isn’t like it verifies
> that the first instance actually uses DAX.
> 
> So I think it rather likely that it doesn’t use DAX, and just two FDs
> for a single file concurrently.

OK, I don't think DAX is really involved.

Does Liu Bo's: 
https://www.redhat.com/archives/virtio-fs/2020-March/msg00074.html

help?

Dave

> Max
> 



--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

