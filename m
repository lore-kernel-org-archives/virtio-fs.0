References: <20210414201207.3612432-3-jose.carlos.venegas.munoz@intel.com>
	<CANRX0ORJA43.22ADKWIJW7DI0@redhat>
	<20210419190753.GE1472665@redhat.com>
From: Connor Kuehl <ckuehl@redhat.com>
Message-ID: <81c49957-0287-37f9-e310-5f9f21d03062@redhat.com>
Date: Mon, 19 Apr 2021 14:21:11 -0500
MIME-Version: 1.0
In-Reply-To: <20210419190753.GE1472665@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 2/2] virtiofsd: Add help for -o xattr-mapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, Carlos Venegas <jose.carlos.venegas.munoz@intel.com>, qemu-devel@nongnu.org

On 4/19/21 2:07 PM, Vivek Goyal wrote:
>> This is a helpful note, but it doesn't tell the whole story. I think
>> it'd be helpful to add one last note to this option which is to
>> recommend reading the virtiofsd(1) man-page for more information on
>> xattrmap rules.
> 
> Is there a virtiofsd man page as well? All I see is
> docs/tools/virtiofsd.rst.

Yes, it's generated from that file. Should be located in
qemu/build/docs/virtiofsd.1 after building QEMU.

Connor

