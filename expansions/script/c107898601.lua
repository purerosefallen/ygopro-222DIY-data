--STSE·角斗场
function c107898601.initial_effect(c)
	c:EnableReviveLimit()
	--change atk&def
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(107898601,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetTarget(c107898601.adtg)
	e1:SetOperation(c107898601.adop)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCondition(c107898601.pcon)
	e2:SetOperation(c107898601.pop)
	c:RegisterEffect(e2)
end
function c107898601.pcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c107898601.pop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,1-tp)
end
function c107898601.adfilter(c)
	return c:IsFaceup() and c:GetDefense()>=0 and c:GetAttack()~=c:GetDefense() and c:IsCode(107898101,107898102,107898103)
end
function c107898601.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c107898601.adfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c107898601.adop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c107898601.adfilter,tp,LOCATION_MZONE,0,1,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:IsFaceup() then
			local atk=tc:GetAttack()
			local def=tc:GetDefense()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(def)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(atk)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	end
end