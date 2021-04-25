DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=bytedance-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=O+75goH7t5zz8QAGLz6O+cU0KWyj3W6aJBd+xmsTjis=;
	b=IpqTnKElLyTB6gXBSPU5B//oTkxuECY/Q+4g+cSQN0E+hDWF0kx19s9oq3nIa17hSq
	vTqPpArrANX1+r5Ky7NanNWtyw42UblzyiYPIDo864FY2symeaMzQKmXkyFZM7X+MhN2
	EMVYMYwlNrublqdU6NgFqssRww8MVTxz4yq8u64F7p+TpeK8zCIQ0F6j5l0L5udE1Ofe
	AM6OEoB2124PeC8IBIv08TtDC6qrMSvq3FbuNzeQudq09wEaa+a3QElpDQU5shUmRHfJ
	yR89d2ea6ks8lKTQZRN6MqUKWUsYzJiNgIiI0m6vDnZKvQuMHFDHbzjsdPTDcZS5pGfV
	yomw==
MIME-Version: 1.0
References: <20210423211130.GA1668472@redhat.com>
In-Reply-To: <20210423211130.GA1668472@redhat.com>
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Date: Sun, 25 Apr 2021 10:29:14 +0800
Message-ID: <CAFQAk7i_u_xmBRVuDvWoN_dZDjGgHpRtZ_niCV5r86ezdYsKMQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary="00000000000017c5cb05c0c2ccac"
Subject: Re: [Virtio-fs] [External] [RFC] [PATCH] virtiofsd: Auto switch
 between inline and thread-pool processing
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Michey Mehta <mimehta@redhat.com>

--00000000000017c5cb05c0c2ccac
Content-Type: text/plain; charset="UTF-8"

On Sat, Apr 24, 2021 at 5:11 AM Vivek Goyal <vgoyal@redhat.com> wrote:

> This is just an RFC patch for now. I am still running performance numbers
> and see if this method of switching is good enough or not. I did one run
> and seemed to get higher performance on deeper queue depths. There were
> few tests where I did not match lower queue depth performance with
> no thread pool. May be run to run variation.
>
>
I think this is interesting. I guess the switch number between thread-pool
and the inline method may change as the hardware or OS kernel changes.
Looking forward to the results.

Jiachen


> For low queue depth workloads, inline processing works well. But for
> high queue depth (and multiple process/thread) workloads, parallel
> processing of thread pool can benefit.
>
> This patch is an experiment which tries to switch to between inline and
> thread-pool processing. If number of requests received on queue is
> 1, inline processing is done. Otherwise requests are handed over to
> a thread pool for processing.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tools/virtiofsd/fuse_virtio.c |   27 +++++++++++++++++++--------
>  1 file changed, 19 insertions(+), 8 deletions(-)
>
> Index: rhvgoyal-qemu/tools/virtiofsd/fuse_virtio.c
> ===================================================================
> --- rhvgoyal-qemu.orig/tools/virtiofsd/fuse_virtio.c    2021-04-23
> 10:03:46.175920039 -0400
> +++ rhvgoyal-qemu/tools/virtiofsd/fuse_virtio.c 2021-04-23
> 10:56:37.793722634 -0400
> @@ -446,6 +446,15 @@ err:
>  static __thread bool clone_fs_called;
>
>  /* Process one FVRequest in a thread pool */
> +static void fv_queue_push_to_pool(gpointer data, gpointer user_data)
> +{
> +    FVRequest *req = data;
> +    GThreadPool *pool = user_data;
> +
> +    g_thread_pool_push(pool, req, NULL);
> +}
> +
> +/* Process one FVRequest in a thread pool */
>  static void fv_queue_worker(gpointer data, gpointer user_data)
>  {
>      struct fv_QueueInfo *qi = user_data;
> @@ -605,6 +614,7 @@ static void *fv_queue_thread(void *opaqu
>      struct fuse_session *se = qi->virtio_dev->se;
>      GThreadPool *pool = NULL;
>      GList *req_list = NULL;
> +    int nr_req = 0;
>
>      if (se->thread_pool_size) {
>          fuse_log(FUSE_LOG_DEBUG, "%s: Creating thread pool for Queue
> %d\n",
> @@ -686,22 +696,23 @@ static void *fv_queue_thread(void *opaqu
>              }
>
>              req->reply_sent = false;
> -
> -            if (!se->thread_pool_size) {
> -                req_list = g_list_prepend(req_list, req);
> -            } else {
> -                g_thread_pool_push(pool, req, NULL);
> -            }
> +            req_list = g_list_prepend(req_list, req);
> +            nr_req++;
>          }
>
>          pthread_mutex_unlock(&qi->vq_lock);
>          vu_dispatch_unlock(qi->virtio_dev);
>
>          /* Process all the requests. */
> -        if (!se->thread_pool_size && req_list != NULL) {
> -            g_list_foreach(req_list, fv_queue_worker, qi);
> +        if (req_list != NULL) {
> +            if (!se->thread_pool_size || nr_req <= 2) {
> +                g_list_foreach(req_list, fv_queue_worker, qi);
> +            } else  {
> +                g_list_foreach(req_list, fv_queue_push_to_pool, pool);
> +            }
>              g_list_free(req_list);
>              req_list = NULL;
> +            nr_req = 0;
>          }
>      }
>
>
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
>
>

--00000000000017c5cb05c0c2ccac
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Sat, Apr 24, 2021 at 5:11 AM Vivek=
 Goyal &lt;<a href=3D"mailto:vgoyal@redhat.com">vgoyal@redhat.com</a>&gt; w=
rote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0p=
x 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">This is ju=
st an RFC patch for now. I am still running performance numbers<br>
and see if this method of switching is good enough or not. I did one run<br=
>
and seemed to get higher performance on deeper queue depths. There were<br>
few tests where I did not match lower queue depth performance with <br>
no thread pool. May be run to run variation.<br>
<br></blockquote><div><br></div><div>I think this is interesting. I guess t=
he switch number between thread-pool and the inline method may change as th=
e hardware or OS kernel changes. Looking forward to the results.</div><div>=
<br></div><div>Jiachen</div><div>=C2=A0</div><blockquote class=3D"gmail_quo=
te" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204=
);padding-left:1ex">
For low queue depth workloads, inline processing works well. But for <br>
high queue depth (and multiple process/thread) workloads, parallel<br>
processing of thread pool can benefit.<br>
<br>
This patch is an experiment which tries to switch to between inline and<br>
thread-pool processing. If number of requests received on queue is<br>
1, inline processing is done. Otherwise requests are handed over to<br>
a thread pool for processing.<br>
<br>
Signed-off-by: Vivek Goyal &lt;<a href=3D"mailto:vgoyal@redhat.com" target=
=3D"_blank">vgoyal@redhat.com</a>&gt;<br>
---<br>
=C2=A0tools/virtiofsd/fuse_virtio.c |=C2=A0 =C2=A027 +++++++++++++++++++---=
-----<br>
=C2=A01 file changed, 19 insertions(+), 8 deletions(-)<br>
<br>
Index: rhvgoyal-qemu/tools/virtiofsd/fuse_virtio.c<br>
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br>
--- rhvgoyal-qemu.orig/tools/virtiofsd/fuse_virtio.c=C2=A0 =C2=A0 2021-04-2=
3 10:03:46.175920039 -0400<br>
+++ rhvgoyal-qemu/tools/virtiofsd/fuse_virtio.c 2021-04-23 10:56:37.7937226=
34 -0400<br>
@@ -446,6 +446,15 @@ err:<br>
=C2=A0static __thread bool clone_fs_called;<br>
<br>
=C2=A0/* Process one FVRequest in a thread pool */<br>
+static void fv_queue_push_to_pool(gpointer data, gpointer user_data)<br>
+{<br>
+=C2=A0 =C2=A0 FVRequest *req =3D data;<br>
+=C2=A0 =C2=A0 GThreadPool *pool =3D user_data;<br>
+<br>
+=C2=A0 =C2=A0 g_thread_pool_push(pool, req, NULL);<br>
+}<br>
+<br>
+/* Process one FVRequest in a thread pool */<br>
=C2=A0static void fv_queue_worker(gpointer data, gpointer user_data)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0struct fv_QueueInfo *qi =3D user_data;<br>
@@ -605,6 +614,7 @@ static void *fv_queue_thread(void *opaqu<br>
=C2=A0 =C2=A0 =C2=A0struct fuse_session *se =3D qi-&gt;virtio_dev-&gt;se;<b=
r>
=C2=A0 =C2=A0 =C2=A0GThreadPool *pool =3D NULL;<br>
=C2=A0 =C2=A0 =C2=A0GList *req_list =3D NULL;<br>
+=C2=A0 =C2=A0 int nr_req =3D 0;<br>
<br>
=C2=A0 =C2=A0 =C2=A0if (se-&gt;thread_pool_size) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fuse_log(FUSE_LOG_DEBUG, &quot;%s: Creati=
ng thread pool for Queue %d\n&quot;,<br>
@@ -686,22 +696,23 @@ static void *fv_queue_thread(void *opaqu<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0req-&gt;reply_sent =3D fals=
e;<br>
-<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!se-&gt;thread_pool_size) {<=
br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 req_list =3D g_lis=
t_prepend(req_list, req);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 g_thread_pool_push=
(pool, req, NULL);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 req_list =3D g_list_prepend(req_=
list, req);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 nr_req++;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pthread_mutex_unlock(&amp;qi-&gt;vq_lock)=
;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0vu_dispatch_unlock(qi-&gt;virtio_dev);<br=
>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Process all the requests. */<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!se-&gt;thread_pool_size &amp;&amp; req_li=
st !=3D NULL) {<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 g_list_foreach(req_list, fv_queu=
e_worker, qi);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (req_list !=3D NULL) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!se-&gt;thread_pool_size || =
nr_req &lt;=3D 2) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 g_list_foreach(req=
_list, fv_queue_worker, qi);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else=C2=A0 {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 g_list_foreach(req=
_list, fv_queue_push_to_pool, pool);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0g_list_free(req_list);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0req_list =3D NULL;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 nr_req =3D 0;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
=C2=A0 =C2=A0 =C2=A0}<br>
<br>
<br>
_______________________________________________<br>
Virtio-fs mailing list<br>
<a href=3D"mailto:Virtio-fs@redhat.com" target=3D"_blank">Virtio-fs@redhat.=
com</a><br>
<a href=3D"https://listman.redhat.com/mailman/listinfo/virtio-fs" rel=3D"no=
referrer" target=3D"_blank">https://listman.redhat.com/mailman/listinfo/vir=
tio-fs</a><br>
<br>
</blockquote></div></div>

--00000000000017c5cb05c0c2ccac--

