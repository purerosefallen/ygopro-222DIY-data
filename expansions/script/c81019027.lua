--照常被吓个半死
function c81019027.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81019027)
	e1:SetCondition(c81019027.condition)
	e1:SetTarget(c81019027.target)
	e1:SetOperation(c81019027.activate)
	c:RegisterEffect(e1)
end
function c81019027.cfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c81019027.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81019027.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c81019027.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c81019027.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c81019027.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c81019027.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*500)
end
function c81019027.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81019027.filter,tp,LOCATION_MZONE,0,nil)
	local ct1=Duel.Destroy(g,REASON_EFFECT)
	if ct1==0 then return end
	local ct2=Duel.Draw(tp,ct1,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Damage(1-tp,ct2*500,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c81019027.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
end
function c81019027.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end