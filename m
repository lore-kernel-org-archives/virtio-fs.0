Date: Wed, 23 Sep 2020 08:59:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200923125949.GA88270@redhat.com>
References: <20200918213436.GA3520@redhat.com>
	<CAJFHJroSeg=Zk1VaHBzwurNTkziFzupiiVf_Y-2TDQ7nmdAERg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJFHJroSeg=Zk1VaHBzwurNTkziFzupiiVf_Y-2TDQ7nmdAERg@mail.gmail.com>
Subject: Re: [Virtio-fs] tools/virtiofs: Multi threading seems to hurt
 performance
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

On Wed, Sep 23, 2020 at 09:50:59PM +0900, Chirantan Ekbote wrote:
> On Sat, Sep 19, 2020 at 6:36 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > Hi All,
> >
> > virtiofsd default thread pool size is 64. To me it feels that in most of
> > the cases thread pool size 1 performs better than thread pool size 64.
> >
> > I ran virtiofs-tests.
> >
> > https://github.com/rhvgoyal/virtiofs-tests
> >
> > And here are the comparision results. To me it seems that by default
> > we should switch to 1 thread (Till we can figure out how to make
> > multi thread performance better even when single process is doing
> > I/O in client).
> >
> 
> FWIW, we've observed the same behavior in crosvm. Using a thread pool
> for the virtiofs server consistently gave us worse performance than
> using a single thread.

Thanks for sharing this information Chirantan. Shared pool seems to
perform better than exclusive pool. Single thread vs shared pool is
sort of mixed result but it looks like one thread beats shared pool
results in many of the tests.

May be we will have to swtich to single thread as default at some point
of time if shared pool does not live up to the expectations.

Vivek

