--崩坏解放
function c75646323.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,75646323+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c75646323.target)
	e1:SetOperation(c75646323.activate)
	c:RegisterEffect(e1)
end
function c75646323.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x62c2) and c:GetFlagEffect(75646323)==0
end
function c75646323.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c75646323.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75646323.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c75646323.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c75646323.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:GetFlagEffect(75646323)==0 then
			tc:RegisterFlagEffect(75646323,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetCondition(c75646323.effcon)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetValue(800)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
	Duel.RegisterFlagEffect(tp,75646307,RESET_EVENT+RESET_PHASE+PHASE_END,0,1)
end
function c75646323.effcon(e)
	return e:GetOwnerPlayer()==e:GetHandlerPlayer()
end