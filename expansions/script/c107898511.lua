
function c107898511.initial_effect(c)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(107898511,1))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c107898511.cost)
	e1:SetTarget(c107898511.target)
	e1:SetOperation(c107898511.operation)
	c:RegisterEffect(e1)
end
function c107898511.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x575)
end
function c107898511.filter(c)
	return c:IsCode(107898102) and c:IsFaceup()
end
function c107898511.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLevel()==1
	or Duel.IsCanRemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	and not e:GetHandler():IsPublic() end
	if e:GetHandler():GetLevel()>1 then
		Duel.RemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	end
end
function c107898511.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c107898511.filter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToRemove(tp) and Duel.IsExistingTarget(c107898511.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c107898511.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c107898511.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) then
		Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_EFFECT)
	end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		if not tc:IsType(TYPE_EFFECT) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_ADD_TYPE)
			e2:SetValue(TYPE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2,true)
		end
		--count
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e3:SetCategory(CATEGORY_COUNTER)
		e3:SetDescription(aux.Stringid(107898511,1))
		e3:SetCountLimit(1)
		e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCondition(c107898511.accon)
		e3:SetOperation(c107898511.acop)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3,true)
		tc:RegisterFlagEffect(tc:GetCode(),RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(107898511,0))
	end
end
function c107898511.accon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c107898511.acop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local g=Group.CreateGroup()
	local tg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local tc=tg:GetFirst()
	if c:IsCanAddCounter(0x1009,3) then
		local atk=c:GetAttack()
		c:AddCounter(0x1009,3)
		if atk>0 and c:IsAttack(0) then
			g:AddCard(c)
		end
	end
	while tc~=nil do
		if tc:IsCanAddCounter(0x1009,3) then
			local atk=tc:GetAttack()
			local y=tc:AddCounter(0x1009,3)
			if atk>0 and tc:IsAttack(0) then
				g:AddCard(tc)
			end
		end
		tc=tg:GetNext()
	end
	if g:GetCount()>0 then
		Duel.RaiseEvent(g,EVENT_CUSTOM+54306223,e,0,0,0,0)
	end
end