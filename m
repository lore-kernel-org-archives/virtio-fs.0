Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB88E47F47
	for <virtio-fs@lists.linux.dev>; Mon, 11 Mar 2024 15:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710172771; cv=none; b=HAlBGcKfAJD+UWSnr92uKtTuvVQc7Fl7XXJBmOwp7+sehRc/mkoCBTjcXE+yReKBmKCskEluw8bkAVP/Cat7Uq2yOgXGw5wMrzVc+miJsmJtxLNLc8hi4MAdLhTFOsmS4camqwLC3SqA8NjfUP1ZrrOPnalu1ByjfLUzr4tpKDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710172771; c=relaxed/simple;
	bh=I4/87NwvqqpaViSus1M0u8GL8324PD7DEG4oFOBPYao=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NqGIhbxTFXERPGenjLEsuKUs+66umEi7qGYYGOlWNbWlPztepRKp2lqgfUN5kqjkw6ewbNvFmmcH1YgBsHPuQU1o8mvCuaJNmjONJ1BcjtRl4CQhfwTX7A9dsBNHnpjrYvBYI/leprwFolEOPW8+pAHuUNh9fPYmx+mE4H3NlVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=avrI2Imd; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="avrI2Imd"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42BFv1Ov023454;
	Mon, 11 Mar 2024 15:59:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=I4/87NwvqqpaViSus1M0u8GL8324PD7DEG4oFOBPYao=;
 b=avrI2ImdACmxu0euDm6GzcKwsER9RxVZ0KKTLwYDkhKVwOb4FnPTiSGaGw4fKgW3t+z3
 FhW96nBQk1yX6srpwdYh5A88f+1c501fYPMSSRZom8sr9sxVbFnhNK7zF7AqxYMa4wsO
 hJ7CUA//OU0yQ7t8CfvTaQunpTb+n994o2zeCy1Qrw77Y5Fnkngj5/NWhqBpund1cqeE
 cV+tBM63q+aOu1R/XC4O1WsolRuCiusYgsamAla/LPHcub3Xfrq1lMBq6ZvR0/cgwmRE
 1bOvltMuFhTCWW7Nd56Fe2jVpnYkCt8qYtnK9fKvTx3yWVhz+isjU1i0aJJrxL41dy2E ow== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wt51xr22t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Mar 2024 15:59:24 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42BFv1rB023458;
	Mon, 11 Mar 2024 15:59:23 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wt51xr213-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Mar 2024 15:59:23 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42BCxjef015501;
	Mon, 11 Mar 2024 15:55:09 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ws2fyhkkn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Mar 2024 15:55:09 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42BFt6Qg49152378
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Mar 2024 15:55:08 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B55D55805F;
	Mon, 11 Mar 2024 15:55:04 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3578958063;
	Mon, 11 Mar 2024 15:55:03 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.78.110])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 11 Mar 2024 15:55:03 +0000 (GMT)
Message-ID: <fc53c5567644a8fdd7ca06c89a20b7c52ddb574e.camel@linux.ibm.com>
Subject: Re: [PATCH v1 5/8] virtio-ccw: Handle extra notification data
From: Eric Farman <farman@linux.ibm.com>
To: Jonah Palmer <jonah.palmer@oracle.com>, qemu-devel@nongnu.org
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, thuth@redhat.com,
        richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com,
        cohuck@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        stefanha@redhat.com, qemu-block@nongnu.org, qemu-s390x@nongnu.org,
        virtio-fs@lists.linux.dev
Date: Mon, 11 Mar 2024 11:55:02 -0400
In-Reply-To: <20240304194612.611660-6-jonah.palmer@oracle.com>
References: <20240304194612.611660-1-jonah.palmer@oracle.com>
	 <20240304194612.611660-6-jonah.palmer@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.4 (3.50.4-1.fc39) 
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LUccPnyA8u9cmmjVLmBtSnDRsv9dmHzP
X-Proofpoint-ORIG-GUID: JFrUGpsd7t7ObrPTsvUw5GvQ_IrfaY_I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-11_10,2024-03-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 spamscore=0 clxscore=1011 mlxlogscore=999 impostorscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403110121

On Mon, 2024-03-04 at 14:46 -0500, Jonah Palmer wrote:
> > Add support to virtio-ccw devices for handling the extra data sent
> > from
> > the driver to the device when the VIRTIO_F_NOTIFICATION_DATA
> > transport
> > feature has been negotiated.
> >=20
> > The extra data that's passed to the virtio-ccw device when this
> > feature
> > is enabled varies depending on the device's virtqueue layout.
> >=20
> > That data passed to the virtio-ccw device is in the same format as
> > the
> > data passed to virtio-pci devices.
> >=20
> > Acked-by: Thomas Huth <thuth@redhat.com>
> > Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> > ---
> > =C2=A0hw/s390x/s390-virtio-ccw.c | 16 ++++++++++++----
> > =C2=A01 file changed, 12 insertions(+), 4 deletions(-)

Acked-by: Eric Farman <farman@linux.ibm.com>

(I see a v2 is coming for the ioeventfd side, but I was going through
this series today and thought that would affect the next patch rather
than this one.)
