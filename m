Date: Thu, 23 Dec 2021 09:16:25 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YcSEueszSHTTn/7G@redhat.com>
References: <20211223112219.7z6k4zrxq42intge@mhamilton>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211223112219.7z6k4zrxq42intge@mhamilton>
Subject: Re: [Virtio-fs] Announcing the release of virtiofsd (Rust) v1.0.0
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Sergio Lopez <slp@redhat.com>
Cc: virtio-fs@redhat.com

On Thu, Dec 23, 2021 at 12:22:19PM +0100, Sergio Lopez wrote:
> Hi,
> 
> On behalf of the Virtiofs Maintainers Team, it's my pleasure to
> announce the release of virtiofsd v1.0.0, the first stable release of
> the Rust implementation of the vhost-user virtiofs daemon.
> 
> This version is intended to be a drop-in replacement for the legacy C
> implementation, including support for most of its command line
> arguments.

Thanks Sergio. This is excellent news. Was looking forward to v1.0.0
release. I have already done some basic testing of pre v1.0.0 version
and it looked good to me. Will spend some time testing v1.0.0 as well.

Thanks
Vivek

> 
> You can obtain the sources for this version by checking out the
> corresponding tag [1]. This version has also been published on
> crates.io [2], so it's also possible to install it from sources with a
> single command, by running "cargo install virtiofsd".
> 
> Thanks,
> Sergio.
> 
> [1] https://gitlab.com/virtio-fs/virtiofsd/-/tags/v1.0.0
> [2] https://crates.io/crates/virtiofsd



> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs

