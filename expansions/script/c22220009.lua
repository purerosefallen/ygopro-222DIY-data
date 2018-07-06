--白沢球小号手
function c22220009.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_HANDES+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c22220009.target)
	e1:SetOperation(c22220009.operation)
	c:RegisterEffect(e1)
	--Disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22220009,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c22220009.distg)
	e2:SetOperation(c22220009.disop)
	c:RegisterEffect(e2)
	--returnhand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(c22220009.rhop)
	c:RegisterEffect(e3)
end
function c22220009.cfilter2(c,code)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x50f) and (not c:IsPublic()) and (not c:IsCode(22220009)) and (not c:IsCode(code))
end
function c22220009.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x50f) and (not c:IsPublic()) and (not c:IsCode(22220009)) and Duel.IsExistingMatchingCard(c22220009.cfilter2,tp,LOCATION_HAND,0,1,nil,c:GetCode()) 
end
function c22220009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22220009.cfilter,tp,LOCATION_HAND,0,1,nil,tp) and Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,0,2,1-tp,LOCATION_ONFIELD)
end
function c22220009.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(c22220009.cfilter,tp,LOCATION_HAND,0,1,nil,tp) then return end
	local tc1=Duel.SelectMatchingCard(tp,c22220009.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(Card.IsCode,nil,tc1:GetCode()):Filter(c22220009.cfilter,nil,tp)
	local tc2=Duel.SelectMatchingCard(tp,c22220009.cfilter2,tp,LOCATION_HAND,0,1,1,nil,tc1:GetCode()):GetFirst()
	local g2=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(Card.IsCode,nil,tc2:GetCode()):Filter(c22220009.cfilter2,nil,tc1:GetCode())
	local g=Group.CreateGroup()
	g:Merge(g1)
	g:Merge(g2)
	Duel.ConfirmCards(1-tp,g)
	local ct=g:GetCount()
	if ct>1 and c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	if ct>2 and g:FilterCount(Card.IsDiscardable,nil,REASON_EFFECT)>0 then
		local sg=g:Filter(Card.IsDiscardable,nil,REASON_EFFECT):Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
		Duel.Draw(tp,2,REASON_EFFECT)
	end
	if ct>3 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,2,nil) then
		local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,2,2,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
function c22220009.disfilter(c)
	return c:IsFaceup() and (not c:IsDisabled())
end
function c22220009.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22220009.disfilter(chkc) and c:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c22220009.disfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c22220009.disfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c22220009.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
		tc:RegisterFlagEffect(22220009,RESET_EVENT+0x1fe0000,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabelObject(tc)
		e1:SetCondition(c22220009.tgcon)
		e1:SetOperation(c22220009.tgop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c22220009.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(22220009)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c22220009.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
function c22220009.rhop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end