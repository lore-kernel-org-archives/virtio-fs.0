Return-Path: <vgoyal@redhat.com>
Date: Wed, 28 Sep 2022 15:28:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YzSgeDdpHOw1hTM0@redhat.com>
References: <4362261a-c762-4666-84e2-03c9daa6c4d9@www.fastmail.com>
 <YzMmu3xfOtQwuFUx@redhat.com> <YzMrYAJQeSP2hDSs@redhat.com>
 <CAJh=p+5rQDBJJC8VNGL10KYgDeq-Hg5WK7avONCti03eJGH+ow@mail.gmail.com>
 <798fe353-9537-44fe-a76a-819e8c93abb5@www.fastmail.com>
 <YzNZnPiUqySu6sGh@fedora>
 <20220928083340.eyizwu6mm3cc3bxu@mhamilton>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928083340.eyizwu6mm3cc3bxu@mhamilton>
Subject: Re: [Virtio-fs] virtiofsd: Any reason why there's not an "openat2"
 sandbox mode?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Sergio Lopez <slp@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, Colin Walters <walters@verbum.org>, virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

On Wed, Sep 28, 2022 at 10:33:40AM +0200, Sergio Lopez wrote:
> On Tue, Sep 27, 2022 at 04:14:20PM -0400, Stefan Hajnoczi wrote:
> > On Tue, Sep 27, 2022 at 01:51:41PM -0400, Colin Walters wrote:
> > > 
> > > 
> > > On Tue, Sep 27, 2022, at 1:27 PM, German Maglione wrote:
> > > >
> > > >> > Now all the development has moved to rust virtiofsd.
> > > 
> > > Oh, awesome!!  The code there looks great.
> > > 
> > > > I could work on this for the next major version and see if anything breaks.
> > > > But I prefer to add this as a compilation feature, instead of a command line
> > > > option that we will then have to maintain for a while.
> > > 
> > > Hmm, what would be the issue with having the code there by default?  I think rather than any new command line option, we automatically use `openat2+RESOLVE_IN_ROOT` if the process is run as a nonzero uid.
> > > 
> > > > Also, I don't see it as a sandbox feature, as Stefan mentioned, a compromised
> > > > process can call openat2() without RESOLVE_IN_ROOT. 
> > > 
> > > I'm a bit skeptical honestly about how secure the existing namespace code is against a compromised virtiofsd process.  The primary worry is guest filesystem traversals, right?  openat2+RESOLVE_IN_ROOT addresses that.  Plus being in Rust makes this dramatically safer.
> > > 
> > > > I did some test with
> > > > Landlock to lock virtiofsd inside the shared directory, but IIRC it requires a
> > > > kernel 5.13
> > > 
> > > But yes, landlock and other things make sense, I just don't see these things as strongly linked.  IOW we shouldn't in my opinion block unprivileged virtiofsd on more sandboxing than openat2 already gives us.
> > 
> > I think openat2(RESOLVE_IN_ROOT) support should be added unless there is
> > another unprivileged mechanism that is stronger.
> > 
> > The security implications need to be covered in the user documentation
> > so people can decide whether using this mode is appropriate.
> > 
> > We should continue to explain the difference between a voluntary
> > mechanism like openat2(RESOLVE_IN_ROOT) and a mandatory mechanism like
> > mount namespaces with pivot_root(2). Rust programs are not immune to
> > arbitrary code execution, but it's less likely than with a C program.
> 
> I agree. Perhaps we could modify the "none" sandbox mode to use
> openat2, if available, and add an "openat2" mode which does basically
> the same thing, but bailing out if openat2 is not available.

Sounds reasonable. In fact, we could probably do someting similar
for "landlock" as well. 

Vivek

> 
> And explain this clearly in the docs, of course.
> 
> Sergio.


