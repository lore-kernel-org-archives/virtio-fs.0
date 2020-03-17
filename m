From: "Patrick Ohly" <patrick.ohly@intel.com>
In-Reply-To: <20200316130234.GA4013@redhat.com>
References: <20200304165845.3081-1-vgoyal@redhat.com>
	<yrjh1rpzggg4.fsf@pohly-mobl1.fritz.box>
	<20200316130234.GA4013@redhat.com>
Date: Tue, 17 Mar 2020 09:28:26 +0100
Message-ID: <yrjhlfnzcrmd.fsf@pohly-mobl1.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 00/20] virtiofs: Add DAX support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, mst@redhat.com, linux-fsdevel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:
> We expect users will issue fsync/msync like a regular filesystem to
> make changes persistent. So in that aspect, rejecting MAP_SYNC
> makes sense. I will test and see if current code is rejecting MAP_SYNC
> or not.

Last time I checked, it did. Here's the test program that I wrote for
that:
https://github.com/intel/pmem-csi/blob/ee3200794a1ade49a02df6f359a134115b409e90/test/cmd/pmem-dax-check/main.go

-- 
Best Regards

Patrick Ohly


