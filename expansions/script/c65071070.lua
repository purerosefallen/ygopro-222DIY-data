--黑天鹅
function c65071070.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c65071070.drcost)
	e1:SetOperation(c65071070.drop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c65071070.ctcon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c65071070.ctop)
	c:RegisterEffect(e2)
end
function c65071070.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x10da,15,REASON_COST) and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.RemoveCounter(tp,1,1,0x11,15,REASON_COST)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c65071070.drop(e,tp,eg,ep,ev,re,r,rp)
	local op=Duel.SelectOption(tp,aux.Stringid(65071070,0),aux.Stringid(65071070,1),aux.Stringid(65071070,2))
	if op==0 then
		local g1=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
		Duel.SendtoGrave(g1,REASON_EFFECT)
	elseif op==1 then
		local g2=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE)
		Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
	else 
		local g3=Duel.GetFieldGroup(tp,0,LOCATION_REMOVED)
		Duel.SendtoDeck(g3,nil,2,REASON_EFFECT)
	end
end
function c65071070.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end

function c65071070.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetCode(EVENT_CHAINING)
		e0:SetReset(RESET_PHASE+PHASE_END)
		e0:SetOperation(aux.chainreg)
		Duel.RegisterEffect(e0,tp)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetOperation(c65071070.acop)
		Duel.RegisterEffect(e1,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_ATTACK_ANNOUNCE)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetOperation(c65071070.acop2)
		Duel.RegisterEffect(e3,tp)
end
function c65071070.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) then
		c:AddCounter(0x10da,1)
	end
end

function c65071070.acop2(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttacker()
	c:AddCounter(0x10da,1)
end