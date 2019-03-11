--赫利欧德的袛神使
function c92000003.initial_effect(c)
	--specialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(92000003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetTarget(c92000003.sptg)
	e1:SetOperation(c92000003.spop)
	c:RegisterEffect(e1)
	--check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetOperation(c92000003.checkop)
	c:RegisterEffect(e2)
	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(1)
	e3:SetValue(c92000003.valcon)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_ONFIELD)
	c:RegisterEffect(e4)
	--return
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(92000003,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_HAND)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetCost(c92000003.recost)
	e5:SetTarget(c92000003.retg)
	e5:SetOperation(c92000003.reop)
	c:RegisterEffect(e5)
end
function c92000003.checkop(e,tp,eg,ep,ev,re,r,rp)
	if (e:GetHandler():GetLocation()==LOCATION_MZONE or e:GetHandler():GetLocation()==LOCATION_SZONE) and e:GetHandler():GetFlagEffect(92000003)==0 then
		if (e:GetLabel())~=((e:GetHandler()):GetSequence()) 
		   and e:GetLabel()~=100 then
			(e:GetHandler()):RegisterFlagEffect(92000003,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		else 
			e:SetLabel((e:GetHandler()):GetSequence())
		end
	else
		e:SetLabel(100)
	end
end
function c92000003.filter(c,e,tp)
	return c:IsSetCard(0x6da5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and not c:IsCode(92000003)
end
function c92000003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c92000003.filter,tp,LOCATION_DECK,0,1,nil,e,tp) and e:GetHandler():GetFlagEffect(92000003)==1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c92000003.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c92000003.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c92000003.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c92000003.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() and c:GetFlagEffect(423587)==0 end
	c:RegisterFlagEffect(423587,RESET_CHAIN,0,1)
end
function c92000003.refilter(c)
	return c:IsSetCard(0x6da5) and c:IsFaceup() and c:IsLevelBelow(4) and not c:IsForbidden()
end
function c92000003.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c92000003.refilter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c92000003.refilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c92000003.refilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c92000003.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			if c:IsFaceup() then
				if not Duel.Equip(tp,tc,c,false) then return end
				--Add Equip limit
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(c92000003.eqlimit)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				e2:SetValue(1500)
				tc:RegisterEffect(e2)
				local e3=e2:Clone()
				e3:SetCode(EFFECT_UPDATE_DEFENSE)
				tc:RegisterEffect(e3)
			else Duel.SendtoGrave(tc,REASON_RULE) end
		end
	end
end
function c92000003.eqlimit(e,c)
	return e:GetOwner()==c
end
