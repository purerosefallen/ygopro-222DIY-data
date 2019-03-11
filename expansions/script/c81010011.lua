--废墟之下的凝视
function c81010011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c81010011.acttg)
	e1:SetOperation(c81010011.actop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_EFFECT))
	e2:SetValue(-1000)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(c81010011.discon)
	e5:SetOperation(c81010011.disop)
	c:RegisterEffect(e5)
	--cannot attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetCondition(c81010011.limcon)
	e6:SetTarget(c81010011.atlimit)
	c:RegisterEffect(e6)
end
function c81010011.desfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsType(TYPE_MONSTER)
end
function c81010011.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c81010011.desfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c81010011.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c81010011.desfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c81010011.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function c81010011.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c81010011.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)>2
		and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsType(TYPE_EFFECT)
end
function c81010011.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c81010011.limcon(e)
	return Duel.GetMatchingGroupCount(c81010011.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)>2
end
function c81010011.atlimit(e,c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
