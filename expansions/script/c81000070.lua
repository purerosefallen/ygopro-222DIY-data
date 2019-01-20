--Impossibile amoris
function c81000070.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81000070+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81000070.condition)
	e1:SetTarget(c81000070.target)
	e1:SetOperation(c81000070.activate)
	c:RegisterEffect(e1)
end
function c81000070.cfilter(c)
	return c:IsFaceup() and c:IsCode(81008004)
end
function c81000070.dfilter(c)
	return c:IsFaceup() and c:IsCode(81000016)
end
function c81000070.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81000070.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c81000070.dfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c81000070.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c81000070.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
