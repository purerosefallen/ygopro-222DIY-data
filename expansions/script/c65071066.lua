--荧光菌孢
function c65071066.initial_effect(c)
	--cont
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c65071066.cttg)
	e1:SetOperation(c65071066.ctop)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c65071066.ctop)
	c:RegisterEffect(e2)
end
function c65071066.ctfil(c,e)
	return c:GetCounter(0x10da)~=0 and c:IsFaceup() and c:IsControlerCanBeChanged()
end

function c65071066.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c65071066.ctfil(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c65071066.ctfil,tp,0,LOCATION_MZONE,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c65071066.ctfil,tp,0,LOCATION_MZONE,1,1,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end

function c65071066.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end

function c65071066.ctop(e,tp,eg,ep,ev,re,r,rp)
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
		e1:SetOperation(c65071066.acop)
		Duel.RegisterEffect(e1,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_ATTACK_ANNOUNCE)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetOperation(c65071066.acop2)
		Duel.RegisterEffect(e3,tp)
end
function c65071066.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) then
		c:AddCounter(0x10da,1)
	end
end

function c65071066.acop2(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttacker()
	c:AddCounter(0x10da,1)
end