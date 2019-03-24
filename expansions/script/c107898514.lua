
function c107898514.initial_effect(c)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(107898514,1))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c107898514.cost)
	e1:SetTarget(c107898514.target)
	e1:SetOperation(c107898514.operation)
	c:RegisterEffect(e1)
end
function c107898514.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x575)
end
function c107898514.filter(c)
	return c:IsCode(107898102) and c:IsFaceup()
end
function c107898514.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLevel()==1
	or Duel.IsCanRemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	and not e:GetHandler():IsPublic() end
	if e:GetHandler():GetLevel()>1 then
		Duel.RemoveCounter(tp,1,0,0x1,math.floor(e:GetHandler():GetLevel()/2),REASON_COST)
	end
end
function c107898514.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c107898514.filter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToRemove(tp) and Duel.IsExistingTarget(c107898514.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c107898514.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c107898514.operation(e,tp,eg,ep,ev,re,r,rp)
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
		--add counter
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(107898514,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCategory(CATEGORY_COUNTER)
		e1:SetCode(EVENT_DAMAGE_STEP_END)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(c107898514.atcon)
		e1:SetOperation(c107898514.atop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		tc:RegisterFlagEffect(tc:GetCode(),RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(107898514,0))
	end
end
function c107898514.atcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	return a:IsSetCard(0x575a) and a:IsControler(tp) 
	and ((at and at:IsRelateToBattle() and at:IsCanAddCounter(0x1009,1)) or (at==nil and e:GetHandler():IsCanAddCounter(0x1009,1)))
end
function c107898514.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local at=Duel.GetAttackTarget()
	local g=Group.CreateGroup()
	if at and at:IsRelateToBattle() and at:IsCanAddCounter(0x1009,1) then
		local atk=at:GetAttack()
		at:AddCounter(0x1009,1)
		if atk>0 and at:IsAttack(0) then
			g:AddCard(at)
		end
	end
	if at==nil and c:IsCanAddCounter(0x1009,1) then 
		local atk=c:GetAttack()
		c:AddCounter(0x1009,1)
		if atk>0 and c:IsAttack(0) then
			g:AddCard(c)
		end
	end
	if g:GetCount()>0 then
		Duel.RaiseEvent(g,EVENT_CUSTOM+54306223,e,0,0,0,0)
	end
end