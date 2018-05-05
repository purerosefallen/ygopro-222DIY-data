--飞翔于空的不思议巫女
function c1120101.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1120101,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,1120101)
	e1:SetCondition(c1120101.con1)
	e1:SetTarget(c1120101.tg1)
	e1:SetOperation(c1120101.op1)
	c:RegisterEffect(e1)
--
end
--
function c1120101.cfilter1(c,tp)
	return c:GetSummonPlayer()==tp and not c:IsPreviousLocation(LOCATION_HAND+LOCATION_EXTRA)
end
function c1120101.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1120101.cfilter1,1,nil,1-tp)
end
--
function c1120101.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		local sg=eg:Filter(Card.IsControler,nil,1-tp)
		if sg:GetCount()<1 then 
			return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
		end
		local sc=sg:GetFirst()
		local allseq={}
		while sc do
			local sclseq=sc:GetSequence()-1
			local scrseq=sc:GetSequence()+1
			if sclseq>-1 and sclseq<5 then
				local num=0
				for k,v in ipairs(allseq) do
					if v==sclseq then num=1 end
				end
				if num==0 then allseq[#allseq+1]=sclseq end
			end
			if scrseq>-1 and scrseq<5 then
				local num=0
				for k,v in ipairs(allseq) do
					if v==scrseq then num=1 end
				end
				if num==0 then allseq[#allseq+1]=scrseq end
			end
			sc=sg:GetNext()
		end
		local flag=0
		for k,v in ipairs(allseq) do
			flag=bit.replace(flag,0x1,v)
		end
		flag=bit.bxor(flag,0xff)
		return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp,flag)
	end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
--
function c1120101.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0 then
		local num=0
		local tg=eg:Filter(Card.IsRelateToEffect,nil,e)
		if tg:GetCount()<1 then return end
		local sg=eg:Filter(Card.IsControler,nil,1-tp)
		if sg:GetCount()<0 and Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)>0 then num=1 end
		sg=sg:Filter(Card.IsRelateToEffect,nil,e)
		local sc=sg:GetFirst()
		local allseq={}
		while sc do
			local sclseq=sc:GetSequence()-1
			local scrseq=sc:GetSequence()+1
			if sclseq>-1 then
				local num=0
				for k,v in ipairs(allseq) do
					if v==sclseq then num=1 end
				end
				if num==0 then allseq[#allseq+1]=sclseq end
			end
			if scrseq<5 then
				local num=0
				for k,v in ipairs(allseq) do
					if v==scrseq then num=1 end
				end
				if num==0 then allseq[#allseq+1]=scrseq end
			end
			sc=sg:GetNext()
		end
		local flag=0
		for k,v in ipairs(allseq) do
			flag=bit.replace(flag,0x1,v)
		end
		flag=bit.bxor(flag,0xff)
		if Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP,flag)>0 then num=1 end
		if num~=1 then return end
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1_1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1_1:SetValue(1)
		e1_1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1_1,true)
		local e1_2=e1_1:Clone()
		e1_2:SetCode(EFFECT_UNRELEASABLE_SUM)
		c:RegisterEffect(e1_2,true)
		local e1_3=e1_1:Clone()
		e1_3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		c:RegisterEffect(e1_3,true)
		local e1_4=Effect.CreateEffect(c)
		e1_4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_4:SetCode(EVENT_PHASE+PHASE_END)
		e1_4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1_4:SetLabel(Duel.GetTurnCount())
		e1_4:SetCountLimit(1)
		e1_4:SetCondition(c1120101.con1_4)
		e1_4:SetOperation(c1120101.op1_4)
		e1_4:SetReset(RESET_PHASE+PHASE_END,1)
		Duel.RegisterEffect(e1_4,tp)
		c:RegisterFlagEffect(1120101,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
		if Duel.SelectYesNo(tp,aux.Stringid(1120101,1)) then
			Duel.BreakEffect()
			local ng=Group.CreateGroup()
			local rg=eg:Filter(Card.IsRelateToEffect,nil,e)
			Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
		end
	end
end
--
function c1120101.con1_4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel() and e:GetOwner():GetFlagEffect(1120101)~=0
end
function c1120101.op1_4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	c:ResetEffect(EFFECT_SET_CONTROL,RESET_CODE)
	local e1_4_1=Effect.CreateEffect(c)
	e1_4_1:SetType(EFFECT_TYPE_SINGLE)
	e1_4_1:SetCode(EFFECT_SET_CONTROL)
	e1_4_1:SetValue(c:GetOwner())
	e1_4_1:SetReset(RESET_EVENT+0xec0000)
	c:RegisterEffect(e1_4_1)
end
--


--c在tc相邻位置特殊召唤
--local tcseq=tc:GetSequence()
--local flag=0
--local cseq=0
--while cseq<5 then
--  local lseq=tcseq-1
--  local rseq=tcseq+1
--  if (lseq>-1 and lseq~=cseq) and (rseq<5 and rseq~=cseq) then
--  flag=bit.replace(flag,0x1,cseq)
--  end
--  cseq=cseq+1
--end
--flag=bit.bxor(flag,0xff)
--Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,flag)
--
