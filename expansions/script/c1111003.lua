--蝶舞·祝祈
local m=1111003
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Butterfly=true
--
function c1111003.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1111003+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c1111003.tg1)
	e1:SetOperation(c1111003.op1)
	c:RegisterEffect(e1)
--
	if c1111003.checklp==nil then
		c1111003.checklp=true
		c1111003.lplist={[0]=Duel.GetLP(tp),[1]=Duel.GetLP(tp),}
		c1111003.eList={[0]={},[1]={},}
	end
--
end
--
function c1111003.tfilter1_1(c,e,tp)
	local seq=c:GetSequence()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return Duel.IsExistingMatchingCard(c1111003.tfilter1_2,tp,LOCATION_DECK,0,1,nil,e,tp,c) and (ft>0 or seq<5) and c:IsAbleToHand() and muxu.check_set_Urban(c)
end
function c1111003.tfilter1_2(c,e,tp,tc)
	return c:GetLevel()==tc:GetLevel() and muxu.check_set_Urban(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(tc:GetCode())
end
function c1111003.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=(Duel.GetLP(tp)<c1111003.lplist[tp])
	local b2=Duel.IsExistingMatchingCard(c1111003.tfilter1_1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(1111003,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(1111003,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_RECOVER)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
--
function c1111003.ofilter1(c)
	return muxu.check_set_Urban(c) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden()
end
function c1111003.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		if Duel.GetFlagEffect(tp,1111003)>0 then return end
		Duel.RegisterFlagEffect(tp,1111003,0,0,0)
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1_1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1_1:SetCountLimit(1)
		e1_1:SetOperation(c1111003.op1_1)
		Duel.RegisterEffect(e1_1,tp)
		local e1_2=Effect.CreateEffect(c)
		e1_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_2:SetCode(EVENT_ADJUST)
		e1_2:SetOperation(c1111003.op1_2)
		Duel.RegisterEffect(e1_2,tp)
		c1111003.eList[tp]={e1_1,e1_2}
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c1111003.tfilter1_1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		if tg:GetCount()<1 then return end
		local tc=tg:GetFirst()
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c1111003.tfilter1_2,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
		if sg:GetCount()<1 then return end
		local sc=sg:GetFirst()
		if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.IsExistingMatchingCard(c1111003.ofilter1,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(1111003,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1111003,3))
			local gn=Duel.SelectMatchingCard(tp,c1111003.ofilter1,tp,LOCATION_DECK,0,1,1,nil)
			if gn:GetCount()<1 then return end
			local cn=gn:GetFirst()
			Duel.MoveToField(cn,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
--
function c1111003.op1_1(e,tp,eg,ep,ev,re,r,rp)
	local flag=Duel.GetFlagEffect(tp,1111003)
	local lp=Duel.GetLP(tp)
	while flag>0 do
		if lp>=c1111003.lplist[tp] then return end 
		local num=c1111003.lplist[tp]-lp
		if num>600 then Duel.Recover(tp,600,REASON_EFFECT)
		elseif num>0 then Duel.Recover(tp,num,REASON_EFFECT) end
		flag=flag-1
	end
end
--
function c1111003.op1_2(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	if lp>=c1111003.lplist[tp] then
		for _,v in pairs(c1111003.eList[tp]) do v:Reset() end
		c1111003.eList[tp]={}
		Duel.ResetFlagEffect(tp,1111003)
	end
end
--
