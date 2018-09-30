--星之骑士拟身 幽浮
function c65090038.initial_effect(c)
	--fusion material
	c:SetSPSummonOnce(65090038)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,false,65090001,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT))
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLED)
	e1:SetTarget(c65090033.target)
	e1:SetOperation(c65090033.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(c65090033.tgtg)
	e2:SetOperation(c65090033.tgop)
	c:RegisterEffect(e2)
end
function c65090033.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local t=Duel.GetAttackTarget()
	if chk==0 then
		return (a==c and t and t:IsControler(1-tp)) or (t and t==c and a:IsControler(1-tp))
	end
	local g=Group.CreateGroup()
	if a==c then 
		g:AddCard(t)
	elseif t==c then
		g:AddCard(a)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c65090033.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local g=Group.CreateGroup()
	if a==c then 
		g:AddCard(t)
	elseif t==c then
		g:AddCard(a)
	end
	local rg=g:Filter(Card.IsRelateToBattle,nil)
	Duel.Destroy(rg,REASON_EFFECT)
end
function c65090033.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end
function c65090033.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=tc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
		g:AddCard(tc)
		Duel.Destroy(g,REASON_EFFECT)
	end
end