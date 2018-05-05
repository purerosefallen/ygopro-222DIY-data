--虚幻法师的魔导少女
function c66913813.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c66913813.matfilter,2,3)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,66913813)
	e1:SetCondition(c66913813.spcon1)
	e1:SetTarget(c66913813.sptg1)
	e1:SetOperation(c66913813.spop1)
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66913803,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,66913814)
	e2:SetTarget(c66913813.thtg)
	e2:SetCost(c66913813.cost)
	e2:SetCondition(c66913813.con)
	e2:SetOperation(c66913813.thop)
	c:RegisterEffect(e2)	
end
function c66913813.matfilter(c)
	return c:IsLinkSetCard(0x371) 
end
function c66913813.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c66913813.filter(c)
	return  c:IsAbleToRemove()
end
function c66913813.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c66913813.filter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function c66913813.spop1(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,c66913813.filter,p,LOCATION_HAND,0,1,63,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-p,g)
		local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		Duel.ShuffleDeck(p)
		Duel.BreakEffect()
		Duel.Draw(p,ct+1,REASON_EFFECT)
	end
end
function c66913813.con(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)>=20
end
function c66913813.thfilter(c)
	return c:IsAbleToHand() and c:IsFaceup()
end
function c66913813.cfilter(c)
	return  c:IsAbleToRemoveAsCost()
end
function c66913813.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66913813.cfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.GetMatchingGroup(c66913813.cfilter,tp,LOCATION_HAND,0,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end  
function c66913813.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66913813.thfilter,tp,LOCATION_REMOVED,0,4,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,4,tp,LOCATION_REMOVED)
end
function c66913813.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66913813.thfilter,tp,LOCATION_REMOVED,0,1,4,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
