--新干线超进化研究所
if not pcall(function() require("expansions/script/c18008001") end) then require("script/c18008001") end
local m=18008010
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=rsef.ACT(c)
	local e2=rsef.QO(c,nil,{m,0},1,nil,"tg",LOCATION_FZONE,nil,nil,rstg.target(cm.mvfilter,nil,LOCATION_MZONE),cm.mvop)
	local e3=rsef.I(c,{m,1},1,"sp,rm","tg",LOCATION_FZONE,nil,nil,rstg.target2(cm.fun,cm.cfilter,nil,LOCATION_MZONE),cm.spop)
end
cm.rssetcode="Shinkansen"
function cm.cfilter(c,e,tp)
	if not rssk.set(c) or not c:IsType(TYPE_LINK) then return end
	local zone=c:GetLinkedZone(tp)
	return zone>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,zone)
end
function cm.spfilter(c,e,tp,zone)
	return rssk.set(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function cm.fun(g,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp)
	local c,tc=aux.ExceptThisCard(e),rscf.GetTargetCard()
	if not c or not tc then return end
	local zone=tc:GetLinkedZone(tp)
	if zone<=0 then return end
	rsof.SelectHint(tp,"sp")
	local sc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone):GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP,zone)>0 then
		local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,nil)
		local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
		if #g1<=0 or #g2<=0 then return end
		if not Duel.SelectYesNo(tp,aux.Stringid(m,2)) then return end
		Duel.BreakEffect()
		rsof.SelectHint(tp,"rm")
		local rg1=g1:Select(tp,1,1,nil)
		rsof.SelectHint(tp,"rm")
		local rg2=g2:Select(tp,1,1,nil)
		rg1:Merge(rg2)
		Duel.HintSelection(rg1)
		if Duel.Remove(rg1,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)<=0 then return end
		local og=Duel.GetOperatedGroup()
		local fid=c:GetFieldID()
		for tc in aux.Next(og) do
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(og)
		e1:SetCountLimit(1) 
		e1:SetLabel(fid)
		e1:SetCondition(cm.retcon)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)  
	end
end
function cm.retfilter(c,fid)
	return c:GetFlagEffectLabel(m)==fid
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsExists(cm.retfilter,1,nil,e:GetLabel())
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(cm.retfilter,nil,e:GetLabel())
	for tc in aux.Next(g) do
		Duel.ReturnToField(tc)
	end
end
function cm.mvfilter(c)
	local seq=c:GetSequence()
	return rssk.set(c) and seq<5 and (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) then return end
	local seq=tc:GetSequence()
	if seq>4 then return end
	if (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)) then
		local flag=0
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=bit.replace(flag,0x1,seq-1) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=bit.replace(flag,0x1,seq+1) end
		flag=bit.bxor(flag,0xff)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
		local nseq=math.log(s,2)
		Duel.MoveSequence(tc,nseq)
	end
end