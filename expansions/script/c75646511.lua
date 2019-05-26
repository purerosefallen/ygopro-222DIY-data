--幻梦歌剧 柯罗伊
function c75646511.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c75646511.lcheck)
	c:EnableReviveLimit()
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75646511,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c75646511.cttg)
	e1:SetOperation(c75646511.ctop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75646511,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c75646511.tg)
	e2:SetOperation(c75646511.op)
	c:RegisterEffect(e2)
	--boost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(600)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
end
function c75646511.lcheck(g)
	return g:GetClassCount(Card.GetLinkRace)==1 and g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function c75646511.ctfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x12c3,1)
end
function c75646511.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646511.ctfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x12c3)
end
function c75646511.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c75646511.ctfilter,tp,0,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x12c3,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(c75646511.atkcon)
		e1:SetValue(-1000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetValue(c75646511.damval)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	Duel.RegisterFlagEffect(tp,75646511,RESET_PHASE+PHASE_END,0,1)
end
function c75646511.atkcon(e)
	return e:GetHandler():GetCounter(0x12c3)>0
end
function c75646511.damval(e,re,val,r,rp,rc)
	local tp=e:GetHandlerPlayer()
	if Duel.GetFlagEffect(tp,75646511)==0 or bit.band(r,REASON_BATTLE+REASON_EFFECT)==0 then return val end
	Duel.ResetFlagEffect(tp,75646511)
	return val*2
end
function c75646511.setfilter(c)
	return c:IsCode(75646510) and c:IsSSetable()
end
function c75646511.damfilter(c)
	return c:GetCounter(0x12c3)>0
end
function c75646511.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c75646511.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c75646511.damfilter,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(75646511,2),aux.Stringid(75646511,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(75646511,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(75646511,3))+1
	end
	e:SetLabel(op)
	if op==1 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,1,0,0)
	end
end
function c75646511.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75646511.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
			Duel.ConfirmCards(1-tp,g)
		end
	else
		local tp=e:GetHandlerPlayer()
		local g=Duel.GetMatchingGroup(c75646511.damfilter,tp,0,LOCATION_ONFIELD,nil)
		local t=g:GetFirst()
		local sum=0
		while t do
			local sct=t:GetCounter(0x12c3)
			t:RemoveCounter(tp,0x12c3,t:GetCounter(0x12c3),REASON_EFFECT)
			sum=sum+sct
			t=g:GetNext()
		end
		Duel.Damage(1-tp,sum*300,REASON_EFFECT)
	end
end