--聚镒素 焚地巨兽
function c10110010.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c10110010.ffilter1,c10110010.ffilter2,true)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c10110010.efilter)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetOperation(c10110010.desop)
	c:RegisterEffect(e2)
end
function c10110010.ffilter1(c,fc,sub,mg,sg)
	return c:IsFusionAttribute(ATTRIBUTE_FIRE) and (c:IsFusionSetCard(0x9332) or not sg or sg:IsExists(c10110010.ffilter3,1,nil,ATTRIBUTE_EARTH))
end
function c10110010.ffilter2(c,fc,sub,mg,sg)
	return c:IsFusionAttribute(ATTRIBUTE_EARTH) and (c:IsFusionSetCard(0x9332) or not sg or sg:IsExists(c10110010.ffilter3,1,nil,ATTRIBUTE_FIRE))
end
function c10110010.ffilter3(c,att)
	return c:IsFusionAttribute(att) and c:IsFusionSetCard(0x9332)
end
function c10110010.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsAttackBelow(e:GetHandler():GetDefense())
end
function c10110010.desop(e,tp,eg,ep,ev,re,r,rp)
	local at,c=Duel.GetAttackTarget(),e:GetHandler()
	if at and at:IsRelateToBattle() and c:IsRelateToBattle() and at:IsAttackBelow(c:GetDefense()) then
	   Duel.Hint(HINT_CARD,0,10110010)
	   Duel.Destroy(at,REASON_EFFECT)
	end
end