--Color of Sollow
function c81012030.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetTarget(c81012030.sumlimit)
	c:RegisterEffect(e3)
	--discard & salvage
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_END_PHASE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,81012030)
	e5:SetCondition(c81012030.thcon)
	e5:SetCost(c81012030.thcost)
	e5:SetTarget(c81012030.thtg)
	e5:SetOperation(c81012030.thop)
	c:RegisterEffect(e5)
end
function c81012030.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	local sc=se:GetHandler()
	return not (sc:IsType(TYPE_RITUAL) and sc:IsType(TYPE_SPELL)) 
		and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c81012030.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_RITUAL)
end
function c81012030.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81012030.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c81012030.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c81012030.thfilter(c)
	return c:IsType(TYPE_RITUAL) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_PENDULUM)) and c:IsAbleToHand()
end
function c81012030.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local ct=hg:GetCount()
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(c81012030.thfilter,tp,LOCATION_GRAVE,0,ct,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,hg,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct,tp,LOCATION_GRAVE)
end
function c81012030.thop(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local ct=Duel.SendtoGrave(hg,REASON_EFFECT+REASON_DISCARD)
	if ct<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81012030.thfilter,tp,LOCATION_GRAVE,0,ct,ct,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
