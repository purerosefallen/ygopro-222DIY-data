--星之骑士拟身 割裂
function c65090036.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,65090001,aux.FilterBoolFunction(Card.IsSetCard,0xda6),1,true,true)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c65090036.dacon)
	c:RegisterEffect(e1)
end
function c65090036.filter(c,atk)
	return c:IsFacedown() or c:GetAttack()<atk
end
function c65090036.dacon(e)
	return not Duel.IsExistingMatchingCard(c65090036.filter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil,e:GetHandler():GetAttack())
end