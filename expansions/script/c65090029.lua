--星之骑士拟身 火炎
function c65090029.initial_effect(c)
	--fusion material
	c:SetSPSummonOnce(65090029)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,65090001,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),1,true,true)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCondition(c65090029.condition)
	e1:SetTarget(c65090029.target)
	e1:SetOperation(c65090029.operation)
	c:RegisterEffect(e1)
end
function c65090029.condition(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c65090029.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return true end
	local g=bc:GetColumnGroup(1,1):Filter(Card.IsControler,bc,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),1-tp,LOCATION_ONFIELD)
end
function c65090029.operation(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	local g=bc:GetColumnGroup(1,1):Filter(Card.IsControler,bc,1-tp)
	Duel.Destroy(g,REASON_EFFECT)
end