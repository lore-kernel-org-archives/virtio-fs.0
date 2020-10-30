Message-ID: <8b57dd7972f54fcf271a5790696cbd6c950269ff.camel@redhat.com>
From: Qian Cai <cai@redhat.com>
Date: Fri, 30 Oct 2020 08:00:03 -0400
In-Reply-To: <CAJfpegv4jLewQ4G_GdxraTE8fGHy7-d52gPSi4ZAOp0N4aYJnw@mail.gmail.com>
References: <c4cb4b41655bc890b9dbf40bd2c133cbcbef734d.camel@redhat.com>
	<89f0dbf6713ebd44ec519425e3a947e71f7aed55.camel@redhat.com>
	<CAJfpegv4jLewQ4G_GdxraTE8fGHy7-d52gPSi4ZAOp0N4aYJnw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] WARN_ON(fuse_insert_writeback(root,
	wpa)) in tree_insert()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs-list <virtio-fs@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org

On Thu, 2020-10-29 at 16:20 +0100, Miklos Szeredi wrote:
> On Thu, Oct 29, 2020 at 4:02 PM Qian Cai <cai@redhat.com> wrote:
> > On Wed, 2020-10-07 at 16:08 -0400, Qian Cai wrote:
> > > Running some fuzzing by a unprivileged user on virtiofs could trigger the
> > > warning below. The warning was introduced not long ago by the commit
> > > c146024ec44c ("fuse: fix warning in tree_insert() and clean up writepage
> > > insertion").
> > > 
> > > From the logs, the last piece of the fuzzing code is:
> > > 
> > > fgetxattr(fd=426, name=0x7f39a69af000, value=0x7f39a8abf000, size=1)
> > 
> > I can still reproduce it on today's linux-next. Any idea on how to debug it
> > further?
> 
> Can you please try the attached patch?

So far so good. I'll keep running it over the weekend to be a little bit sure.
It was taking a while to reproduce.

