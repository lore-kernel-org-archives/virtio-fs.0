Date: Wed, 21 Aug 2019 10:47:57 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190821144757.GC2304@redhat.com>
References: <5D53D882.5090803@huawei.com> <5D5A4692.9060006@huawei.com>
	<20190820153926.GC4233@redhat.com>
	<20190820175610.GD4233@redhat.com> <5D5CA2E2.9000802@huawei.com>
	<20190821131136.GA2304@redhat.com>
	<826341e2-6641-1673-3d43-e7e593251c6c@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <826341e2-6641-1673-3d43-e7e593251c6c@huawei.com>
Subject: Re: [Virtio-fs] [PATCH RESEND][RFC] virtiofsd: do not fall back to
 buffer io when cache=auto/always
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>
Cc: virtio-fs@redhat.com

On Wed, Aug 21, 2019 at 10:38:39PM +0800, piaojun wrote:

[..]
> >>
> >> You cleared my first doubt that 'fi->direct_io' and 'fi->keep_cache'
> >> are used to control Guest I/O mode together, and there may be different
> >> I/O modes between Guest and Host if I undersatnd it correctly. I admit
> >> this offers a more flexible config to user, but also introduces more
> >> complex option. Maybe we could just use *keep_cache* to handle all
> >> these options.
> >>
> >> My second doubt is that *keep_cache* is used to control whether reusing
> >> the cache of last open(). IMO, it has nothing to do with the following
> >> I/O path.
> > 
> > FOPEN_KEEP_CACHE is already part of fuse protocol. cache=always is just
> > making use of that option so that cache contents are not discarded upon
> > next open.
> 
> It still confused me that probably we needn't set fi->direct_io if
> CACHE_NONE is set to indicate Guest go direct I/O path. As Guest could
> also go direct I/O through regular path you have mentioned above.

fi->direct_io is needed so that server can *enforce* direct I/O on guest.
If guest applications are not doing direct I/O, without fi->direct_io,
you can't force client to do direct I/O.

Vivek

