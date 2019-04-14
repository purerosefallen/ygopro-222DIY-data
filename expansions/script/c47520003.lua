--西南西的守护神 安琪拉
function c47520003.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c47520003.valcheck)
	c:RegisterEffect(e0)
	--shinramanshyou
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47520003,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetLabelObject(e0)
	e1:SetCondition(c47520003.lpcon)
	e1:SetTarget(c47520003.lptg)
	e1:SetOperation(c47520003.lpop)
	c:RegisterEffect(e1) 
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	e2:SetLabelObject(e0)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c47520003.buffcon)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	e3:SetLabelObject(e0)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c47520003.buffcon)
	c:RegisterEffect(e3)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetValue(500)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e8)
	--inactivatable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e4:SetLabelObject(e0)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetValue(c47520003.effectfilter)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e5) 
	--pendulum
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e9:SetCode(EVENT_LEAVE_FIELD)
	e9:SetProperty(EFFECT_FLAG_DELAY)
	e9:SetCondition(c47520003.pencon)
	e9:SetTarget(c47520003.pentg)
	e9:SetOperation(c47520003.penop)
	c:RegisterEffect(e9)
	--search
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(47520003,1))
	e10:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetCountLimit(1,47520003)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCost(c47520003.cost)
	e10:SetTarget(c47520003.target)
	e10:SetOperation(c47520003.operation)
	c:RegisterEffect(e10)
end
function c47520003.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsType(TYPE_MONSTER) 
end
function c47520003.mfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c47520003.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsRace,1,nil,RACE_BEASTWARRIOR) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c47520003.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c47520003.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
end
function c47520003.lpop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Recover(p,d,REASON_EFFECT) and e:GetLabel()==1 then Duel.Draw(tp,1,REASON_EFFECT) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c47520003.buffcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()==1
end
function c47520003.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47520003.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47520003.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c47520003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,1,1,REASON_COST) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
	local sg=Duel.SelectMatchingCard(tp,Card.CheckRemoveOverlayCard,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,1,REASON_COST)
	if sg:GetCount()==0 then return end
	Duel.HintSelection(sg)
	sg:GetFirst():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47520003.filter(c)
	return c:IsRace(RACE_BEASTWARRIOR) and c:IsSummonableCard() and c:IsAbleToHand()
end
function c47520003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47520003.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47520003.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c47520003.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end