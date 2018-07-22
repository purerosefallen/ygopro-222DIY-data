--旗之所向
function c22209999.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c22209999.target)
	e1:SetOperation(c22209999.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22209999+EFFECT_COUNT_CODE_DUEL)
	e2:SetTarget(c22209999.reptg)
	e2:SetValue(c22209999.repval)
	c:RegisterEffect(e2)
end
function c22209999.filter(c)
	local seq=c:GetSequence()
	return seq<5 and ((seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)) or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)))
end
function c22209999.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22209999.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22209999.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c22209999.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c22209999.filter2(c,tp)
	return c:GetSequence()<5 and c:IsLocation(LOCATION_MZONE) and c:IsControler(1-tp)
end
function c22209999.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
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
		local nseq=0
		if s==1 then nseq=0
		elseif s==2 then nseq=1
		elseif s==4 then nseq=2
		elseif s==8 then nseq=3
		else nseq=4 end
		Duel.MoveSequence(tc,nseq)
		local lc=tc:GetColumnGroup():Filter(c22209999.filter2,nil,tp):GetFirst()
		if lc then 
			Duel.BreakEffect()
			local res=Duel.RockPaperScissors()
			if res==tp then
				Duel.SendtoGrave(lc,REASON_RULE)
			else
				Duel.SendtoGrave(tc,REASON_RULE)
			end
		end
	end
end
function c22209999.repfilter(c,tp)
	return c:GetSequence()<5 and c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE) and c:GetFlagEffect(22209999)==0
end
function c22209999.desfilter(c,e,tp,seq)
	local seq2=c:GetSequence()
	return seq2<5 and (seq2-seq==1 or seq-seq2==1) and c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE) and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c22209999.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c22209999.repfilter,1,nil,tp) end
	local tc=eg:Filter(c22209999.repfilter,nil,tp):GetFirst()
	local seq=tc:GetSequence()
	if Duel.IsExistingMatchingCard(c22209999.desfilter,tp,0,LOCATION_MZONE,1,nil,e,tp,seq) and Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		local g=eg:Filter(c22209999.repfilter,nil,tp)
		e:SetLabelObject(g:GetFirst())
		local tg=Duel.GetMatchingGroup(c22209999.desfilter,tp,0,LOCATION_MZONE,nil,e,tp,seq)
		Duel.SetTargetCard(tg)
		local dc=tg:GetFirst()
		while dc do
			dc:RegisterFlagEffect(22209999,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
			dc=tg:GetNext()
		end
		Duel.Hint(HINT_CARD,1-tp,22209999)
		Duel.Destroy(tg,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
function c22209999.repval(e,c)
	return c==e:GetLabelObject()
end