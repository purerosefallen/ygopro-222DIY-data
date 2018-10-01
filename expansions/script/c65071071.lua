--沉醉
function c65071071.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetTarget(c65071071.target)
	e1:SetOperation(c65071071.activate)
	c:RegisterEffect(e1)
end
function c65071071.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c65071071.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		--indes
		local e1=Effect.CreateEffect(tc)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetTarget(c65071071.imtg)
		e1:SetValue(c65071071.imvl)
		tc:RegisterEffect(e1,true)
		if not tc:IsType(TYPE_EFFECT) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetValue(TYPE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2,true)
		end
		tc:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65071071,0))
	end
end

function c65071071.tgfilter(c,e,tp)
	return c==e:GetOwner()
end
function c65071071.imtg(e,c)
	return (c:GetSequence()<5 and c:GetColumnGroup():FilterCount(c65071071.tgfilter,nil,e,c:GetControler())>0) or c==e:GetOwner()
end

function c65071071.imvl(e,te)
	return te:GetOwner()~=e:GetOwner()
end