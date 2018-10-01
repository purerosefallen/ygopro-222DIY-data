--无量
function c65071110.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65071110+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c65071110.cost)
	e1:SetTarget(c65071110.target)
	e1:SetOperation(c65071110.activate)
	c:RegisterEffect(e1)
end

function c65071110.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_MZONE,0,1,nil) end
	local num=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local dec=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dec<num then num=dec end
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_MZONE,0,1,num,nil)
	local ct=g:GetCount()
	e:SetLabel(ct)
	Duel.SendtoGrave(g,REASON_COST)
end

function c65071110.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,e:GetLabel()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,tp,e:GetLabel())
end

function c65071110.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end