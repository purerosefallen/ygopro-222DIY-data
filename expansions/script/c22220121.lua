--半人半灵的白沢球
function c22220121.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SPIRIT),2,2)
	c:EnableReviveLimit()
	--AttackAgain
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22220121,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetCondition(c22220121.atkcon)
	e1:SetTarget(c22220121.atktg)
	e1:SetOperation(c22220121.atkop)
	c:RegisterEffect(e1)
	--buff
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22220121,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c22220121.revcost)
	e2:SetTarget(c22220121.revtg)
	e2:SetOperation(c22220121.revop)
	c:RegisterEffect(e2)
	--returnhand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(c22220121.rhop)
	c:RegisterEffect(e3)
end
function c22220121.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c==Duel.GetAttacker() and bc and c:IsStatus(STATUS_OPPO_BATTLE) and bc:IsOnField() and bc:IsRelateToBattle()
end
function c22220121.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,bc,1,0,0)
end
function c22220121.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc:IsRelateToBattle() and bc:IsFaceup() then
		Duel.NegateRelatedChain(bc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(-3000)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		bc:RegisterEffect(e2)
		bc:RegisterEffect(e1)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		bc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		bc:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		e5:SetValue(c22220121.vala)
		e5:SetLabelObject(bc)
		c:RegisterEffect(e5)
		Duel.ChainAttack()
	end
end
function c22220121.vala(e,c)
	return e:GetLabelObject()~=c
end
function c22220121.revcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22220121.revtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c22220121.revop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--damage conversion
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCode(EFFECT_REVERSE_DAMAGE)
	e0:SetReset(RESET_PHASE+PHASE_END,2)
	e0:SetTargetRange(1,0)
	e0:SetValue(c22220121.rev)
	Duel.RegisterEffect(e0,tp)
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)  
		c:RegisterEffect(e1)
	end
end
function c22220121.rev(e,re,r,rp,rc)
	return bit.band(r,REASON_BATTLE)>0
end
function c22220121.rhop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	local fg=c:GetColumnGroup()
	og:Merge(fg)
	og:AddCard(c)
	Duel.SendtoHand(og,nil,REASON_EFFECT)
end