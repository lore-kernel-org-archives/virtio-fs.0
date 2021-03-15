Date: Mon, 15 Mar 2021 18:37:37 +0100
From: Greg Kurz <groug@kaod.org>
Message-ID: <20210315183737.19b0d824@bahia.lan>
In-Reply-To: <YE962LeQCJfR03NZ@work-vm>
References: <20210312141003.819108-1-groug@kaod.org>
	<20210312141003.819108-4-groug@kaod.org>
	<20210314233604.GC223210@redhat.com>
	<20210315110630.5ae99490@bahia.lan> <YE962LeQCJfR03NZ@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 3/3] virtiofsd: Don't allow empty filenames
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Vivek Goyal <vgoyal@redhat.com>

On Mon, 15 Mar 2021 15:18:48 +0000
"Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:

> * Greg Kurz (groug@kaod.org) wrote:
> > On Sun, 14 Mar 2021 19:36:04 -0400
> > Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > On Fri, Mar 12, 2021 at 03:10:03PM +0100, Greg Kurz wrote:
> > > > POSIX.1-2017 clearly stipulates that empty filenames aren't
> > > > allowed ([1] and [2]). Since virtiofsd is supposed to mirror
> > > > the host file system hierarchy and the host can be assumed to
> > > > be linux, we don't really expect clients to pass requests with
> > > > an empty path in it. If they do so anyway, this would eventually
> > > > cause an error when trying to create/lookup the actual inode
> > > > on the underlying POSIX filesystem. But this could still confuse
> > > > some code that wouldn't be ready to cope with this.
> > > > 
> > > > Filter out empty names coming from the client at the top level,
> > > > so that the rest doesn't have to care about it. This is done
> > > > everywhere we already call is_safe_path_component(), but
> > > > in a separate helper since the usual error for empty path
> > > > names is ENOENT instead of EINVAL.
> > > > 
> > > > [1] https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap03.html#tag_03_170
> > > > [2] https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap04.html#tag_04_13
> > > > 
> > > > Signed-off-by: Greg Kurz <groug@kaod.org>
> > > 
> > > Hi Greg,
> > > 
> > > Minor nit, if you happen to respin this patch, it probably should come
> > > before the first patch in series. Once we make it clear that file server
> > > is not expecting empty path in these top level functions, then it is
> > > easy to clear AT_EMPTY_PATH in function these paths are calling as
> > > appropriate.
> > > 
> > 
> > The patch order is chronological : I just spotted the AT_EMPTY_PATH
> > oddity before coming up with the bigger hammer of patch 3. But you're
> > right, it probably makes more sense to do the other way around.
> > 
> > > What about lo_create(). Should we put a check in there as well.
> > > 
> > 
> > Good catch ! I'll post a v2 then ;)
> 
> I'm just brewing a pull now, since soft freeze is tomorrow.
> I'll take 3,1,2 - please follow up with a separate lo_create one - we
> can add that later.
> 

Sure, I'll do that.

Cheers,

--
Greg

