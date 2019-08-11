References: <20190809082536.56402-1-eguan@linux.alibaba.com>
	<20190809082536.56402-2-eguan@linux.alibaba.com>
	<5D4D3FA8.707@huawei.com> <20190811132126.GC2665@desktop>
From: piaojun <piaojun@huawei.com>
Message-ID: <79351a19-57a6-51f0-733f-af1a11200176@huawei.com>
Date: Sun, 11 Aug 2019 22:12:33 +0800
MIME-Version: 1.0
In-Reply-To: <20190811132126.GC2665@desktop>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH 2/2] virtiofsd: convert more fprintf and
 perror to use fuse log infra
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eryu Guan <guaneryu@gmail.com>
Cc: virtio-fs@redhat.com



On 2019/8/11 21:21, Eryu Guan wrote:
> On Fri, Aug 09, 2019 at 05:40:56PM +0800, piaojun wrote:
>> Hi Eryu,
>>
>> Could fuse_err() print to stderr as well?
> 
> Yes, when "--syslog" is not used :)

Got it, thanks.

> 
> Thanks,
> Eryu
> 
>>
>> Jun
>>
>> On 2019/8/9 16:25, Eryu Guan wrote:
>>> Signed-off-by: Eryu Guan <eguan@linux.alibaba.com>
>>> ---
>>>  contrib/virtiofsd/fuse_lowlevel.c |  6 +++---
>>>  contrib/virtiofsd/fuse_signals.c  |  7 +++++--
>>>  contrib/virtiofsd/fuse_virtio.c   | 16 ++++++++--------
>>>  contrib/virtiofsd/helper.c        |  6 +++---
>>>  4 files changed, 19 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
>>> index 7eec2680b6de..8ef800239f1e 100644
>>> --- a/contrib/virtiofsd/fuse_lowlevel.c
>>> +++ b/contrib/virtiofsd/fuse_lowlevel.c
>>> @@ -1901,15 +1901,15 @@ static void do_removemapping(fuse_req_t req, fuse_ino_t nodeid,
>>>  
>>>  	arg = fuse_mbuf_iter_advance(iter, sizeof(*arg));
>>>  	if (!arg || arg->count <= 0) {
>>> -		fprintf(stderr, "do_removemapping: invalid arg %p\n", arg);
>>> +		fuse_err("do_removemapping: invalid arg %p\n", arg);
>>>  		fuse_reply_err(req, EINVAL);
>>>  		return;
>>>  	}
>>>  
>>>  	one = fuse_mbuf_iter_advance(iter, arg->count * sizeof(*one));
>>>  	if (!one) {
>>> -		fprintf(stderr, "do_removemapping: invalid in, expected %d * %ld, has %ld - %ld\n",
>>> -				arg->count, sizeof(*one), iter->size, iter->pos);
>>> +		fuse_err("do_removemapping: invalid in, expected %d * %ld, has %ld - %ld\n",
>>> +			 arg->count, sizeof(*one), iter->size, iter->pos);
>>>  		fuse_reply_err(req, EINVAL);
>>>  		return;
>>>  	}
>>> diff --git a/contrib/virtiofsd/fuse_signals.c b/contrib/virtiofsd/fuse_signals.c
>>> index aa3bdba7daaf..9d34f6b04025 100644
>>> --- a/contrib/virtiofsd/fuse_signals.c
>>> +++ b/contrib/virtiofsd/fuse_signals.c
>>> @@ -12,6 +12,7 @@
>>>  #include "fuse_log.h"
>>>  #include "fuse_lowlevel.h"
>>>  
>>> +#include <errno.h>
>>>  #include <stdio.h>
>>>  #include <string.h>
>>>  #include <signal.h>
>>> @@ -47,13 +48,15 @@ static int set_one_signal_handler(int sig, void (*handler)(int), int remove)
>>>  	sa.sa_flags = 0;
>>>  
>>>  	if (sigaction(sig, NULL, &old_sa) == -1) {
>>> -		perror("fuse: cannot get old signal handler");
>>> +		fuse_err("fuse: cannot get old signal handler: %s\n",
>>> +			 strerror(errno));
>>>  		return -1;
>>>  	}
>>>  
>>>  	if (old_sa.sa_handler == (remove ? handler : SIG_DFL) &&
>>>  	    sigaction(sig, &sa, NULL) == -1) {
>>> -		perror("fuse: cannot set signal handler");
>>> +		fuse_err("fuse: cannot set signal handler: %s\n",
>>> +			 strerror(errno));
>>>  		return -1;
>>>  	}
>>>  	return 0;
>>> diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
>>> index 5b3174e4c74c..2ce0a9cf816e 100644
>>> --- a/contrib/virtiofsd/fuse_virtio.c
>>> +++ b/contrib/virtiofsd/fuse_virtio.c
>>> @@ -675,7 +675,7 @@ static void *fv_queue_thread(void *opaque)
>>>                                 fuse_info("%s: ppoll interrupted, going around\n", __func__);
>>>                                 continue;
>>>                         }
>>> -                       perror("fv_queue_thread ppoll");
>>> +                       fuse_err("fv_queue_thread ppoll: %s\n", strerror(errno));
>>>                         break;
>>>                 }
>>>                 assert(poll_res >= 1);
>>> @@ -700,7 +700,7 @@ static void *fv_queue_thread(void *opaque)
>>>  
>>>                 eventfd_t evalue;
>>>                 if (eventfd_read(qi->kick_fd, &evalue)) {
>>> -                       perror("Eventfd_read for queue");
>>> +                       fuse_err("Eventfd_read for queue: %s\n", strerror(errno));
>>>                         break;
>>>                 }
>>>  
>>> @@ -805,7 +805,7 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
>>>  
>>>                  /* Kill the thread */
>>>                  if (eventfd_write(ourqi->kill_fd, 1)) {
>>> -                       perror("Eventfd_read for queue");
>>> +                       fuse_err("Eventfd_read for queue: %s\n", strerror(errno));
>>>                  }
>>>                  ret = pthread_join(ourqi->thread, NULL);
>>>                  if (ret) {
>>> @@ -859,7 +859,7 @@ int virtio_loop(struct fuse_session *se)
>>>                                 fuse_info("%s: ppoll interrupted, going around\n", __func__);
>>>                                 continue;
>>>                         }
>>> -                       perror("virtio_loop ppoll");
>>> +                       fuse_err("virtio_loop ppoll: %s\n", strerror(errno));
>>>                         break;
>>>                 }
>>>                 assert(poll_res == 1);
>>> @@ -913,18 +913,18 @@ static int fv_create_listen_socket(struct fuse_session *se)
>>>  
>>>          int listen_sock = socket(AF_UNIX, SOCK_STREAM, 0);
>>>          if (listen_sock == -1) {
>>> -               perror("vhost socket creation");
>>> +               fuse_err("vhost socket creation: %s\n", strerror(errno));
>>>                 return -1;
>>>          }
>>>          un.sun_family = AF_UNIX;
>>>  
>>>          if (bind(listen_sock, (struct sockaddr *) &un, addr_len) == -1) {
>>> -                perror("vhost socket bind");
>>> +                fuse_err("vhost socket bind: %s\n", strerror(errno));
>>>                  return -1;
>>>          }
>>>  
>>>          if (listen(listen_sock, 1) == -1) {
>>> -                perror("vhost socket listen");
>>> +                fuse_err("vhost socket listen: %s\n", strerror(errno));
>>>                  return -1;
>>>          }
>>>  
>>> @@ -949,7 +949,7 @@ int virtio_session_mount(struct fuse_session *se)
>>>          fuse_err("%s: Waiting for vhost-user socket connection...\n", __func__);
>>>          int data_sock = accept(se->vu_listen_fd, NULL, NULL);
>>>          if (data_sock == -1) {
>>> -                perror("vhost socket accept");
>>> +                fuse_err("vhost socket accept: %s\n", strerror(errno));
>>>                  close(se->vu_listen_fd);
>>>                  return -1;
>>>          }
>>> diff --git a/contrib/virtiofsd/helper.c b/contrib/virtiofsd/helper.c
>>> index dc80100e8594..4c7145208028 100644
>>> --- a/contrib/virtiofsd/helper.c
>>> +++ b/contrib/virtiofsd/helper.c
>>> @@ -189,7 +189,7 @@ int fuse_daemonize(int foreground)
>>>  		char completed;
>>>  
>>>  		if (pipe(waiter)) {
>>> -			perror("fuse_daemonize: pipe");
>>> +			fuse_err("fuse_daemonize: pipe: %s\n", strerror(errno));
>>>  			return -1;
>>>  		}
>>>  
>>> @@ -199,7 +199,7 @@ int fuse_daemonize(int foreground)
>>>  		 */
>>>  		switch(fork()) {
>>>  		case -1:
>>> -			perror("fuse_daemonize: fork");
>>> +			fuse_err("fuse_daemonize: fork: %s\n", strerror(errno));
>>>  			return -1;
>>>  		case 0:
>>>  			break;
>>> @@ -209,7 +209,7 @@ int fuse_daemonize(int foreground)
>>>  		}
>>>  
>>>  		if (setsid() == -1) {
>>> -			perror("fuse_daemonize: setsid");
>>> +			fuse_err("fuse_daemonize: setsid: %s\n", strerror(errno));
>>>  			return -1;
>>>  		}
>>>  
>>>
>>
>> _______________________________________________
>> Virtio-fs mailing list
>> Virtio-fs@redhat.com
>> https://www.redhat.com/mailman/listinfo/virtio-fs
> .
> 

