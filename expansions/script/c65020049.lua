--暮色居城 游离
function c65020049.initial_effect(c)
	c:SetSPSummonOnce(65020049)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(9)
	e1:SetCondition(c65020049.spcon)
	c:RegisterEffect(e1)
	--clean
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c65020049.con)
	e2:SetTarget(c65020049.tg)
	e2:SetOperation(c65020049.op)
	c:RegisterEffect(e2)
	--react
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,65020049)
	e3:SetCondition(c65020049.reacon)
	e3:SetTarget(c65020049.reatg)
	e3:SetOperation(c65020049.reaop)
	c:RegisterEffect(e3)
end
function c65020049.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)>=12 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c65020049.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+9
end
function c65020049.tdfil(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function c65020049.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c65020049.tdfil,tp,LOCATION_REMOVED,0,nil)>=7 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,7,tp,LOCATION_REMOVED)
end
function c65020049.op(e,tp,eg,ep,ev,re,r,rp)
	local num=7
	if Duel.GetMatchingGroupCount(c65020049.tdfil,tp,LOCATION_REMOVED,0,nil)<7 then num=Duel.GetMatchingGroupCount(c65020049.tdfil,tp,LOCATION_REMOVED,0,nil) end
	local g=Duel.SelectMatchingCard(tp,c65020049.tdfil,tp,LOCATION_REMOVED,0,num,num,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c65020049.reacon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,1,nil)
end
function c65020049.reafil(c)
	return c:IsAbleToHand() and c:IsSetCard(0x5da1)
end
function c65020049.reatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c65020049.reafil,tp,LOCATION_REMOVED,0,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c65020049.reaop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
	Duel.ConfirmCards(tp,sg)
	if sg:IsExists(c65020049.reafil,1,nil) then
		local g=sg:FilterSelect(tp,c65020049.reafil,1,1,nil)
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

