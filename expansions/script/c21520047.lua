--灵子殖装的能源核心
function c21520047.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCountLimit(1,21520047+EFFECT_COUNT_CODE_OATH)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--lv rank up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520047,0))
	e1:SetCategory(CATEGORY_DICE+CATEGORY_LVCHANGE)
	e1:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c21520047.target)
	e1:SetOperation(c21520047.operation)
	c:RegisterEffect(e1)
	--adup
--[[	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetOperation(c21520047.adop)
	c:RegisterEffect(e2)--]]
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_FIELD)
	e2_1:SetRange(LOCATION_SZONE)
	e2_1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2_1:SetCode(EFFECT_UPDATE_ATTACK)
	e2_1:SetTarget(c21520047.atkfilter)
	e2_1:SetValue(c21520047.atkval)
	c:RegisterEffect(e2_1)
	local e2_2=e2_1:Clone()
	e2_2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2_2:SetTarget(c21520047.deffilter)
	e2_2:SetValue(c21520047.defval)
	c:RegisterEffect(e2_2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520047,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c21520047.thcon)
	e3:SetTarget(c21520047.thtg)
	e3:SetOperation(c21520047.thop)
	c:RegisterEffect(e3)
	--maintain
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21520047,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(c21520047.mtop)
	c:RegisterEffect(e4)
end
function c21520047.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c21520047.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local dc=Duel.TossDice(tp,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(c21520047.tglimit)
	e1:SetValue(dc)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RANK)
	Duel.RegisterEffect(e2,tp)
end
function c21520047.tglimit(e,c)
	return c:IsSetCard(0x494)
end
function c21520047.atkfilter(e,c)
	return c:IsSetCard(0x494) and c:IsPosition(POS_FACEUP_ATTACK)
end
function c21520047.deffilter(e,c)
	return c:IsSetCard(0x494) and c:IsPosition(POS_FACEUP_DEFENSE)
end
function c21520047.atkval(e,c)
	return c:GetDefense()
end
function c21520047.defval(e,c)
	return c:GetAttack()
end
--[[
function c21520047.adfilter(c)
	return c:IsSetCard(0x494) and c:IsFaceup()
end
function c21520047.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c21520047.adfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local val=0
	while tc do
		if tc:IsPosition(POS_FACEUP_ATTACK) then 
			val=tc:GetDefense()
			local e1=Effect.CreateEffect(c)
			e1:SetCategory(CATEGORY_ATKCHANGE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(val)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCategory(CATEGORY_DEFCHANGE)
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetValue(-val)
			tc:RegisterEffect(e2)
		elseif tc:IsPosition(POS_FACEUP_DEFENSE) then 
			val=tc:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetCategory(CATEGORY_ATKCHANGE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-val)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCategory(CATEGORY_DEFCHANGE)
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetValue(val)
			tc:RegisterEffect(e2)
		end
		tc=g:GetNext()
	end
end--]]
function c21520047.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandlerPlayer()~=Duel.GetTurnPlayer()
end
function c21520047.thfilter(c)
	return c:IsSetCard(0x494) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c21520047.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520047.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c21520047.thfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,g:GetCount(),0,LOCATION_DECK)
end
function c21520047.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=3
	local g=Duel.GetMatchingGroup(c21520047.thfilter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()<ct then ct=g:GetCount() end
	if c:IsRelateToEffect(e) and c:IsOnField() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local thg=g:Select(tp,1,ct,nil)
		Duel.SendtoHand(thg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,thg)
		Duel.DiscardDeck(tp,ct,REASON_EFFECT)
	end
end
function c21520047.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,500) then
		Duel.PayLPCost(tp,500)
	else
		Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	end
end
