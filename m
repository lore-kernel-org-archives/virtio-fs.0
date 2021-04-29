Date: Thu, 29 Apr 2021 08:53:05 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210429125305.GA1883535@redhat.com>
References: <6b2e27a4-8bee-3649-95a4-a2cea45a18e4@gmail.com>
	<YIkZhqKaLat6Q9YH@work-vm>
	<afb9df25-cf79-19d1-0085-fd72c6225013@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <afb9df25-cf79-19d1-0085-fd72c6225013@gmail.com>
Subject: Re: [Virtio-fs] Min host / vm kernel rev for basic DAX ops?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Harry G. Coin" <hgcoin@gmail.com>
Cc: virtio-fs@redhat.com

On Wed, Apr 28, 2021 at 04:00:40PM -0500, Harry G. Coin wrote:
>=20
> On 4/28/21 3:15 AM, Dr. David Alan Gilbert wrote:
> > * Harry G. Coin (hgcoin@gmail.com) wrote:
> >> Kindly answer a couple 'basic' virtiofs questions:
> >>
> >> 1) Which mainline kernel version is necessary for the host, and for the
> >> vm to enable reliable DAX operations -- supposing no shared host
> >> activity on the underlying fs.
> > I don't think there's any host kernel dependency for DAX
> > currently.
> > (You do need a guest with the DAX support)
>=20
> At least the version of the 'virt-manager' on fedora 33 doesn't support
> the 'cache-size' host option, which as I understand from a post a few
> days ago should be around 4G.=A0 That's why I asked about the host
> requirements.

Generally there are no specifix host requirements. Guest kernel should
have virtiofs DAX support. Also qemu needs dax support (option
cache-size). That's not usptream yet. David has been posting patches
for review. Hopefully it will be merged soon.

W.r.t how big cache-size should be. I would say ideally it needs to
be atleast as big as size of filesystem you are exporting into the
guest. If filesystem is too small, I would think atleast 4G as minimum
dax window size.

Thanks
Vivek

