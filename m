DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=date:from:to:cc:subject:message-id:references:mime-version
	:content-disposition:in-reply-to:user-agent;
	bh=LQpq7O1YMaucXfqNE42ffNAF5BWjyrNNE20lAZY18P4=;
	b=TQovYW/QQsSnR+f64MSbpnLajeBdM6NQgrTcQ3MsDIg1h3qg5Xs1UmwIs4HMjaI1zd
	lhYbOWSwYhDqv8/nGqCIPJL0MJSUkYOHiWsj+bniro5EtirBov2xLZIbeCZ/3hJJxmWd
	Ul8dHLHajM3PfCbC1whknSQVxcQYvxq0cf6F+V05S73yRIuCEZLdn0RxktLsDXl50Wv0
	ijaxJSAf+e2QwasInUOJkyDUdaMuQcPaPPFiXGF5ucvW0cC+ArhbLY81S1vb4CMotnUL
	Km7QGXTG1ah5+el5ZmklGbnz70rAI9M3Ja2/+16N/02ziV2O0nNF64SHTYFHnRQTdMCU
	zNpQ==
Date: Wed, 31 Jul 2019 14:43:25 -0400
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <20190731184325.zkldifrl2erbmact@gabell>
References: <20190730215000.15660-1-msys.mizuma@gmail.com>
	<20190731150443.GC7363@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731150443.GC7363@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Add gettimeofday to the seccomp
 whitelist
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

On Wed, Jul 31, 2019 at 04:04:43PM +0100, Stefan Hajnoczi wrote:
> On Tue, Jul 30, 2019 at 05:50:00PM -0400, Masayoshi Mizuma wrote:
> > From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> > 
> > When I run fsstress on the virtio filesystem, virtiofsd sometimes
> > exits abnormally because it receives SIGSYS.
> > 
> > >From strace:
> >   195852 15:07:47.799331 read(8, "\1\0\0\0\0\0\0\0", 8) = 8 <0.000011>
> >   195852 15:07:47.799379 gettimeofday( <unfinished ...>
> >   195852 15:07:53.354340 <... gettimeofday resumed> <unfinished ...>) = ?
> >   195852 15:07:53.400243 +++ killed by SIGSYS (core dumped) +++
> > 
> > That is because virtiofsd calls gettimeofday() system call but
> > the system call isn't in the seccomp whitelist.
> > 
> > virtiofsd doesn't call gettimeofday() directly. glib library
> > function may call g_get_current_time() and g_get_current_time()
> > calls the system call.
> > 
> > Add gettimeofday() to the seccomp whitelist.
> > 
> > Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> > ---
> >  contrib/virtiofsd/seccomp.c | 1 +
> >  1 file changed, 1 insertion(+)
> 
> Have you checked that your guest is using the vdso gettimeofday()
> implementation?  gettimeofday() is implemented in userspace without a
> syscall using vdso to improve performance.  If your guest isn't using it
> then performance will be worse.  (There is a fallback code path in the
> vdso that invokes the syscall but I'm not sure it is taken in normal
> cases.)

Yes, my guest is using the vdso gettimeofday().
I'm not sure why virtiofsd calls gettimeofday(), probably the glib
library function calls g_get_current_time() and the glib function
calls gettimeofday().

> 
> The patch is fine though:
> 
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

Thank you so much!

- Masa

