--暮色居城 祈求
function c65020047.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(9)
	e1:SetCondition(c65020047.spcon)
	c:RegisterEffect(e1)
	--clean
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c65020047.con)
	e2:SetTarget(c65020047.tg)
	e2:SetOperation(c65020047.op)
	c:RegisterEffect(e2)
	--react
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,65020047)
	e3:SetCondition(c65020047.reacon)
	e3:SetTarget(c65020047.reatg)
	e3:SetOperation(c65020047.reaop)
	c:RegisterEffect(e3)
end
function c65020047.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)>=5 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c65020047.tdfil(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function c65020047.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+9
end
function c65020047.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c65020047.tdfil,tp,LOCATION_REMOVED,0,nil)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_REMOVED)
end
function c65020047.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(c65020047.tdfil,tp,LOCATION_REMOVED,0,nil)<3 then return end
	local g=Duel.SelectMatchingCard(tp,c65020047.tdfil,tp,LOCATION_REMOVED,0,3,3,nil)
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)==3 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(65020047,0)) then
		Duel.BreakEffect()
		local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,1,nil)
		if g2:GetCount()>0 then
			Duel.Remove(g2,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function c65020047.reafil(c)
	return c:IsSetCard(0x5da1) and c:IsAbleToHand()
end
function c65020047.reacon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,1,nil)
end
function c65020047.reatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020047.reafil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65020047.reaop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65020047.reafil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end