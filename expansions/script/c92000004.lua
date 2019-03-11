--塔萨的袛神使
function c92000004.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(92000004,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetTarget(c92000004.thtg)
	e1:SetOperation(c92000004.thop)
	c:RegisterEffect(e1)
	--check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetOperation(c92000004.checkop)
	c:RegisterEffect(e2)
	--disable field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetCode(EFFECT_DISABLE_FIELD)
	e3:SetProperty(EFFECT_FLAG_REPEAT)
	e3:SetOperation(c92000004.disop)
	c:RegisterEffect(e3)
	--return
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(92000004,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_HAND)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetCost(c92000004.recost)
	e5:SetTarget(c92000004.retg)
	e5:SetOperation(c92000004.reop)
	c:RegisterEffect(e5)
end
function c92000004.checkop(e,tp,eg,ep,ev,re,r,rp)
	if (e:GetHandler():GetLocation()==LOCATION_MZONE or e:GetHandler():GetLocation()==LOCATION_SZONE) and e:GetHandler():GetFlagEffect(92000004)==0 then
		if (e:GetLabel())~=((e:GetHandler()):GetSequence()) 
		   and e:GetLabel()~=100 then
			(e:GetHandler()):RegisterFlagEffect(92000004,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		else 
			e:SetLabel((e:GetHandler()):GetSequence())
		end
	else
		e:SetLabel(100)
	end
end
function c92000004.filter(c)
	return c:IsSetCard(0x6da5) and not c:IsCode(92000004) and c:IsAbleToHand()
end
function c92000004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c92000004.filter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():GetFlagEffect(92000004)==1 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c92000004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c92000004.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c92000004.disop(e,tp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if ec then
		return ec:GetColumnZone(LOCATION_MZONE)
	else return c:GetColumnZone(LOCATION_MZONE) end
end
function c92000004.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() and c:GetFlagEffect(423587)==0 end
	c:RegisterFlagEffect(423587,RESET_CHAIN,0,1)
end
function c92000004.refilter(c)
	return c:IsSetCard(0x6da5) and c:IsFaceup() and c:IsLevelBelow(4) and not c:IsForbidden()
end
function c92000004.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c92000004.refilter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c92000004.refilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c92000004.refilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c92000004.reop(e,tp,eg,ep,ev,re,r,rp)
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
				e1:SetValue(c92000004.eqlimit)
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
function c92000004.eqlimit(e,c)
	return e:GetOwner()==c
end
