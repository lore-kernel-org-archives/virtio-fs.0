Date: Tue, 20 Oct 2020 09:13:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20201020131303.GA380917@redhat.com>
References: <20201008085534.16070-1-stefanha@redhat.com>
	<CAJFHJrohwGOvZax=anXZdFeuTT+uZAJ89Hu9CohgnE-tJEKTiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJFHJrohwGOvZax=anXZdFeuTT+uZAJ89Hu9CohgnE-tJEKTiw@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH v3] virtiofsd: add container-friendly -o
 sandbox=chroot option
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>
Cc: vromanso@redhat.com, qemu-devel@nongnu.org, mpatel@redhat.com, virtio-fs-list <virtio-fs@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, rmohr@redhat.com

On Mon, Oct 19, 2020 at 06:43:41PM +0900, Chirantan Ekbote wrote:
> On Thu, Oct 8, 2020 at 5:55 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> >
> > virtiofsd cannot run in a container because CAP_SYS_ADMIN is required to
> > create namespaces.
> >
> 
> In crosvm we deal with this by also creating a user namespace, which
> then allows us to create the mount, net, and pid namespaces as well.
> Could that also work for virtiofsd?

I think one key question here is that who does the sandboxing. Is it
the contatiner runtime environment or virtiofsd itself. I think what
stefan is trying to do is that container runtime has done the sandboxing
so virtiofsd has not do it.

Having said that, if container runtime has setup things in such a
way that virtiofsd has CAP_SYS_ADMIN, is it desirable that virtiofsd
does pivot_root() instead of chroot()?

Thanks
Vivek

