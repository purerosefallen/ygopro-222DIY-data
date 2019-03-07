--令咒
function c24420002.initial_effect(c)
	--rec or dam
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24420002,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c24420002.target)
	e1:SetOperation(c24420002.operation)
	c:RegisterEffect(e1)
end
function c24420002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b2=Duel.IsExistingMatchingCard(c24420002.filter,tp,LOCATION_DECK,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(c24420002.atkfilter,tp,LOCATION_ONFIELD,0,1,nil)
	if chk==0 then return true end
	local op=0
	if b2 and b3 then
		op=Duel.SelectOption(tp,aux.Stringid(24420002,1),aux.Stringid(24420002,2),aux.Stringid(24420002,3))
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(24420002,1),aux.Stringid(24420002,2))
	elseif b3 then
		op=Duel.SelectOption(tp,aux.Stringid(24420002,1),aux.Stringid(24420002,3))*2
	else
		op=Duel.SelectOption(tp,aux.Stringid(24420002,1))
	end
	e:SetLabel(op)
end
function c24420002.filter(c)
	return c:IsSetCard(0x245) and c:IsAbleToHand()
end
function c24420002.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x244)
end
function c24420002.filter2(c)
	return c:IsSetCard(0x244)
end
function c24420002.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==0 then
	local tg=Duel.GetMatchingGroup(c24420002.atkfilter,tp,LOCATION_MZONE,0,nil)
	if tg:GetCount()>0 then
		local sc=tg:GetFirst()
		while sc do
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e3:SetValue(1000)
			sc:RegisterEffect(e3)
			local e2=e3:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			sc:RegisterEffect(e2)
			sc=tg:GetNext()
		end
	end
	elseif op==1 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c24420002.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	else
local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c24420002.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c24420002.filter2,tp,LOCATION_MZONE,0,1,1,nil)
		if Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetReset(RESET_PHASE+PHASE_END)
		e4:SetLabelObject(g:GetFirst())
		e4:SetCountLimit(1)
		e4:SetOperation(c24420002.retop)
		Duel.RegisterEffect(e4,tp)
		end
	end
end
function c24420002.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
