--不和
function c65071102.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c65071102.ckcost)
	e1:SetTarget(c65071102.cktg)
	e1:SetOperation(c65071102.ckop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,65071102)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c65071102.activate)
	c:RegisterEffect(e2)
end
function c65071102.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetOperation(c65071102.operation)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c65071102.operation(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then
		Duel.Damage(1-tp,ev,REASON_EFFECT)
	end
end
function c65071102.filter(c)
	return c:IsFacedown()
end

function c65071102.ckcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c65071102.cktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c65071102.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65071102.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c65071102.filter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
end
function c65071102.ckop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_SZONE) and tc:IsFacedown() then
		Duel.ConfirmCards(tp,tc)
		if tc:IsType(TYPE_QUICKPLAY) then 
			local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end