--翁德兰 埋骨荒原
function c75646718.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c75646718.actcon)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c75646718.reptg)
	e2:SetValue(c75646718.repval)
	e2:SetOperation(c75646718.repop)
	c:RegisterEffect(e2)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e2:SetLabelObject(g)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75646725,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,75646718)
	e3:SetCost(c75646718.cost)
	e3:SetTarget(c75646718.tg)
	e3:SetOperation(c75646718.op)
	c:RegisterEffect(e3)
end
c75646718.card_code_list={75646700}
function c75646718.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,75646701)~=0
end
function c75646718.repfilter(c,tp)
	return c:IsFaceup() and aux.IsCodeListed(c,75646700) and c:IsLocation(LOCATION_MZONE)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and c:GetFlagEffect(75646718)==0
end
function c75646718.desfilter(c,e)
	return c:IsCode(75646700) and c:IsDestructable(e)
		and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c75646718.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=eg:FilterCount(c75646718.repfilter,nil,tp)
	if chk==0 then return ct>0
		and Duel.IsExistingMatchingCard(c75646718.desfilter,tp,LOCATION_HAND+LOCATION_DECK,0,ct,nil,e) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local tg=Duel.SelectMatchingCard(tp,c75646718.desfilter,tp,LOCATION_HAND+LOCATION_DECK,0,ct,ct,nil,e)
		local g=e:GetLabelObject()
		g:Clear()
		local tc=tg:GetFirst()
		while tc do
			tc:RegisterFlagEffect(75646718,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
			tc:SetStatus(STATUS_DESTROY_CONFIRMED,true)
			g:AddCard(tc)
			tc=tg:GetNext()
		end
		return true
	else return false end
end
function c75646718.repval(e,c)
	return c75646718.repfilter(c,e:GetHandlerPlayer())
end
function c75646718.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,1-tp,75646718)
	local tg=e:GetLabelObject()
	local tc=tg:GetFirst()
	while tc do
		tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
		tc=tg:GetNext()
	end
	Duel.Destroy(tg,REASON_EFFECT+REASON_REPLACE)
end
function c75646718.filter(c,tp)
	return c:IsCode(75646701) and c:GetActivateEffect() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c75646718.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646718.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tp) end
end
function c75646718.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75646716.filter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
endnd