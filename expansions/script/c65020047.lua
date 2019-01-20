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
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c65020047.con)
	e2:SetTarget(c65020047.tg)
	e2:SetOperation(c65020047.op)
	c:RegisterEffect(e2)
	--react
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
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
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function c65020047.op(e,tp,eg,ep,ev,re,r,rp)
	local num=3
	if Duel.GetMatchingGroupCount(c65020047.tdfil,tp,LOCATION_REMOVED,0,nil)<3 then num=Duel.GetMatchingGroupCount(c65020047.tdfil,tp,LOCATION_REMOVED,0,nil) end
	local g=Duel.SelectMatchingCard(tp,c65020047.tdfil,tp,LOCATION_REMOVED,0,num,num,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c65020047.reacon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,1,nil)
end
function c65020047.reatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65020047.tdfil,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsPlayerCanDraw(tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
end
function c65020047.reaop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c65020047.tdfil,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end