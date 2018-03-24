--不给糖就导弹
function c22201201.initial_effect(c)
	--ACTIVATE
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Treat or Beat
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c22201201.condition)
	e1:SetTarget(c22201201.target)
	e1:SetOperation(c22201201.operation)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c22201201.econ)
	e2:SetValue(c22201201.efilter)
	c:RegisterEffect(e2)
end
function c22201201.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c22201201.atkfilter1(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsAttackable() and Duel.IsExistingTarget(Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_FACEUP_ATTACK)
end
function c22201201.atkfilter2(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsAttackable() and Duel.IsExistingTarget(Card.IsPosition,tp,LOCATION_MZONE,0,1,nil,POS_FACEUP_ATTACK)
end
function c22201201.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local a=Duel.IsExistingTarget(c22201201.atkfilter1,tp,LOCATION_MZONE,0,1,nil)
	local b=Duel.IsExistingTarget(c22201201.atkfilter2,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return a or b end
	if a then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g1=Duel.SelectTarget(tp,c22201201.atkfilter1,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g2=Duel.SelectTarget(tp,Card.IsPosition,tp,0,LOCATION_MZONE,1,1,nil,POS_FACEUP_ATTACK)
		g1:Merge(g2)
		Duel.SetOperationInfo(0,0,g1,g1:GetCount(),0,0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g1=Duel.SelectTarget(tp,c22201201.atkfilter2,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g2=Duel.SelectTarget(tp,Card.IsPosition,tp,LOCATION_MZONE,0,1,1,nil,POS_FACEUP_ATTACK)
		g1:Merge(g2)
		Duel.SetOperationInfo(0,0,g1,g1:GetCount(),0,0)
	end
end
function c22201201.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local a=g:FilterCount(Card.IsRelateToEffect,nil,e)==2
	  and g:FilterCount(Card.IsFaceup,nil)==2
	  and g:FilterCount(Card.IsAttackable,nil)>0
	local tg=Duel.GetDecktopGroup(1-tp,1)
	local b=(tg:GetCount()>0 and tg:GetFirst():IsAbleToHand())
	local off=1
	local ops={}
	local opval={}
	if a then
		ops[off]=aux.Stringid(22201201,0)
		opval[off-1]=1
		off=off+1
	end
	if b then
		ops[off]=aux.Stringid(22201201,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(1-tp,table.unpack(ops))
	local sel=opval[op]
	if sel==1 then
		local ac=g:Filter(Card.IsAttackable,nil):GetFirst()
		local bc=g:Filter(aux.TRUE,ac):GetFirst()
		Duel.CalculateDamage(ac,bc)
	elseif sel==2 then
		tc=Duel.GetDecktopGroup(1-tp,1):GetFirst()
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c22201201.econ(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c22201201.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end