--武的體現 湊斗光
function c62501004.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,62501004)
 --   e1:SetCondition(c62501004.drcon)
	e1:SetTarget(c62501004.drtg)
	e1:SetOperation(c62501004.drop)
	c:RegisterEffect(e1)
local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2) 
local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
 --   e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetRange(LOCATION_HAND)
 --   e3:SetTarget(c62501004.atktg)
	e3:SetCost(c62501004.cost)
	e3:SetOperation(c62501004.operation)
	c:RegisterEffect(e3)
end
function c62501004.cfilter(c)
	return c:IsSetCard(0x624) and c:IsLocation(LOCATION_SZONE) and c:IsFaceup()
end
function c62501004.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c62501004.cfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c62501004.drop(e,tp,eg,ep,ev,re,r,rp)
	local dt=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dt==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.GetMatchingGroup(c62501004.cfilter,tp,LOCATION_SZONE,0,nil)
	local ct=cg:GetCount()
	Duel.Draw(tp,ct,REASON_EFFECT)
end
function c62501004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c62501004.filter(c)
	return c:IsFaceup() 
end
function c62501004.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c62501004.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c62501004.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c62501004.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c62501004.filter1(c,tp)
	return  c:IsAbleToRemove()	 
end
function c62501004.gvfilter(c,e,tp)
	return c:IsDefenseBelow(400) and c:IsRace(RACE_WARRIOR)
end
function c62501004.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectTarget(tp,c62501004.filter1,tp,0,LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	local g=Duel.SelectMatchingCard(tp,c62501004.gvfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
end
end