--星之骑士拟身 旋风
function c65090047.initial_effect(c)
	--fusion material
	c:SetSPSummonOnce(65090047)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,65090001,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),1,true,true)
	--attack up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c65090047.condition)
	e2:SetTarget(c65090047.target)
	e2:SetOperation(c65090047.operation)
	c:RegisterEffect(e2)
end
function c65090047.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRelateToBattle()
end
function c65090047.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,sg:GetCount(),0,0)
end
function c65090047.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if sg:GetCount()>0 then
		Duel.ChangePosition(sg,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
	end
end