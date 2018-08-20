--幻念的华暇
function c65020008.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP,EVENT_SPSUMMON_SUCCESS)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetTargetRange(1,0)
	e0:SetTarget(c65020008.splimit)
	c:RegisterEffect(e0)
	--back
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c65020008.pthcon)
	e1:SetTarget(c65020008.pthtg)
	e1:SetOperation(c65020008.pthop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65020008,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,65020008)
	e2:SetCondition(c65020008.pcon)
	e2:SetTarget(c65020008.ptg)
	e2:SetOperation(c65020008.pop)
	c:RegisterEffect(e2)
	--handquick
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_HAND)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,65020108)
	e3:SetCost(c65020008.hdcost)
	e3:SetTarget(c65020008.hdtg)
	e3:SetOperation(c65020008.hdop)
	c:RegisterEffect(e3)
end
function c65020008.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x9da1) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c65020008.mifil(c)
	return c:IsSetCard(0x9da1) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end

function c65020008.hdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() and Duel.IsExistingMatchingCard(c65020008.mifil,tp,LOCATION_HAND,0,2,c) end
	local g=Duel.SelectMatchingCard(tp,c65020008.mifil,tp,LOCATION_HAND,0,2,2,c)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	Duel.ShuffleHand(tp)
end
function c65020008.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end

function c65020008.hdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end

function c65020008.pthcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end

function c65020008.pthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end

function c65020008.pthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end

function c65020008.pcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x9da1)
end
function c65020008.pfilter(c,e,tp,scl1,scl2)
	return c:IsSetCard(0x9da1) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetLevel()>scl1 and c:GetLevel()<scl2 and c:IsFaceup()
end
function c65020008.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
		local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
		if not tc1 or not tc2 then return false end
		local scl1=tc1:GetLeftScale()
		local scl2=tc2:GetRightScale()
		if scl1>scl2 then scl1,scl2=scl2,scl1 end
		return Duel.IsExistingMatchingCard(c65020008.pfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,scl1,scl2) and Duel.GetLocationCountFromEx(tp)>0 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c65020008.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp)<=0 or not c:IsRelateToEffect(e) then return end
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
		local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
		if not tc1 or not tc2 then return false end
		local scl1=tc1:GetLeftScale()
		local scl2=tc2:GetRightScale()
		if scl1>scl2 then scl1,scl2=scl2,scl1 end
	local num=Duel.GetLocationCountFromEx(tp)
	local num2=Duel.GetMatchingGroupCount(c65020008.pfilter,tp,LOCATION_EXTRA,0,nil,e,tp,scl1,scl2)
	if num>num2 then num=num2 end
	local g=Duel.SelectMatchingCard(tp,c65020008.pfilter,tp,LOCATION_EXTRA,0,num,num,nil,e,tp,scl1,scl2)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.BreakEffect()
			Duel.Destroy(c,REASON_EFFECT)
		end
	end
end
