--tricoro·空鸽
function c81006302.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c81006302.drcon)
	e2:SetTarget(c81006302.drtg)
	e2:SetOperation(c81006302.drop)
	c:RegisterEffect(e2)
end
function c81006302.cfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_PENDULUM)
		and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c81006302.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81006302.cfilter,1,nil,tp)
end
function c81006302.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c81006302.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Draw(tp,1,REASON_EFFECT)
end
