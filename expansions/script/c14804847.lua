--IDOL 恋爱禁止条例
function c14804847.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,14804847+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--Immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c14804847.damcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_QUICK_F)
	e5:SetCode(EVENT_TO_HAND)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCondition(c14804847.condition2)
	e5:SetTarget(c14804847.target2)
	e5:SetOperation(c14804847.operation2)
	c:RegisterEffect(e5)
end
function c14804847.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4848)
end
function c14804847.damcon(e)
	return Duel.IsExistingMatchingCard(c14804847.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function c14804847.cfilter2(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) 
end
function c14804847.condition2(e,tp,eg,ep,ev,re,r,rp)
   return ep~=tp and bit.band(r,REASON_DRAW)==0 and re
		and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x4848) and eg:IsExists(c14804847.cfilter2,1,nil,1-tp)
end
function c14804847.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
end
function c14804847.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(1-tp,1)
		Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
		local tc=sg:GetFirst()
		if tc:IsType(TYPE_MONSTER) then
			Duel.Damage(1-tp,tc:GetLevel()*100,REASON_EFFECT)
			Duel.ShuffleDeck(1-tp)
		end
	end
end