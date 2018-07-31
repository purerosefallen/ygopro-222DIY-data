--Dreamer×Dreamer
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400035.initial_effect(c)
	--activate from hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(yume.nonYumeCon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c71400035.op1)
	e1:SetTarget(yume.YumeFieldCheckTarget())
	e1:SetHintTiming(0,0x1f0)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c71400035.con2)
	e2:SetOperation(c71400035.op2)
	c:RegisterEffect(e2)
end
function c71400035.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(71400035,2))
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71400035,1))
	local tc=Duel.SelectMatchingCard(tp,yume.FieldActivationFilter,tp,LOCATION_DECK,0,1,1,nil,tp,0,0):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		local id=yume.temp_card_field[tc].id or 0
		--Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_DECKBOT)
		tc:RegisterEffect(e1,true)
	end
end
function c71400035.con2(e,tp,eg,ep,ev,re,r,rp)
	return not re:GetHandler():IsSetCard(0x714)
end
function c71400035.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end