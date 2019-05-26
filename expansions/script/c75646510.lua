--谢幕·终曲
function c75646510.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c75646510.condition)
	e1:SetTarget(c75646510.target)
	e1:SetOperation(c75646510.activate)
	c:RegisterEffect(e1)
end
function c75646510.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x32c3)
end
function c75646510.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c75646510.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c75646510.ctfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x12c3,1)
end
function c75646510.damfilter(c)
	return c:GetCounter(0x12c3)>0
end
function c75646510.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c75646510.ctfilter,tp,0,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingMatchingCard(c75646510.damfilter,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(75646510,0),aux.Stringid(75646510,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(75646510,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(75646510,1))+1
	end
	e:SetLabel(op)
	if op==1 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,1,0,0)
	end
end
function c75646510.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local g=Duel.GetMatchingGroup(c75646510.ctfilter,tp,0,LOCATION_ONFIELD,nil)
		local tc=g:GetFirst()
		while tc do
			tc:AddCounter(0x12c3,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetCondition(c75646510.atkcon)
			e1:SetValue(-1000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	else
		local tp=e:GetHandlerPlayer()
		local g=Duel.GetMatchingGroup(c75646510.damfilter,tp,0,LOCATION_ONFIELD,nil)
		local t=g:GetFirst()
		local sum=0
		while t do
			local sct=t:GetCounter(0x12c3)
			t:RemoveCounter(tp,0x12c3,t:GetCounter(0x12c3),REASON_EFFECT)
			sum=sum+sct
			t=g:GetNext()
		end
		Duel.Damage(1-tp,sum*400,REASON_EFFECT)
	end
end
function c75646510.atkcon(e)
	return e:GetHandler():GetCounter(0x12c3)>0
end