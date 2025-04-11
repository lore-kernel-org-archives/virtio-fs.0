Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D679270EB9
	for <virtio-fs@lists.linux.dev>; Fri, 11 Apr 2025 01:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744334915; cv=none; b=r/8XOb1GhJtHx90/q/+3lRdA61WaVoE+8LgFDuFtVXeJP9oPJ+A9YJGhTVLMgN4PtDXg1AbusoIw5VZJeI/kQ1pp+YFi62azogfjm/LDpw5zG6fXK6Q2Ir/jxv9pIu+91kh1JVB5zVqBZ1e2S2G3s5gOwCLQaMOcdAJTqDLKTFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744334915; c=relaxed/simple;
	bh=dA7ZdXKUOrgDk9Aq0DWUsyLU+yMKQnBuAHmgywWoDV4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FymesT1NXGA9YeOvymj3+KD+rAqwajuhrT06DRCLTRis3wvfGsdIM/oZUgVzrp86fz3eYZ8zjpjTNOm5Ompb0OBkHmDKX/ooOEMDhSoub7/h/VTu8bWxP92BHOf9p1wHjG8Y9CiAID9z9Bym0dQ3pJjCCBolOjRfb56PllIvkps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=P0ig86jI; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="P0ig86jI"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1744334901; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=BP0FwvH5ULOjB3TgxB1gD1isgx0F+H3H9ueT5sxrPs8=;
	b=P0ig86jIhnyIIMtxbORjwYu4Mjt955sztXniJJ5JBJflxKChNPuui9PAfCfGxyde5qDC9mkGXK3vVTmZGR4Cb4roSDaARAhO+8NgeeQuwtZBEYphMQqj4RNFdcaLUJIqPouHYJ/9Am5uqFRFV+RJdMZ8dYMnq00MKOi/7fFbTpg=
Received: from 30.221.144.155(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0WWR06qF_1744334900 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 11 Apr 2025 09:28:21 +0800
Message-ID: <63320139-57d8-415c-a56d-32cc3e38381a@linux.alibaba.com>
Date: Fri, 11 Apr 2025 09:28:17 +0800
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Is it possible to use virtiofs to mount guest directory on the
 host?
To: Nils Kattenbeck <nilskemail@gmail.com>, virtio-fs@lists.linux.dev
References: <CAKkJDRfz=yb5U=Gu=evx5SW=ih6_5KTKQoqO=tfCEdVX2HEuVw@mail.gmail.com>
Content-Language: en-US
From: Jingbo Xu <jefflexu@linux.alibaba.com>
In-Reply-To: <CAKkJDRfz=yb5U=Gu=evx5SW=ih6_5KTKQoqO=tfCEdVX2HEuVw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/11/25 12:57 AM, Nils Kattenbeck wrote:
> Hello,
> 
> This may sound like a weird inquiry but is it possible to run
> virtiofsd inside the guest
> and mount the exposed directory on the host?
> 
> Our goal is to replace SSHFS with a more modern/lightweight/performant
> alternative
> as SSHFS which is pretty much in bugfix-only mode and not actively
> developed any further.
> As our primary use-case is local development based on VMs virtiofs
> would be a great fit.
> 
> If this is not (currently) possible, how hard would it be to adapt it to do so?
> Or is this simply impossible? I would also appreciate pointers to
> alternative, lightweight solutions.

Don't know much details on your case.

If you run cache=none mode of virtiofs (virtiofsd still runs in host in
this case), you can share a directory tree between host and guest.  And
all modifications done on guest side can be seen from host side.  Not
sure if this is adequate for your case?

-- 
Thanks,
Jingbo
