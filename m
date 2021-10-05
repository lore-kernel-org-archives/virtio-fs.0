Date: Tue, 5 Oct 2021 13:28:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YVyLNQM8PXO8iDed@redhat.com>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-14-vgoyal@redhat.com>
	<YVxDouMEj3aqTNf3@stefanha-x1.localdomain>
	<YVxsQg+edz0kFmUl@redhat.com>
	<YVx0U8Wg7jahdoJD@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVx0U8Wg7jahdoJD@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 13/13] virtiofsd,
 seccomp: Add clock_nanosleep() to allow list
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, miklos@szeredi.hu

On Tue, Oct 05, 2021 at 04:50:43PM +0100, Stefan Hajnoczi wrote:
> On Tue, Oct 05, 2021 at 11:16:18AM -0400, Vivek Goyal wrote:
> > On Tue, Oct 05, 2021 at 01:22:58PM +0100, Stefan Hajnoczi wrote:
> > > On Thu, Sep 30, 2021 at 11:30:37AM -0400, Vivek Goyal wrote:
> > > > g_usleep() calls nanosleep() and that now seems to call clock_nanosleep()
> > > > syscall. Now these patches are making use of g_usleep(). So add
> > > > clock_nanosleep() to list of allowed syscalls.
> > > > 
> > > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > > ---
> > > >  tools/virtiofsd/passthrough_seccomp.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > > 
> > > > diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/passthrough_seccomp.c
> > > > index cd24b40b78..03080806c0 100644
> > > > --- a/tools/virtiofsd/passthrough_seccomp.c
> > > > +++ b/tools/virtiofsd/passthrough_seccomp.c
> > > > @@ -117,6 +117,7 @@ static const int syscall_allowlist[] = {
> > > >      SCMP_SYS(writev),
> > > >      SCMP_SYS(umask),
> > > >      SCMP_SYS(nanosleep),
> > > > +    SCMP_SYS(clock_nanosleep),
> > > 
> > > This patch can be dropped once sleep has been replaced by a condvar.
> > 
> > There is another sleep in do_pool_destroy() where we are waiting
> > for all current threads to exit.
> > 
> > do_pool_destroy() {
> >     g_usleep(10000);
> > }
> 
> That won't be necessary if there's a way to avoid the thread pool :).
> See my other reply about closing the OFD instead of using signals to
> cancel blocking fcntl(2).

Hi Stefan,

I responded to that email already. man fnctl does not say anything
about closing fd will unblock the waiter with -EINTR and I had a 
quick look at kernel code and did not find anything which suggested
closing fd will unblock current waiters.

So is this something you know works or you want me to try and see
if it works?

Thanks
Vivek

