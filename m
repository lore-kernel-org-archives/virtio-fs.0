From: "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Date: Wed, 7 Aug 2019 22:52:08 +0000
Message-ID: <1E91073893EF8F498411079ED374F912460D57A6@ORSMSX115.amr.corp.intel.com>
References: <20190807212610.GG18557@redhat.com>
In-Reply-To: <20190807212610.GG18557@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] Rebased kernel patches to 5.3-rc kernel
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, virtio-fs-list <virtio-fs@redhat.com>

Thank you Vivek! I'm definitely gonna try this new branch soon, and I'll let you know if I run into any issue :)

Thanks,
Sebastien
________________________________________
From: Vivek Goyal [vgoyal@redhat.com]
Sent: Wednesday, August 07, 2019 2:26 PM
To: virtio-fs-list
Cc: Boeuf, Sebastien
Subject: Rebased kernel patches to 5.3-rc kernel

Hi All,

I have rebased virtio_fs kernel patches to 5.3-rc kernel and pushed it to my
github repo.

https://github.com/rhvgoyal/linux/commits/vivek-5.3-aug-07-2019

This compiles and passes basic tests. It needs more testing though.

It needs one patch in virtiofsd to change bit position of MAP_ALIGNMENT
flag. I posted a patch for that.

Give it a try and let us know if you face issues.

Thanks
Vivek


