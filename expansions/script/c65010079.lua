--终末旅者装备 玄铁天雷盾
function c65010079.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c65010079.target)
	e1:SetOperation(c65010079.activate)
	c:RegisterEffect(e1)
end
c65010079.setname="RagnaTravellers"
function c65010079.filter(c)
	return c.setname=="RagnaTravellers" or c:IsCode(65010082)
end
function c65010079.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c65010079.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65010079.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c65010079.filter,tp,LOCATION_MZONE,0,1,1,nil)
	if Duel.GetCurrentChain()>1 then e:SetLabel(1) end
end
function c65010079.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		--indes
		local e2=Effect.CreateEffect(c)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		e2:SetValue(1)
		tc:RegisterEffect(e2)
		--cannot be target
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e3:SetValue(aux.tgoval)
		tc:RegisterEffect(e3)
		--battle
		local e4=e2:Clone()
		e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		tc:RegisterEffect(e4)
		if e:GetLabel()==1 then
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e5:SetRange(LOCATION_MZONE)
			e5:SetCode(EFFECT_IMMUNE_EFFECT)
			e5:SetValue(c65010079.efilter)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e5)
		end
	end
end
function c65010079.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end