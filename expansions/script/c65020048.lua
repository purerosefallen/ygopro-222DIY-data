--暮色居城 空想
function c65020048.initial_effect(c)
	c:SetSPSummonOnce(65020048)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(9)
	e1:SetCondition(c65020048.spcon)
	c:RegisterEffect(e1)
	--clean
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c65020048.con)
	e2:SetTarget(c65020048.tg)
	e2:SetOperation(c65020048.op)
	c:RegisterEffect(e2)
	--react
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,65020048)
	e3:SetCondition(c65020048.reacon)
	e3:SetTarget(c65020048.reatg)
	e3:SetOperation(c65020048.reaop)
	c:RegisterEffect(e3)
end
function c65020048.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)>=8 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c65020048.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+9
end
function c65020048.tdfil(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function c65020048.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,5,tp,LOCATION_REMOVED)
end
function c65020048.op(e,tp,eg,ep,ev,re,r,rp)
	local num=5
	if Duel.GetMatchingGroupCount(c65020048.tdfil,tp,LOCATION_REMOVED,0,nil)<5 then num=Duel.GetMatchingGroupCount(c65020048.tdfil,tp,LOCATION_REMOVED,0,nil) end
	local g=Duel.SelectMatchingCard(tp,c65020048.tdfil,tp,LOCATION_REMOVED,0,num,num,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c65020048.reafil(c)
	return c:IsSetCard(0x5da1) and c:IsAbleToHand()
end
function c65020048.reacon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,1,nil)
end
function c65020048.reatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020048.reafil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c65020048.reaop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65020048.reafil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
