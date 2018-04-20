--来自异界的接触
function c13254127.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,13254127+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c13254127.sptg)
	e1:SetOperation(c13254127.spop)
	c:RegisterEffect(e1)
	
end
function c13254127.filter(c,e,tp,maru)
	return ((c:IsSetCard(0x356) and maru==1) or (not c:IsSetCard(0x356) and maru==2)) and c:IsFaceup() and Duel.IsExistingMatchingCard(c13254127.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,3-maru)
end
function c13254127.spfilter(c,e,tp,maru)
	return ((c:IsSetCard(0x356) and maru==1) or (not c:IsSetCard(0x356) and maru==2)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13254127.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local t1=Duel.IsExistingTarget(c13254127.filter,tp,LOCATION_MZONE,0,1,nil,e,tp,1)
	local t2=Duel.IsExistingTarget(c13254127.filter,tp,LOCATION_MZONE,0,1,nil,e,tp,2)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and (c13254127.filter(chkc,e,tp,1) or c13254127.filter(chkc,e,tp,2)) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (t1 or t2) end
	local op=0
	if t1 or t2 or t3 then
		local m={}
		local n={}
		local ct=1
		if t1 then m[ct]=aux.Stringid(13254127,1) n[ct]=1 ct=ct+1 end
		if t2 then m[ct]=aux.Stringid(13254127,2) n[ct]=2 ct=ct+1 end
		local sp=Duel.SelectOption(tp,table.unpack(m))
		op=n[sp+1]
	end
	e:SetLabel(op)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c13254127.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,op)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c13254127.spop(e,tp,eg,ep,ev,re,r,rp)
	local op=2-(e:GetLabel())
	local tc=Duel.GetFirstTarget()
	local sg=Group.CreateGroup()
	if tc:IsRelateToEffect(e) then
		sg:AddCard(tc)
	else return
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c13254127.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,op)
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			sg:Merge(g)
		end
	end
	tc=sg:GetFirst()
	while tc do
		local e11=Effect.CreateEffect(e:GetHandler())
		e11:SetType(EFFECT_TYPE_SINGLE)
		e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e11:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e11:SetValue(1)
		e11:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e11)
		local e12=e11:Clone()
		e12:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e12)
		local e13=e11:Clone()
		e13:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		tc:RegisterEffect(e13)
		local e14=e11:Clone()
		e14:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		tc:RegisterEffect(e14)
		local e15=Effect.CreateEffect(e:GetHandler())
		e15:SetDescription(aux.Stringid(13254127,3))
		e15:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e15:SetType(EFFECT_TYPE_SINGLE)
		e15:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e15)
		tc=sg:GetNext()
	end
end
