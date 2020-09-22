Date: Tue, 22 Sep 2020 18:56:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200922225602.GJ57620@redhat.com>
References: <20200918213436.GA3520@redhat.com>
	<20200921201641.GD13362@redhat.com> <20200922110946.GB2836@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200922110946.GB2836@work-vm>
Subject: Re: [Virtio-fs] tools/virtiofs: Multi threading seems to hurt
	performance
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org, Miklos Szeredi <miklos@szeredi.hu>

On Tue, Sep 22, 2020 at 12:09:46PM +0100, Dr. David Alan Gilbert wrote:
> 
> Do you have the numbers for:
>    epool
>    epool thread-pool-size=1
>    spool

Hi David,

Ok, I re-ran my numbers again after upgrading to latest qemu and also
upgraded host kernel to latest upstream. Apart from comparing I epool,
spool and 1Thread, I also ran their numa variants. That is I launched
qemu and virtiofsd on node 0 of machine (numactl --cpunodebind=0).

Results are kind of mixed. Here are my takeaways.

- Running on same numa node improves performance overall for exclusive,
  shared and exclusive-1T mode.

- In general both shared pool and exclusive-1T mode seem to perform
  better than exclusive mode, except for the case of randwrite-libaio.
  In some cases (seqread-libaio, seqwrite-libaio, seqwrite-libaio-multi)
  exclusive pool performs better than exclusive-1T.

- Looks like in some cases exclusive-1T performs better than shared
  pool. (randwrite-libaio, randwrite-psync-multi, seqwrite-psync-multi,
  seqwrite-psync, seqread-libaio-multi, seqread-psync-multi)


Overall, I feel that both exlusive-1T and shared perform better than
exclusive pool. Results between exclusive-1T and shared pool are mixed.
It seems like in many cases exclusve-1T performs better. I would say
that moving to "shared" pool seems like a reasonable option.

Thanks
Vivek

NAME                    WORKLOAD                Bandwidth       IOPS            
vtfs-none-epool         seqread-psync           38(MiB/s)       9967            
vtfs-none-epool-1T      seqread-psync           66(MiB/s)       16k             
vtfs-none-spool         seqread-psync           67(MiB/s)       16k             
vtfs-none-epool-numa    seqread-psync           48(MiB/s)       12k             
vtfs-none-epool-1T-numa seqread-psync           74(MiB/s)       18k             
vtfs-none-spool-numa    seqread-psync           74(MiB/s)       18k             

vtfs-none-epool         seqread-psync-multi     204(MiB/s)      51k             
vtfs-none-epool-1T      seqread-psync-multi     325(MiB/s)      81k             
vtfs-none-spool         seqread-psync-multi     271(MiB/s)      67k             
vtfs-none-epool-numa    seqread-psync-multi     253(MiB/s)      63k             
vtfs-none-epool-1T-numa seqread-psync-multi     349(MiB/s)      87k             
vtfs-none-spool-numa    seqread-psync-multi     301(MiB/s)      75k             

vtfs-none-epool         seqread-libaio          301(MiB/s)      75k             
vtfs-none-epool-1T      seqread-libaio          273(MiB/s)      68k             
vtfs-none-spool         seqread-libaio          334(MiB/s)      83k             
vtfs-none-epool-numa    seqread-libaio          315(MiB/s)      78k             
vtfs-none-epool-1T-numa seqread-libaio          326(MiB/s)      81k             
vtfs-none-spool-numa    seqread-libaio          335(MiB/s)      83k             

vtfs-none-epool         seqread-libaio-multi    202(MiB/s)      50k             
vtfs-none-epool-1T      seqread-libaio-multi    308(MiB/s)      77k             
vtfs-none-spool         seqread-libaio-multi    247(MiB/s)      61k             
vtfs-none-epool-numa    seqread-libaio-multi    238(MiB/s)      59k             
vtfs-none-epool-1T-numa seqread-libaio-multi    307(MiB/s)      76k             
vtfs-none-spool-numa    seqread-libaio-multi    269(MiB/s)      67k             

vtfs-none-epool         randread-psync          41(MiB/s)       10k             
vtfs-none-epool-1T      randread-psync          67(MiB/s)       16k             
vtfs-none-spool         randread-psync          64(MiB/s)       16k             
vtfs-none-epool-numa    randread-psync          48(MiB/s)       12k             
vtfs-none-epool-1T-numa randread-psync          73(MiB/s)       18k             
vtfs-none-spool-numa    randread-psync          72(MiB/s)       18k             

vtfs-none-epool         randread-psync-multi    207(MiB/s)      51k             
vtfs-none-epool-1T      randread-psync-multi    313(MiB/s)      78k             
vtfs-none-spool         randread-psync-multi    265(MiB/s)      66k             
vtfs-none-epool-numa    randread-psync-multi    253(MiB/s)      63k             
vtfs-none-epool-1T-numa randread-psync-multi    340(MiB/s)      85k             
vtfs-none-spool-numa    randread-psync-multi    305(MiB/s)      76k             

vtfs-none-epool         randread-libaio         305(MiB/s)      76k             
vtfs-none-epool-1T      randread-libaio         308(MiB/s)      77k             
vtfs-none-spool         randread-libaio         329(MiB/s)      82k             
vtfs-none-epool-numa    randread-libaio         310(MiB/s)      77k             
vtfs-none-epool-1T-numa randread-libaio         328(MiB/s)      82k             
vtfs-none-spool-numa    randread-libaio         339(MiB/s)      84k             

vtfs-none-epool         randread-libaio-multi   265(MiB/s)      66k             
vtfs-none-epool-1T      randread-libaio-multi   267(MiB/s)      66k             
vtfs-none-spool         randread-libaio-multi   269(MiB/s)      67k             
vtfs-none-epool-numa    randread-libaio-multi   314(MiB/s)      78k             
vtfs-none-epool-1T-numa randread-libaio-multi   319(MiB/s)      79k             
vtfs-none-spool-numa    randread-libaio-multi   318(MiB/s)      79k             

vtfs-none-epool         seqwrite-psync          36(MiB/s)       9224            
vtfs-none-epool-1T      seqwrite-psync          67(MiB/s)       16k             
vtfs-none-spool         seqwrite-psync          61(MiB/s)       15k             
vtfs-none-epool-numa    seqwrite-psync          44(MiB/s)       11k             
vtfs-none-epool-1T-numa seqwrite-psync          69(MiB/s)       17k             
vtfs-none-spool-numa    seqwrite-psync          68(MiB/s)       17k             

vtfs-none-epool         seqwrite-psync-multi    193(MiB/s)      48k             
vtfs-none-epool-1T      seqwrite-psync-multi    299(MiB/s)      74k             
vtfs-none-spool         seqwrite-psync-multi    240(MiB/s)      60k             
vtfs-none-epool-numa    seqwrite-psync-multi    233(MiB/s)      58k             
vtfs-none-epool-1T-numa seqwrite-psync-multi    358(MiB/s)      89k             
vtfs-none-spool-numa    seqwrite-psync-multi    285(MiB/s)      71k             

vtfs-none-epool         seqwrite-libaio         265(MiB/s)      66k             
vtfs-none-epool-1T      seqwrite-libaio         245(MiB/s)      61k             
vtfs-none-spool         seqwrite-libaio         312(MiB/s)      78k             
vtfs-none-epool-numa    seqwrite-libaio         295(MiB/s)      73k             
vtfs-none-epool-1T-numa seqwrite-libaio         282(MiB/s)      70k             
vtfs-none-spool-numa    seqwrite-libaio         297(MiB/s)      74k             

vtfs-none-epool         seqwrite-libaio-multi   313(MiB/s)      78k             
vtfs-none-epool-1T      seqwrite-libaio-multi   299(MiB/s)      74k             
vtfs-none-spool         seqwrite-libaio-multi   315(MiB/s)      78k             
vtfs-none-epool-numa    seqwrite-libaio-multi   318(MiB/s)      79k             
vtfs-none-epool-1T-numa seqwrite-libaio-multi   410(MiB/s)      102k            
vtfs-none-spool-numa    seqwrite-libaio-multi   378(MiB/s)      94k             

vtfs-none-epool         randwrite-psync         33(MiB/s)       8629            
vtfs-none-epool-1T      randwrite-psync         61(MiB/s)       15k             
vtfs-none-spool         randwrite-psync         63(MiB/s)       15k             
vtfs-none-epool-numa    randwrite-psync         49(MiB/s)       12k             
vtfs-none-epool-1T-numa randwrite-psync         68(MiB/s)       17k             
vtfs-none-spool-numa    randwrite-psync         66(MiB/s)       16k             

vtfs-none-epool         randwrite-psync-multi   186(MiB/s)      46k             
vtfs-none-epool-1T      randwrite-psync-multi   300(MiB/s)      75k             
vtfs-none-spool         randwrite-psync-multi   233(MiB/s)      58k             
vtfs-none-epool-numa    randwrite-psync-multi   235(MiB/s)      58k             
vtfs-none-epool-1T-numa randwrite-psync-multi   355(MiB/s)      88k             
vtfs-none-spool-numa    randwrite-psync-multi   266(MiB/s)      66k             

vtfs-none-epool         randwrite-libaio        289(MiB/s)      72k             
vtfs-none-epool-1T      randwrite-libaio        284(MiB/s)      71k             
vtfs-none-spool         randwrite-libaio        278(MiB/s)      69k             
vtfs-none-epool-numa    randwrite-libaio        292(MiB/s)      73k             
vtfs-none-epool-1T-numa randwrite-libaio        294(MiB/s)      73k             
vtfs-none-spool-numa    randwrite-libaio        290(MiB/s)      72k             

vtfs-none-epool         randwrite-libaio-multi  317(MiB/s)      79k             
vtfs-none-epool-1T      randwrite-libaio-multi  323(MiB/s)      80k             
vtfs-none-spool         randwrite-libaio-multi  330(MiB/s)      82k             
vtfs-none-epool-numa    randwrite-libaio-multi  315(MiB/s)      78k             
vtfs-none-epool-1T-numa randwrite-libaio-multi  409(MiB/s)      102k            
vtfs-none-spool-numa    randwrite-libaio-multi  384(MiB/s)      96k             

