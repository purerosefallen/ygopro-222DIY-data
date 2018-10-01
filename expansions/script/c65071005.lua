--熊熊抱
function c65071005.initial_effect(c)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c65071005.tgtg)
	e1:SetOperation(c65071005.tgop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c65071005.ctop)
	c:RegisterEffect(e2)
end

function c65071005.tgfil(c,e)
	return c:GetCounter(0x10da)~=0
end

function c65071005.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65071005.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end

function c65071005.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65071005.tgfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e)
	if g:GetCount()>0 then Duel.SendtoGrave(g,REASON_EFFECT) end
end

function c65071005.ctop(e,tp,eg,ep,ev,re,r,rp)
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
		e1:SetOperation(c65071005.acop)
		Duel.RegisterEffect(e1,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_ATTACK_ANNOUNCE)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetOperation(c65071005.acop2)
		Duel.RegisterEffect(e3,tp)
end
function c65071005.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) then
		c:AddCounter(0x10da,1)
	end
end

function c65071005.acop2(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttacker()
	c:AddCounter(0x10da,1)
end